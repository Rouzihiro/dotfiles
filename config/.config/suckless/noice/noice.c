/* See LICENSE file for copyright and license details. */

#define _XOPEN_SOURCE 700
#define _XOPEN_SOURCE_EXTENDED 1

#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>

#include <curses.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <libgen.h>
#include <limits.h>
#include <locale.h>
#include <regex.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <strings.h>
#include <unistd.h>
#include <ctype.h>

#include "arg.h"

#define ISODD(x)   ((x) & 1)
#define CONTROL(c) ((c) ^ 0x40)
#define META(c)    ((c) ^ 0x80)
#define MIN(x, y)  ((x) < (y) ? (x) : (y))
#define MAX(x, y)  ((x) > (y) ? (x) : (y))
#define LEN(x)     (sizeof(x) / sizeof(*(x)))
#define NARGS      32
#define KEY_ESC    033
#define KEY_DEL    0177

#if defined(__linux__)
#include <sys/inotify.h>
#define EVMASK     (IN_CREATE | IN_DELETE | IN_DELETE_SELF | IN_ATTRIB \
		| IN_MODIFY | IN_MOVE_SELF | IN_MOVED_FROM | IN_MOVED_TO)
#endif


enum actions {
	/* these at the top are used for indexing a config array */
	SEL_DSORT = 1, SEL_MTIME, SEL_SIZE, SEL_SSIZE, SEL_VERS,
	SEL_QUIT, SEL_BACK, SEL_GOIN, SEL_FLTR, SEL_NEXT, SEL_PREV,
	SEL_PGDN, SEL_PGUP, SEL_LAST, SEL_FIRST, SEL_JUMP, SEL_MARK,
	SEL_YANK, SEL_UNYANK, SEL_RM, SEL_LN, SEL_CP, SEL_MV, SEL_CD,
	SEL_NEW, SEL_RENAME, SEL_REDRAW, SEL_RUN, SEL_RUNARG, SEL_DOTS,
};

enum recursion_type {
	DEPTH = 0,
	BREADTH = 1,
};

typedef struct entry entry;
typedef struct dirjump dirjump;
typedef struct keybind keybind;
typedef struct filetype filetype;
typedef struct filerule filerule;
typedef struct colourpair colourpair;
typedef struct savedentry savedentry;


struct keybind {
	int sym;
	enum actions act;
	char *run, *env;
};

struct entry {
	int marked;
	mode_t mode;
	time_t mtime;
	long long size;
	char name[NAME_MAX];
};

struct dirjump {
	int key;
	char *path;
};

struct filetype {
	int idchar;
	unsigned int ftmask, colourmask;
};

struct filerule {
	char *regex, *argv;
	regex_t regcomp;
};

struct colourpair {
	int fg, bg;
};

struct savedentry {
	mode_t mode;
	char name[NAME_MAX];
};

struct colourpair colours[] = {
	{ .fg = 0, .bg = 0 }, /* pairs start at 1 */
	{ COLOR_RED,  -1 }, { COLOR_GREEN,   -1 }, { COLOR_YELLOW, -1 },
	{ COLOR_BLUE, -1 }, { COLOR_MAGENTA, -1 }, { COLOR_CYAN,   -1 },
};

uid_t uuid;
entry *dents;
savedentry *sdents;
char *savefile = "/tmp/noicedir";
char tempfile[] = "/tmp/noice.XXXXXX";
int ndents, nsdents, cur, idle, conf[6], nmarked = 0, longest = 0, inotify, watch;
char *argv0, hist[3][PATH_MAX], lastdir[PATH_MAX], msg[LINE_MAX], sdpath[PATH_MAX];

#include "noice.h"

void info(char *fmt, ...)
{
	char buf[LINE_MAX];
	va_list ap;

	mvprintw(LINES - 1, 0, "%*c", COLS, ' ');
	va_start(ap, fmt);
	vsnprintf(buf, sizeof(buf), fmt, ap); // NOLINT
	va_end(ap);
	mvprintw(LINES - 1, 0, fmt, buf);
}

void warn(char *fmt, ...)
{
	char buf[LINE_MAX];
	va_list ap;

	va_start(ap, fmt);
	vsnprintf(buf, sizeof(buf), fmt, ap); // NOLINT
	va_end(ap);
	mvprintw(LINES - 1, 0, "%s: %s\n", buf, strerror(errno));
}

void fatal(char *fmt, ...)
{
	va_list ap;

	endwin();
	va_start(ap, fmt);
	vfprintf(stderr, fmt, ap);
	fprintf(stderr, ": %s\n", strerror(errno));
	va_end(ap);
	exit(1);
}

size_t strlcat(char *dst, const char *src, size_t size)
{
	size_t n = size, dlen;
	const char *odst = dst;
	const char *osrc = src;

	while (n-- != 0 && *dst != '\0')
		dst++;
	dlen = dst - odst;
	n = size - dlen;

	if (n-- == 0)
		return dlen + strlen(src);
	while (*src != '\0') {
		if (n != 0) {
			*dst++ = *src;
			n--;
		}
		src++;
	}
	*dst = '\0';

	return dlen + (src - osrc);
}

size_t strlcpy(char *dst, const char *src, size_t size)
{
	size_t n = size;
	const char *osrc = src;

	if (n != 0)
		while (--n != 0)
			if ((*dst++ = *src++) == '\0')
				break;
	if (n == 0) {
		if (size != 0)
			*dst = '\0';
		while (*src++);
	}
	return src - osrc - 1;
}

int strvcmp(const char *str1, const char *str2)
{
	size_t i1 = 0, i2 = 0;
	size_t len1 = strlen(str1), len2 = strlen(str2);

	for (; i1 < len1 && i2 < len2; i1++, i2++) {
		unsigned char c1 = str1[i1], c2 = str2[i2];
		if (isdigit(c1) && isdigit(c2)) {
			unsigned long long int num1, num2;
			char *end1, *end2;
			num1 = strtoull(str1 + i1, &end1, 10);
			num2 = strtoull(str2 + i2, &end2, 10);
			if (num1 < num2)
				return -1;
			if (num1 > num2)
				return 1;
			i1 = end1 - str1 - 1;
			i2 = end2 - str2 - 1;
			if (i1 < i2)
				return -1;
			if (i1 > i2)
				return 1;
		} else {
			if (tolower(c1) < tolower(c2))
				return -1;
			if (tolower(c1) > tolower(c2))
				return 1;
		}
	}
	if (len1 < len2)
		return -1;
	if (len1 > len2)
		return 1;
	return 0;
}

int freesdents()
{
	if (!nsdents)
		return -1;
	free(sdents);
	*sdpath = '\0';
	sdents = NULL;
	return (nsdents = 0);
}

void initrules()
{
	unsigned int i;
	char errbuf[NAME_MAX];

	for (i = 0; i < LEN(filerules); i++) {
		int r;
		if ((r = regcomp(&filerules[i].regcomp, filerules[i].regex, REG_NOSUB|REG_EXTENDED|REG_ICASE)) != 0) {
			regerror(r, &filerules[i].regcomp, errbuf, sizeof(errbuf));
			fprintf(stderr, "invalid regex filerules[%u]: %s: %s\n", i, filerules[i].regex, errbuf);
			exit(1);
		}
	}
}

void initcolour(void)
{
	unsigned int i;

	start_color();
	use_default_colors();
	for (i = 1; i < LEN(colours); i++)
		init_pair(i, colours[i].fg, colours[i].bg);
}

void initcurses(void)
{

	if (initscr() == NULL) {
		char *term;
		if ((term = getenv("TERM")) != NULL)
			fprintf(stderr, "error opening terminal: %s\n", term);
		else
			fprintf(stderr, "failed to initialize curses\n");
		exit(1);
	}
	if (usecolour && has_colors())
		initcolour();
	cbreak();
	noecho();
	nonl();
	intrflush(stdscr, FALSE);
	keypad(stdscr, TRUE);
	curs_set(FALSE); /* Hide cursor */
	timeout(1000); /* One second */
	mousemask(BUTTON4_PRESSED|BUTTON5_PRESSED, NULL);
}

int xgetch(char *prompt)
{
	int c, oesc = ESCDELAY;

	ESCDELAY = 100;
	info("%s", prompt);
	c = wgetch(stdscr);
	mvprintw(LINES - 1, 0, "%*c", COLS);
	ESCDELAY = oesc;
	return c;
}

char *readln(char *prompt, char *initial)
{
	int n, max;
	int c, i, oesc = ESCDELAY;
	int ilen = 0, plen = strlen(prompt);
	static char line[LINE_MAX];

	ESCDELAY = 100;
	memset(line, 0, sizeof(line)); // NOLINT
	if (initial && (ilen = strlen(initial)))
		strlcpy(line, initial, sizeof(line));
	mvprintw(LINES - 1, 0, "%s%s", prompt, line);
	n = max = ilen;
	timeout(-1);
	curs_set(TRUE);
	keypad(stdscr, 1);
	while ((c = wgetch(stdscr)) != ERR && max < LINE_MAX - 1) {
		if (c == KEY_ENTER || c == KEY_EOL || c == '\n' || c == '\r')
			break;
		if (c == KEY_ESC) {
			line[0] = '\0';
			break;
		} else if (n && c == KEY_LEFT) {
			n--;
		} else if (n < max && c == KEY_RIGHT) {
			n++;
		} else if (c >= 32 && c <= 126) { /* printable ASCII */
			if (line[n] != '\0') /* shift everything ahead of the cursor forward */
				for (i = max; i >= n; i--)
					line[i + 1] = line[i];
			line[n++] = c;
			max++;
		} else if (n && max && (c == KEY_BACKSPACE || c == KEY_DEL || c == '\b')) {
			if (line[n] != '\0') { /* shift everything ahead of the cursor backward */
				for (i = n; i <= max; i++)
					line[i - 1] = line[i];
				line[max] = '\0';
			} else
				line[n - 1] = '\0';
			n--;
			max--;
		} else if (max && n < max && c == KEY_DC) {
			if (line[n + 1] != '\0') { /* shift everything ahead of the cursor backward */
				for (i = n + 1; i <= max; i++)
					line[i - 1] = line[i];
				line[max] = '\0';
			} else
				line[n] = '\0';
			max--;
		}
		mvprintw(LINES - 1, 0, "%s%s%*c", prompt, line, COLS - plen - max);
		wmove(stdscr, LINES - 1, plen + n);
	}
	mvprintw(LINES - 1, 0, "%*c", COLS);
	line[max] = '\0';
	curs_set(FALSE);
	timeout(1000);
	ESCDELAY = oesc;
	return line[0] ? line : NULL;
}

void *xmalloc(size_t size)
{
	void *p;

	if ((p = malloc(size)) == NULL)
		fatal("malloc");
	return p;
}

void *xrealloc(void *p, size_t size)
{
	void *tmp = p;
	if (!(tmp = realloc(tmp, size)))
		fatal("realloc");
	p = tmp;
	return p;
}

char *xgetenv(char *name, char *fallback)
{
	static char *value;

	if (!name)
		return fallback;
	value = getenv(name);
	return value && value[0] ? value : fallback;
}

char *mkpath(char *path, char *name, char *out, size_t n)
{
	if (name[0] == '/') {
		strlcpy(out, name, n); /* absolute path */
	} else {
		if (path[0] == '/' && path[1] == '\0') { /* root case */
			strlcpy(out, "/", n);
		} else {
			strlcpy(out, path, n);
			strlcat(out, "/", n);
		}
		strlcat(out, name, n);
	}
	return out;
}

void savecur(char *path, int cur, int histidx, int walk)
{
	int i = cur;

	if (ndents) {
		if (walk) {
			if (cur == ndents - 1) {
				for (; i > 0 && dents[i].marked; i--);
				if (i == 0 && dents[i].marked)
					for (i = cur; i < ndents && dents[i].marked; i++);
				if (i == ndents) i = 0;
			} else {
				for (; i < ndents && dents[i].marked; i++);
				if (i == ndents && dents[i].marked)
					for (i = cur; i > 0 && dents[i].marked; i--);
			}
		}
		mkpath(path, dents[i].name, hist[histidx], sizeof(hist[histidx]));
	}
}

int spawnvp(char *dir, char *argv[], int bg)
{
	pid_t pid;
	int status, r = 0;

	endwin();
	switch ((pid = fork())) {
	case -1:
		r = -1;
		break;
	case 0:
		if (dir != NULL && chdir(dir) == -1)
			exit(1);
		if (bg) {
			close(1); /* close stdout and stderr */
			close(2);
		}
		execvp(argv[0], argv);
		_exit(1);
	default:
		if (!bg) {
			while ((r = waitpid(pid, &status, 0)) == -1 && errno == EINTR)
				continue;
			if (r != -1 && WIFEXITED(status) && WEXITSTATUS(status) != 0)
				r = -1;
		}
	}
	refresh();
	return r;
}

int spawnlp(char *dir, char *file, ...)
{
	va_list ap;
	unsigned int n = 0, i = 0, bg = 0;
	char *argv[NARGS], *args[NARGS], *cmd, *tmp, buf[PATH_MAX];

	strlcpy(buf, file, sizeof(buf));
	va_start(ap, file);
	while (i + 1 < sizeof(args) && (args[i++] = va_arg(ap, char *)))
		;
	args[i] = NULL;
	va_end(ap);
	if ((cmd = strtok(buf, " \t"))) {
		argv[n++] = cmd;
		while (n < sizeof(argv) && (tmp = strtok(NULL, " \t")))
			argv[n++] = tmp;
		if ((bg = (argv[n - 1][0] == '&')))
			n--;
	}
	i = 0;
	while (n + 1 < sizeof(argv) && i < sizeof(args) && args[i])
		argv[n++] = args[i++];
	argv[n] = NULL;
	return spawnvp(dir, argv, bg);
}

int canopendir(char *path)
{
	DIR *d;

	if (!path || (d = opendir(path)) == NULL)
		return 0;
	closedir(d);
	return 1;
}

int xmkdir(char *path, int e)
{
	struct stat st;
	char *s, tmp[PATH_MAX];

	strlcpy(tmp, path, sizeof(tmp));
	for (s = tmp + 1; *s; s++) {
		if (*s == '/') {
			*s = '\0';
			if (mkdir(tmp, 0755) && errno != EEXIST)
				return -1;
			*s = '/';
		}
	}
	if (mkdir(path, 0755) && errno != EEXIST)
		return -1;
	if (e && !lstat(path, &st)) {
		if (!S_ISDIR(st.st_mode)) {
			errno = EEXIST;
			return -1;
		}
	}
	return 0;
}

int touch(char *path)
{
	int fd;
	char *s, tmp[PATH_MAX];

	strlcpy(tmp, path, sizeof(tmp));

	if (!*tmp)
		return 0;
	if ((s = strrchr(tmp, '/')) != NULL) {
		*s = '\0';
		if (xmkdir(tmp, 0))
			return -1;
		*s = '/';
	}
	if ((fd = open(tmp, O_RDWR|O_CREAT, 0666)) == -1)
		return -1;
	return close(fd);
}

int mv(char *path, char *src, char *dst)
{
	struct stat st;
	char *s, new[PATH_MAX], old[PATH_MAX];

	mkpath(path, src, old, sizeof(old));
	mkpath(path, dst, new, sizeof(new));
	if (!lstat(new, &st)) {
		errno = EEXIST;
		return -1;
	} else if ((s = strrchr(new, '/')) != NULL) {
		*s = '\0';
		if (xmkdir(new, 0)) return -1;
		*s = '/';
	}
#ifdef USE_LOADING
	info("moving: %s -> %s", old, new);
	refresh();
#endif
	return rename(old, new);
}

int ln(char *src, char *dst, struct stat *s)
{
	char buf[PATH_MAX];

	if (S_ISLNK(s->st_mode)) {
		ssize_t r;
		if ((r = readlink(src, buf, sizeof(buf) - 1)) < 0) return -1;
		buf[r] = '\0';
	} else {
		strlcpy(buf, src, sizeof(buf));
	}
#ifdef USE_LOADING
	info("linking: %s -> %s", buf, dst);
	refresh();
#endif
	return symlink(buf, dst);
}

int rm(char *src, char *dst, struct stat *s)
{
	(void)(dst);
#ifdef USE_LOADING
	info("removing: %s", src);
	refresh();
#endif
	return S_ISDIR(s->st_mode) ? rmdir(src) : unlink(src);
}

int cp(char *src, char *dst, struct stat *s)
{
	ssize_t nread;
	char buf[PATH_MAX];
	int err, sfd, dfd = -1;

	if (S_ISLNK(s->st_mode)) return ln(src, dst, s);
	if (S_ISDIR(s->st_mode)) return xmkdir(dst, 0);
	if ((sfd = open(src, O_RDONLY)) < 0) return -1;
	if ((dfd = open(dst, O_WRONLY|O_CREAT|O_TRUNC, S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH)) < 0)
		goto error;

#ifdef USE_LOADING
	int i = 0, percent = 0, len = MIN(COLS, (int)sizeof(msg));
	strlcpy(msg, "copying: ", len);
	strlcat(msg, src, len);
	int msglen = strlen(msg);
	int inc = (s->st_size / sizeof(buf)) / 100;
	while ((nread = read(sfd, buf, sizeof(buf))) > 0) {
		if (write(dfd, buf, nread) != nread) goto error;
		if (++i == inc) {
			int done = ++percent * (double)(COLS / 100.0);
			mvprintw(LINES - 1, 0, "%*c", COLS, ' ');
			attron(A_REVERSE);
			for (int j = 0; j < msglen; ) {
				mvprintw(LINES - 1, j, "%c", msg[j]);
				if (++j == done) attroff(A_REVERSE);
			}
			if (done > msglen) mvprintw(LINES - 1, msglen, "%*c", done - msglen, ' ');
			attroff(A_REVERSE);
			refresh();
			i = 0;
		}
	}
#else
	while ((nread = read(sfd, buf, sizeof(buf))) > 0)
		if (write(dfd, buf, nread) != nread) goto error;
#endif

	if (fchmod(dfd, s->st_mode) < 0 || (dfd = close(dfd)) < 0) goto error;
	close(sfd);
	return 0;

error:
	err = errno;
	close(sfd);
	if (dfd >= 0) close(dfd);
	unlink(dst);
	errno = err;
	return -1;
}

int fsrec(const char *src, const char *dst, int slen, int dlen,
		int depth, enum recursion_type type,
		int (*fn)(char *, char *, struct stat *))
{
	DIR *dir;
	struct stat st;
	struct dirent *e;
	int err, i = strlen(src);
	char s[PATH_MAX], d[PATH_MAX];

	strlcpy(s, src, sizeof(s));
	strlcpy(d, dst, sizeof(d));

	if (type == BREADTH && depth == 0) {
		strlcat(d, s + slen, sizeof(d));
		if (lstat(s, &st) || fn(s, d, &st)) return -1;
		d[dlen] = '\0';
	}
	if ((dir = opendir(s))) {
		while ((e = readdir(dir))) {
			if (e->d_name[0] == '.' && (e->d_name[1] == '\0'
						|| (e->d_name[1] == '.' && e->d_name[2] == '\0')))
				continue;
			s[i] = '/';
			s[i + 1] = '\0';
			strlcat(s, e->d_name, sizeof(s));
			strlcat(d, s + slen, sizeof(d));
			if (lstat(s, &st)) goto error;
			if (type == BREADTH && fn(s, d, &st)) goto error;
			if (S_ISDIR(st.st_mode))
				if (fsrec(s, dst, slen, dlen, depth + 1, type, fn)) goto error;
			if (type == DEPTH && fn(s, d, &st)) goto error;
			d[dlen] = s[i] = '\0';
		}
		closedir(dir);
	}
	if (type == DEPTH && depth == 0) {
		strlcat(d, s + slen, sizeof(d));
		if (lstat(s, &st) || fn(s, d, &st)) return -1;
	}
	return 0;

error:
	err = errno;
	closedir(dir);
	errno = err;
	return -1;
}

int xrename(char *path, char *editor, int cur)
{
	FILE *f;
	ssize_t n;
	size_t len = PATH_MAX;
	int i, j = 0, err = 0, fd = -1;
	char m[nmarked + 1][PATH_MAX];
	char tmpf[sizeof(tempfile) + 1];
	char *line, *argv[] = { editor, tmpf, NULL };

	line = xmalloc(len);
	strlcpy(tmpf, tempfile, sizeof(tmpf));
	if ((fd = mkstemp(tmpf)) < 0 || (f = fdopen(fd, "w")) == NULL) {
		free(line);
		return -1;
	}
	for (i = 0; i < ndents && j < nmarked; i++)
		if (dents[i].marked) {
			dents[i].marked = 0;
			fprintf(f, "%s\n", dents[i].name);
			strlcpy(m[j], dents[i].name, sizeof(m[j]));
			j++;
		}
	nmarked = 0;
	fclose(f);
	if (spawnvp(path, argv, 0) < 0 || (f = fopen(tmpf, "r")) == NULL) {
		free(line);
		return -1;
	}
	for (i = 0; i < j && (n = getline(&line, &len, f)) != -1; i++) {
		line[n] = '\0';
		if (line[n - 1] == '\n') line[--n] = '\0';
		if (i == cur) strlcpy(hist[0], line, sizeof(hist[0]));
		if (!strcmp(m[i], line) || !mv(path, m[i], line)) continue;
		err = errno;
		break;
	}
	free(line);
	fclose(f);
	if (fd >= 0) unlink(tmpf);
	if (err) { errno = err; return -1; }
	return 0;
}

int walksdents(char *path, int action)
{
	struct stat s, st;
	char src[PATH_MAX], dst[PATH_MAX];
	int i, j = strlen(path), l = strlen(sdpath);

#define prep(i)                                       \
	mkpath(sdpath, sdents[i].name, src, sizeof(src)); \
	mkpath(path,   sdents[i].name, dst, sizeof(dst)); \
	if (!lstat(dst, &st)) return -1;

	switch (action) {
	case SEL_CP:
		for (i = 0; i < nsdents; i++) {
			prep(i);
			if (fsrec(src, path, l, j, 0, BREADTH, cp)) return -1;
		}
		break;
	case SEL_MV:
		for (i = 0; i < nsdents; i++) {
			prep(i);
			if (rename(src, dst)) {
				if (errno != EXDEV) return -1;
				if (fsrec(src, path, l, j, 0, BREADTH, cp)) return -1;
				if (fsrec(src, path, l, j, 0, DEPTH,   rm)) return -1;
			}
		}
		break;
	case SEL_LN:
		for (i = 0; i < nsdents; i++) {
			prep(i);
			if (lstat(src, &s) || ln(src, dst, &s)) return -1;
		}
		break;
	}
	return 0;
#undef prep
}

int setfilter(regex_t *regex, char *filter)
{
	int r;

	if ((r = regcomp(regex, filter, REG_NOSUB|REG_EXTENDED|REG_ICASE)) != 0) {
		char errbuf[PATH_MAX];
		size_t len = COLS > (int)sizeof(errbuf) ? (int)sizeof(errbuf) : COLS;
		regerror(r, regex, errbuf, len);
		info("%s", errbuf);
	}
	return r;
}

int dircmp(mode_t a, mode_t b)
{
	if ( S_ISDIR(a) &&  S_ISDIR(b)) return 0;
	if (!S_ISDIR(a) && !S_ISDIR(b)) return 0;
	if (S_ISDIR(a)) return -1;
	return 1;
}

int entrycmp(const void *va, const void *vb)
{
	int d;
	long long i;
	const struct entry *a = va, *b = vb;

	if (conf[SEL_DSORT] && (d = dircmp(a->mode, b->mode)) != 0)
		i = d;
	else if (conf[SEL_MTIME])
		i = b->mtime - a->mtime;
	else if (conf[SEL_SIZE])
		i = b->size - a->size;
	else if (conf[SEL_VERS])
		i = strvcmp(*a->name == '.' ? a->name + 1 : a->name,
				*b->name == '.' ? b->name + 1 : b->name);
	else
		i = strcasecmp(*a->name == '.' ? a->name + 1 : a->name,
				*b->name == '.' ? b->name + 1 : b->name);
	return i > 0 ? 1 : i < 0 ? -1 : 0;
}

int nextsel(char **run, char **env)
{
	int c;
	MEVENT ev;

	if ((c = getch()) == 033)
		c = META(getch());
	if (c == KEY_MOUSE && getmouse(&ev) != OK)
		return 0;
	if (c == ERR) {
		idle++;
#if defined(__linux__)
		if (watch >= 0 && (idle & 1)) {
			char buf[PATH_MAX]__attribute__ ((aligned(__alignof__(struct inotify_event))));
			ssize_t i = read(inotify, buf, sizeof(buf));
			if (i == -1 && errno != EAGAIN) fatal("read");
			if (i > 0) {
				struct inotify_event *e;
				for (char *p = buf; p < buf + i; p += sizeof(struct inotify_event) + e->len) {
					e = (struct inotify_event *)p;
					if (e->mask & EVMASK) {
						idle = 0;
						return SEL_REDRAW;
					}
				}
			}
		}
#else
		if (redrawtime > 0 && idle >= redrawtime) {
			idle = 0;
			return SEL_REDRAW;
		}
#endif
	} else {
		idle = 0;
		for (unsigned int i = 0; i < LEN(keybinds); i++)
			if (c == keybinds[i].sym || (c == KEY_MOUSE && (ev.bstate & keybinds[i].sym))) {
				*run = keybinds[i].run;
				*env = keybinds[i].env;
				return keybinds[i].act;
			}
	}
	return 0;
}

char *entsize(struct entry *ent)
{
	static char out[NAME_MAX];

	*out = '\0';
	if (conf[SEL_SSIZE]) {
		if (ent->size < 1000) { /* <1 KB */
			snprintf(out, sizeof(out), "%lld B", ent->size); // NOLINT
		} else if (ent->size < 1024000) { /* <1 MB */
			snprintf(out, sizeof(out), "%.2f KB", ent->size / 1024.0); // NOLINT
		} else if (ent->size < 1024000000) { /* <1 GB */
			snprintf(out, sizeof(out), "%.2f MB", ent->size / 1024 / 1000.0); // NOLINT
		} else if (ent->size < 1024000000000) { /* <1 TB ( >= 1 TB size files? ) */
			snprintf(out, sizeof(out), "%.2f GB", ent->size / 1024 / 1000 / 1000.0); // NOLINT
		}
	}
	return out;
}

void printent(char *path, struct entry *ent, int active, int line)
{
	char *size;
	struct stat s;
	unsigned int i;
	char lnk[PATH_MAX + 4], ich[4], iich[4];
	int r, len, yank = 0, max = COLS - 2, attr = 0, nlen;
	char name[LINE_MAX], itmp[PATH_MAX], buf[PATH_MAX];

	if (!ent || !ent->name[0])
		return;
	lnk[0] = ich[0] = iich[0] = '\0';
	nlen = strlen(ent->name);
	len = nlen < max ? nlen + 1 : max;
	strlcpy(name, ent->name, len);
	for (i = 0; i < LEN(filetypes); i++)
		if ((ent->mode & S_IFMT) == filetypes[i].ftmask
				|| (filetypes[i].ftmask == S_IXUSR && (ent->mode & filetypes[i].ftmask)))
		{
			mkpath(path, name, itmp, sizeof(itmp));
			strlcpy(ich, (char *)&filetypes[i].idchar, sizeof(ich));
			len++;
			if (filetypes[i].ftmask != S_IFLNK) {
				attr |= filetypes[i].colourmask;
			} else if (stat(itmp, &s) == -1 && errno == ENOENT) {
				attr |= A_NORMAL | COLOR_PAIR(1);
			} else if ((r = readlink(itmp, buf, sizeof(buf) - 1)) >= 0) {
				if (S_ISDIR(s.st_mode)) {
					strlcat(ich, "/", sizeof(ich));
					len++;
				}
				attr |= filetypes[i].colourmask;
				buf[r] = '\0';
				len += strlen(buf) + 4;
				strlcpy(lnk, " -> ", sizeof(lnk));
				strlcat(lnk, buf, sizeof(lnk));
				if (lstat(buf, &s) != -1 && S_ISDIR(s.st_mode)) {
					strlcat(iich, "/", sizeof(iich));
					len++;
				}
			}
			break;
		}
	if (*sdpath && !strcmp(path, sdpath)) {
		mkpath(path, ent->name, itmp, sizeof(itmp));
		for (int j = 0; j < nsdents; j++) {
			char tmp[PATH_MAX];
			mkpath(sdpath, sdents[j].name, tmp, sizeof(tmp));
			if (!strcmp(tmp, itmp)) {
				yank = 1;
				len += strlen(yanksym);
				break;
			}
		}
	}

	size = entsize(ent);
	if (ent->marked) {
		attr = A_REVERSE;
		attron(attr);
	}
	mvprintw(line, 0, "%s%s", active ? cursor : nocursor, yank ? yanksym : "");
	attron(attr);
	printw("%s", name);
	attroff(ent->marked ? 0 : attr);
	printw("%s", ich);
	attron(attr);
	printw("%s", lnk);
	attroff(ent->marked ? 0 : attr);
	printw("%s%*c", iich, longest > 0 ? longest - len : len, ' ');
	attroff(ent->marked ? 0 : attr);
	printw("%s%*c", size, max - (longest ? longest : len) - (conf[SEL_SSIZE] ? 0 : len) - strlen(size), ' ');
	attroff(attr);
}

int dentfill(char *path, regex_t *re)
{
	DIR *dirp;
	int n = 0;
	struct stat s, sb;

	longest = 0;
	if ((dirp = opendir(path))) {
		struct dirent *dp;
		char newpath[PATH_MAX], buf[PATH_MAX];
		while ((dp = readdir(dirp))) {
			if (!*dp->d_name || (dp->d_name[0] == '.' && (dp->d_name[1] == '\0'
							|| (dp->d_name[1] == '.' && dp->d_name[2] == '\0')))
					|| regexec(re, dp->d_name, 0, NULL, 0))
				continue;
			if (!(dents = xrealloc(dents, (n + 1) * sizeof(*dents))))
				fatal("unable to allocate enough space");
			strlcpy(dents[n].name, dp->d_name, sizeof(dents[n].name));
			mkpath(path, dp->d_name, newpath, sizeof(newpath));
			if (lstat(newpath, &sb) == -1)
				fatal("lstat");
			int i = 0;
			if (conf[SEL_SSIZE] && (i = strlen(dp->d_name))) {
				int r;
				if ((sb.st_mode & S_IFMT) == S_IFLNK && stat(newpath, &s) != -1
						&& (r = readlink(newpath, buf, sizeof(buf) - 1)) >= 0)
				{
					buf[r] = '\0';
					i += strlen(buf) + 6;
				}
				if (i + 4 > longest)
					longest = i + 4;
			}
			dents[n].mode = sb.st_mode;
			dents[n].size = sb.st_size;
			dents[n].mtime = sb.st_mtime;
			dents[n].marked = 0;
			n++;
		}
		if (closedir(dirp) == -1)
			fatal("closedir");
	}
	return n;
}

int dentfind(char *path)
{
	int i, ormatch = 0;
	char tmp[PATH_MAX];

	for (i = 0; i < ndents; i++) {
		mkpath(path, dents[i].name, tmp, sizeof(tmp));
		if (!strcmp(tmp, hist[0]))
			return i;
		else if (!strcmp(tmp, hist[1]) || !strcmp(tmp, hist[2]))
			ormatch = i;
	}
	return ormatch;
}

int populate(char *path, char *fltr)
{
	regex_t re;
	int nsave = ndents;
	entry *save = NULL;

	if (!canopendir(path) || setfilter(&re, fltr))
		return -1;

	if (ndents) { /* save marked entries */
		if (!(save = xmalloc((ndents + 1) * sizeof(*dents))))
			fatal("unable to allocate enough space");
		memcpy(save, dents, ndents * sizeof(*dents)); // NOLINT
	}

	free(dents);
	dents = NULL;
	ndents = dentfill(path, &re);
	regfree(&re);
	if (ndents) {
		qsort(dents, ndents, sizeof(*dents), entrycmp);
		cur = dentfind(path);
		for (int i = 0; i < nsave; i++) { /* transfer marked entries */
			if (!save[i].marked) continue;
			for (int j = 0; j < ndents; j++)
				if (!strcmp(save[i].name, dents[j].name)) {
					dents[j].marked = 1;
					break;
				}
		}
	}
	free(save);
	return 0;
}

void redraw(char *path)
{
	size_t ncols;
	char *home, cwd[PATH_MAX], cwdresolved[PATH_MAX];
	int i, attr = 0, l = 2, nlines = MIN(LINES - 4, ndents);

	erase();
	for (i = strlen(path) - 1; i > 0 && path[i] == '/'; i--)
		path[i] = '\0';
	if ((ncols = COLS) > PATH_MAX)
		ncols = PATH_MAX;
	strlcpy(cwd, path, ncols);
	cwd[ncols - 1] = '\0';
	realpath(cwd, cwdresolved);
	if (tildehome && (home = getenv("HOME")) && !strcmp(home, cwdresolved))
		strlcpy(cwdresolved, "~", ncols);
	if (!uuid)
		attr |= A_NORMAL|COLOR_PAIR(1);
	attron(attr);
	mvprintw(0, 1, "%s", cwdresolved);
	attroff(attr);
	mvhline(1, 0, ACS_HLINE, COLS);
	if (cur < nlines / 2)
		for (i = 0; i < nlines; i++)
			printent(path, &dents[i], i == cur, l++);
	else if (cur >= ndents - nlines / 2)
		for (i = ndents - nlines; i < ndents; i++)
			printent(path, &dents[i], i == cur, l++);
	else
		for (i = cur - nlines / 2; i < cur + nlines / 2 + ISODD(nlines); i++)
			printent(path, &dents[i], i == cur, l++);
	if (*msg)
		info("%s", msg);
	*msg = '\0';
}

void browse(char *ipath, char *ifilter)
{
	FILE *f;
	regex_t re;
	struct stat sb;
	int i, j, sel = -1, key, fd, bg, updwatch = 0;
	char *dir, *rest, *cmd, *tmp, *run, *env, *home, *argv[NARGS];
	char path[PATH_MAX], newpath[PATH_MAX], fltr[LINE_MAX], buf[PATH_MAX];

	strlcpy(path, ipath, sizeof(path));
	strlcpy(fltr, ifilter, sizeof(fltr));
	*hist[0] = *hist[1] = *hist[2] = '\0';
	updwatch = 1;

#define savehist(histidx) \
	updwatch = 1; \
	savecur(path, cur, histidx, 0); \
	strlcpy(lastdir, path, sizeof(lastdir)); \
	strlcpy(path, newpath, sizeof(path)); \
	strlcpy(fltr, ifilter, sizeof(fltr)); \
	nmarked = 0

	idle = 0;

begin:

#if defined(__linux__)
	if (updwatch && watch >= 0) {
		inotify_rm_watch(inotify, watch);
		watch = -1;
	}
	if (populate(path, fltr) == -1) {
		warn("populate");
		goto nochange;
	}
	if (updwatch && watch == -1) {
		watch = inotify_add_watch(inotify, path, EVMASK);
		updwatch = 0;
	}
#else
	if (populate(path, fltr) == -1) {
		warn("populate");
		goto nochange;
	}
#endif

	for (;;) {
		redraw(path);
nochange:
		switch ((sel = nextsel(&run, &env))) {
		case SEL_QUIT:
			if ((f = fopen(savefile, "w"))) {
				fprintf(f, "%s\n", path);
				fclose(f);
			}
			free(dents);
			free(sdents);
			for (unsigned int p = 0; p < LEN(filerules); p++)
				regfree(&filerules[p].regcomp);
			return;
		case SEL_BACK:
			if (!strcmp(path, "/") || !strcmp(path, ".") || strchr(path, '/') == NULL)
				goto nochange;
			strlcpy(newpath, path, sizeof(newpath)); /* so dirname(3) doesn't mangle path */
			if ((dir = dirname(newpath)) == NULL) fatal("dirname");
			if (!canopendir(dir)) {
				warn("opendir");
				goto nochange;
			}
			savehist(1);
			goto begin;
		case SEL_GOIN:
			if (!ndents)
				goto nochange;
			mkpath(path, (char *)dents[cur].name, newpath, sizeof(newpath));
			if ((fd = open(newpath, O_RDONLY|O_NONBLOCK)) == -1) {
				warn("open");
				goto nochange;
			} else if (fstat(fd, &sb) == -1) {
				warn("fstat");
				close(fd);
				goto nochange;
			}
			close(fd);
			switch (sb.st_mode & S_IFMT) {
			case S_IFDIR:
				if (!canopendir(newpath)) {
					warn("opendir");
					goto nochange;
				}
				updwatch = 1;
				strlcpy(path, newpath, sizeof(path));
				strlcpy(fltr, ifilter, sizeof(fltr));
				nmarked = 0;
				goto begin;
			case S_IFREG:
				for (unsigned int ui = 0, j = 0; ui < LEN(filerules); ui++)
					if (!regexec(&filerules[ui].regcomp, (char *)dents[cur].name, 0, NULL, 0)) {
						bg = 0;
						strlcpy(buf, filerules[ui].argv, sizeof(buf));
						if ((cmd = strtok(buf, " \t"))) {
							argv[j++] = cmd;
							while (j + 3 < sizeof(argv) && (tmp = strtok(NULL, " \t")))
								argv[j++] = tmp;
							if ((bg = (argv[j - 1][0] == '&')))
								j--;
						}
						argv[j++] = newpath;
						argv[j] = NULL;
						savecur(path, cur, 0, 0);
						if (spawnvp(path, argv, bg) == -1) {
							info("failed to open %s", argv[0]);
							goto nochange;
						}
						goto begin;
					}
				continue;
			default:
				info("unsupported filetype");
				goto nochange;
			}
		case SEL_FLTR:
			if ((tmp = readln("/", NULL)) == NULL) tmp = ifilter;
			if (setfilter(&re, tmp)) goto nochange;
			regfree(&re);
			strlcpy(fltr, tmp, sizeof(fltr));
			savecur(path, cur, 0, 0);
			goto begin;
		case SEL_NEXT:
			if (cur < ndents - 1) cur++;
			break;
		case SEL_PREV:
			if (cur) cur--;
			break;
		case SEL_PGDN:
			if (cur < ndents - 1) cur += MIN((LINES - 4) / 2, ndents - 1 - cur);
			break;
		case SEL_PGUP:
			if (cur) cur -= MIN((LINES - 4) / 2, cur);
			break;
		case SEL_LAST:
			cur = ndents - 1;
			break;
		case SEL_FIRST:
			cur = 0;
			break;
		case SEL_JUMP:
			if ((key = xgetch("jump: ")) == 'g') {
				cur = 0;
				break;
			}
			for (unsigned int ui = 0; ui < LEN(dirjumps); ui++)
				if (key == dirjumps[ui].key) {
					if (dirjumps[ui].path[0] == '~' && !(home = getenv("HOME"))) {
						break;
					} else if (dirjumps[ui].path[0] == '~') {
						strlcpy(newpath, home, sizeof(newpath));
						strlcat(newpath, dirjumps[ui].path + 1, sizeof(newpath));
					} else {
						mkpath(path, dirjumps[ui].path, newpath, sizeof(newpath));
					}
					if (!strcmp(path, newpath)) break;
					if (!canopendir(newpath)) {
						warn("opendir");
						break;
					}
					savehist(2);
					goto begin;
				}
			goto nochange;
		case SEL_UNYANK:
			if (!freesdents()) break;
			goto nochange;
		case SEL_MARK:   /* fallthrough */
		case SEL_YANK:   /* fallthrough */
		case SEL_RENAME: /* fallthrough */
		case SEL_RM:
			if (!ndents || (sel == SEL_RM && xgetch("remove? [D]: ") != 'D')) goto nochange;
			if (sel != SEL_MARK && !nmarked) nmarked = dents[cur].marked = 1;
			switch (sel) {
			case SEL_MARK:
				nmarked += (dents[cur].marked = !dents[cur].marked) ? 1 : -1;
				if (cur < ndents - 1) cur++;
				continue;
			case SEL_YANK:
				savecur(path, cur, 0, 0);
				freesdents();
				strlcpy(sdpath, path, sizeof(sdpath));
				sdents = xrealloc(sdents, (nmarked + 1) * sizeof(*sdents));
				for (i = 0; i < ndents && nsdents < nmarked; i++)
					if (dents[i].marked) {
						strlcpy(sdents[nsdents].name, dents[i].name, sizeof(sdents[nsdents].name));
						sdents[nsdents].mode = dents[i].mode;
						dents[i].marked = 0;
						nsdents++;
					}
				nmarked = 0;
				continue;
			case SEL_RENAME:
				savecur(path, cur, 0, 0);
				if (nmarked == 1) {
					for (i = 0; i < ndents; i++)
						if (dents[i].marked) {
							nmarked = dents[i].marked = 0;
							if ((tmp = readln("rename: ", dents[i].name)) && strcmp(dents[i].name, tmp)) {
								if (mv(path, dents[i].name, tmp))
									snprintf(msg, sizeof(msg), "rename: %s", strerror(errno)); // NOLINT
								else
									strlcpy(dents[i].name, tmp, sizeof(dents[i].name));
								savecur(path, cur, 0, 0);
							}
							break;
						}
				} else if (nmarked > 1 && xrename(path, xgetenv(env, run), cur)) {
					snprintf(msg, sizeof(msg), "rename: %s", strerror(errno)); // NOLINT
				}
				goto begin;
			case SEL_RM:
				mvprintw(LINES - 1, 0, "%*c", COLS);
				savecur(path, cur, 0, 1);
				for (i = 0; i < ndents && nmarked; i++)
					if (dents[i].marked) {
						dents[i].marked = 0;
						mkpath(path, dents[i].name, newpath, sizeof(newpath));
						j = strlen(newpath);
						if (fsrec(newpath, newpath, j, j, 0, DEPTH, rm)) {
							snprintf(msg, sizeof(msg), "remove: %s", strerror(errno)); // NOLINT
							break;
						}
						nmarked--;
					}
				goto begin;
			}
			goto nochange;
		case SEL_LN: /* fallthrough */
		case SEL_CP: /* fallthrough */
		case SEL_MV:
			if (!nsdents || !strcmp(sdpath, path)) goto nochange;
			savecur(path, cur, 0, 0);
			if (walksdents(path, sel))
				snprintf(msg, sizeof(msg), "%s: %s", sel == SEL_CP ? "copy" // NOLINT
						: sel == SEL_MV ? "move" : "link", strerror(errno));
			else if (sel == SEL_MV)
				freesdents();
			goto begin;
		case SEL_CD:
			if ((tmp = readln("cd ", NULL)) == NULL) goto nochange;
			mkpath(path, tmp, newpath, sizeof(newpath));
			if (!canopendir(newpath)) {
				warn("opendir");
				goto nochange;
			}
			savehist(2);
			goto begin;
		case SEL_NEW:
			if ((key = xgetch("[f]ile or [d]ir")) != 'd' && key != 'f') goto nochange;
			if (!(tmp = readln(key == 'd' ? "dir name: " : "file name: ", NULL))) goto nochange;
			rest = tmp;
			while ((dir = strtok_r(rest, " ", &rest))) {
				mkpath(path, dir, newpath, sizeof(newpath));
				if ((key == 'd' && xmkdir(newpath, 1)) || (key == 'f' && touch(newpath))) {
					snprintf(msg, sizeof(msg), "%s: %s", // NOLINT
							key == 'd' ? "mkdir" : "touch", strerror(errno));
					break;
				}
				char *s;
				if ((s = strrchr(newpath, '/'))) {
					char c = *s;
					*s = '\0';
					strlcpy(hist[0], newpath, sizeof(hist[0]));
					*s = c;
				} else {
					strlcpy(hist[0], newpath, sizeof(hist[0]));
				}
				refresh();
			}
			goto begin;
		case SEL_MTIME: /* fallthrough */
		case SEL_DSORT: /* fallthrough */
		case SEL_VERS: /* fallthrough */
		case SEL_SIZE: /* fallthrough */
		case SEL_SSIZE:
			conf[sel] = !conf[sel];
			savecur(path, cur, 0, 0);
			goto begin;
		case SEL_DOTS:
			showhidden ^= 1;
			ifilter = showhidden ? "." : "^[^.]";
			strlcpy(fltr, ifilter, sizeof(fltr));
			savecur(path, cur, 0, 0);
			goto begin;
		case SEL_REDRAW:
			savecur(path, cur, 0, 0);
			goto begin;
		case SEL_RUN:
			savecur(path, cur, 0, 0);
			spawnlp(path, xgetenv(env, run), (void *)0);
			goto begin;
		case SEL_RUNARG:
			savecur(path, cur, 0, 0);
			spawnlp(path, xgetenv(env, run), dents[cur].name, (void *)0);
			goto begin;
		}
	}
#undef savehist
}

void usage()
{
	fprintf(stderr, "usage: %s [-ct] [-f savefile] [dir]\n", argv0);
	exit(1);
}

int main(int argc, char *argv[])
{
	char cwd[PATH_MAX];
	char *ifilter, *ipath;

	ARGBEGIN {
		case 'c': usecolour = 1; break;
		case 't': tildehome = 1; break;
		case 'f': savefile = EARGF(usage()); break;
		default: usage(); break;
	} ARGEND

	if (argc > 1) usage();
	if (!isatty(0) || !isatty(1)) {
		fprintf(stderr, "noice: stdin or stdout is not a tty\n");
		exit(1);
	}
	if ((uuid = getuid()) == 0) showhidden = 1;
	ifilter = showhidden ? "." : "^[^.]";
	ipath = argv[0] ? argv[0] : getcwd(cwd, sizeof(cwd)) ? cwd : "/";
	signal(SIGINT, SIG_IGN);
	if (!canopendir(ipath)) {
		fprintf(stderr, "noice: %s: %s\n", ipath, strerror(errno));
		exit(1);
	}
	if ((inotify = inotify_init1(IN_NONBLOCK)) < 0) {
		fprintf(stderr, "noice: inotify: %s\n", strerror(errno));
		return EXIT_FAILURE;
	}
	watch = -1;
	conf[SEL_DSORT] = dirsort;
	conf[SEL_SSIZE] = showsize;
	conf[SEL_MTIME] = timesort;
	conf[SEL_SIZE]  = sizesort;
	conf[SEL_VERS]  = verssort;
	initrules();
	setlocale(LC_ALL, "");
	initcurses();
	browse(ipath, ifilter);
	endwin();

#if defined(__linux__)
	if (watch >= 0) inotify_rm_watch(inotify, watch);
	close(inotify);
#endif
	exit(0);
}
