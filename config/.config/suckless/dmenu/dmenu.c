/* See LICENSE file for copyright and license details. */
#include <ctype.h>
#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <time.h>
#include <unistd.h>

#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>
#ifdef XINERAMA
#include <X11/extensions/Xinerama.h>
#endif
#include <X11/Xft/Xft.h>

#include "drw.h"
#include "util.h"

/* macros */
#define INTERSECT(x,y,w,h,r)  (MAX(0, MIN((x)+(w),(r).x_org+(r).width)  - MAX((x),(r).x_org)) \
                             * MAX(0, MIN((y)+(h),(r).y_org+(r).height) - MAX((y),(r).y_org)))
#define TEXTW(X)              (drw_fontset_getwidth(drw, (X)) + lrpad)
#define OPAQUE 0xffU
#define CLEANMASK(mask, nl)   (mask & ~(nl|LockMask) & (ShiftMask|ControlMask|Mod1Mask|Mod2Mask|Mod3Mask|Mod4Mask|Mod5Mask))
#define BUTTONMASK            (ButtonPressMask|ButtonReleaseMask)

/* enums */
enum {
	SchemeNorm,
	SchemeSel,
	SchemeOut,
	SchemeBorder,
	SchemePrompt,
	SchemeAdjacent,
	SchemeNormHighlight,
	SchemeSelHighlight,
	SchemeHp,
	SchemeLast,
}; /* color schemes */

struct item {
	char *text;
	char *text_output;
	struct item *left, *right;
	int id; /* for multiselect */
	int hp;
	int scheme;
	int x;
	double distance;
	int index;
};

typedef union {
	int i;
	unsigned int ui;
	float f;
	const void *v;
} Arg;

typedef struct {
	unsigned int mod;
	KeySym keysym;
	void (*func)(const Arg *);
	const Arg arg;
} Key;

static char text[BUFSIZ] = "";
static long unsigned int embed = 0;
static char separator, separator_reverse;
static char * (*sepchr)(const char *, int);
static int bh, mw, mh;
static int dmx = ~0, dmy = ~0, dmw = 0; /* put dmenu at these x and y offsets and w width */
static int dmxp = ~0, dmyp = ~0, dmwp = ~0; /* percentage values for the above */
static int gridcolw = 0; /* if positive then it is used to calculate number of grid columns */
static int inputw = 0, promptw = 0;
static int lrpad; /* sum of left and right padding */
static int numlockmask = 0;
static size_t cursor;
static struct item *items = NULL;
static struct item *matches, *matchend;
static struct item *prev, *curr, *next, *sel;
static int mon = -1, screen;
static int *selid = NULL;
static unsigned int selidsize = 0;
static unsigned int preselected = 0;
static unsigned int double_print = 0;

static Atom clip, utf8;
static Atom type, dock;
static Display *dpy;
static Window root, parentwin, win;
static XIC xic;

static int useargb = 0;
static Visual *visual;
static int depth;
static Colormap cmap;

static Drw *drw;
static Clr *scheme[SchemeLast];
static Fnt *normal_fonts, *selected_fonts, *output_fonts;

static void backspace(const Arg *arg);
static void complete(const Arg *arg);
static void delete(const Arg *arg);
static void deleteleft(const Arg *arg);
static void deleteright(const Arg *arg);
static void deleteword(const Arg *arg);
static void movewordedge(const Arg *arg);
static void movestart(const Arg *arg);
static void moveend(const Arg *arg);
static void movenext(const Arg *arg);
static void moveprev(const Arg *arg);
static void movedown(const Arg *arg);
static void moveup(const Arg *arg);
static void moveleft(const Arg *arg);
static void moveright(const Arg *arg);
static void navhistory(const Arg *arg);
static void paste(const Arg *arg);
static void quit(const Arg *arg);
static void selectandresume(const Arg *arg);
static void selectinput(const Arg *arg);
static void selectandexit(const Arg *arg);

#include "lib/include.h"
#include "config.h"

static int (*fstrncmp)(const char *, const char *, size_t) = strncmp;
static int (*fstrcmp)(const char *, const char *) = strcmp;
static char *(*fstrstr)(const char *, const char *) = strstr;

static void appenditem(struct item *item, struct item **list, struct item **last);
static void calcoffsets(void);
static void cleanup(void);
static char * cistrstr(const char *s, const char *sub);
static int drawitem(struct item *item, int x, int y, int w);
static void drawmenu(void);
static void grabfocus(void);
static void grabkeyboard(void);
static void match(void);
static void insert(const char *str, ssize_t n);
static size_t nextrune(int inc);
static void keypress(XEvent *ev);
static void pastesel(void);
static int xerror(Display *dpy, XErrorEvent *ee);
static int xerrordummy(Display *dpy, XErrorEvent *ee);
static void xinitvisual(void);
static void readstdin(void);
static void run(void);
static void setup(void);
static unsigned int textw_clamp(const char *str, unsigned int n);
static void updatenumlockmask(void);
static void usage(FILE *stream);

#include "lib/include.c"

void
appenditem(struct item *item, struct item **list, struct item **last)
{
	if (*last)
		(*last)->right = item;
	else
		*list = item;

	item->left = *last;
	item->right = NULL;
	*last = item;
}

void
backspace(const Arg *arg)
{
	if (cursor == 0)
		return;

	insert(NULL, nextrune(-1) - cursor);
}

void
calcoffsets(void)
{
	int i, n, rpad = 0;

	if (enabled(ShowNumbers))
		rpad = TEXTW(numbers);

	if (lines > 0)
		if (columns)
			n = lines * columns * bh;
		else
			n = lines * bh;
	else
		n = mw - (promptw + inputw + TEXTW(lsymbol) + TEXTW(rsymbol) + rpad);
	/* calculate which items will begin the next page and previous page */
	for (i = 0, next = curr; next; next = next->right)
		if ((i += (lines > 0) ? bh : textw_clamp(next->text, n)) > n)
			break;
	for (i = 0, prev = curr; prev && prev->left; prev = prev->left)
		if ((i += (lines > 0) ? bh : textw_clamp(prev->left->text, n)) > n)
			break;
}

void
cleanup(void)
{
	size_t i;

	XUngrabKeyboard(dpy, CurrentTime);
	for (i = 0; i < SchemeLast; i++)
		free(scheme[i]);
	for (i = 0; items && items[i].text; ++i)
		free(separator_reverse ? items[i].text_output : items[i].text);
	free(items);
	free(hpitems);
	drw_free(drw);
	XSync(dpy, False);
	XCloseDisplay(dpy);
	free(selid);
}

void
complete(const Arg *arg)
{
	if (!sel || enabled(NoInput))
		return;
	cursor = strnlen(sel->text, sizeof text - 1);
	memcpy(text, sel->text, cursor);
	text[cursor] = '\0';
	match();
}

char *
cistrstr(const char *s, const char *sub)
{
	size_t len;

	for (len = strlen(sub); *s; s++)
		if (!strncasecmp(s, sub, len))
			return (char *)s;
	return NULL;
}

void
delete(const Arg *arg)
{
	if (text[cursor] == '\0')
		return;
	cursor = nextrune(+1);
	if (cursor == 0)
		return;
	insert(NULL, nextrune(-1) - cursor);
}

void
deleteleft(const Arg *arg) {
	insert(NULL, 0 - cursor);
}

void
deleteright(const Arg *arg) {
	text[cursor] = '\0';
	match();
}

void
deleteword(const Arg *arg) {
	while (cursor > 0 && strchr(worddelimiters, text[nextrune(-1)]))
		insert(NULL, nextrune(-1) - cursor);
	while (cursor > 0 && !strchr(worddelimiters, text[nextrune(-1)]))
		insert(NULL, nextrune(-1) - cursor);
}

int
drawitem(struct item *item, int x, int y, int w)
{
	int r;
	char *text = item->text;

	if (item == sel) {
		item->scheme = SchemeSel;
		drw->fonts = selected_fonts;
	} else if (item->hp) {
		item->scheme = SchemeHp;
	} else if (enabled(HighlightAdjacent) && columns < 2 && (item->left == sel || item->right == sel)) {
		item->scheme = SchemeAdjacent;
	} else if (issel(item->id)) {
		item->scheme = SchemeOut;
		drw->fonts = output_fonts;
	} else {
		item->scheme = SchemeNorm;
	}

	drw_setscheme(drw, scheme[item->scheme]);

	item->x = x;
	r = drw_text(drw, x, y, w, bh, lrpad / 2, text, 0);
	drawhighlights(item, x, y, w);
	drw->fonts = normal_fonts;

	return r;
}

void
drawmenu(void)
{
	unsigned int curpos;
	struct item *item, *prev = NULL;
	int i, x = 0, y = 0, w = 0, rpad = 0, itw = 0, stw = 0;
	int fh = drw->fonts->h;
	y = (enabled(NoInput) && !promptw ? -bh : 0);

	struct item **buffer;
	buffer = calloc(lines, sizeof(struct item *));
	for (i = 0; i < lines; i++) {
		buffer[i] = NULL;
	}

	char *censort;
	int hasfocus, revertwin;
	Window focuswin;

	XGetInputFocus(dpy, &focuswin, &revertwin);
	hasfocus = enabled(Managed) ? focuswin == win : 1;

	drw_setscheme(drw, scheme[SchemeNorm]);
	drw_rect(drw, 0, 0, mw, mh, 1, 1);

	if (prompt && *prompt) {
		drw_setscheme(drw, scheme[SchemePrompt]);
		x = drw_text(drw, x, 0, promptw, bh, lrpad / 2, prompt, 0);
	}

	if (disabled(NoInput)) {
		/* draw input field */
		w = (lines > 0 || !matches) ? mw - x : inputw;

		drw_setscheme(drw, scheme[SchemeNorm]);
		if (enabled(PasswordInput)) {
			censort = ecalloc(1, sizeof(text));
			memset(censort, csymbol, strlen(text));
			drw_text(drw, x, 0, w, bh, lrpad / 2, censort, 0);
			free(censort);
		} else
			drw_text(drw, x, 0, w, bh, lrpad / 2, text, 0);

		curpos = TEXTW(text) - TEXTW(&text[cursor]);
		if (hasfocus && (curpos += lrpad / 2 - 1) < w) {
			drw_setscheme(drw, scheme[SchemeNorm]);
			drw_rect(drw, x + curpos, 2 + (bh-fh)/2, 2, fh - 4, 1, 0);
		}
	}

	if (enabled(ShowNumbers)) {
		recalculatenumbers();
		rpad = TEXTW(numbers);
	}
	if (lines > 0) {
		/* draw grid */
		int i = 0, ix = (enabled(PromptIndent) ? x : 0);
		if (columns) {
			for (item = curr; item != next; item = item->right, i++) {
				drawitem(
					item,
					ix + ((i / lines) *  ((mw - ix) / columns)),
					y + (((i % lines) + 1) * bh),
					(mw - ix) / columns
				);
				if (powerline) {
					if (buffer[i % lines] != NULL) {
						drw_arrow(
							drw,
							item->x - lrpad / 2 + powerline_size_reduction_pixels,
							y + (((i % lines) + 1) * bh),
							lrpad - 2 * powerline_size_reduction_pixels,
							bh,
							powerline,
							scheme[buffer[i % lines]->scheme][ColBg],
							scheme[item->scheme][ColBg]
						);
					}
					buffer[i % lines] = item;
				}
			}
		} else {
			for (item = curr; item != next; item = item->right, i++) {
				drawitem(item, ix, y += bh, mw - ix);
			}
		}
	} else if (matches) {
		/* draw horizontal list */
		x += inputw;
		w = TEXTW(lsymbol);
		if (curr->left) {
			drw_setscheme(drw, scheme[SchemeNorm]);
			drw_text(drw, x, 0, w, bh, lrpad / 2, lsymbol, 0);
		}
		x += w;
		for (item = curr; item != next; item = item->right) {
			stw = TEXTW(rsymbol);
			itw = textw_clamp(item->text, mw - x - stw - rpad);
			x = drawitem(item, x, 0, itw);
			if (powerline && prev != NULL) {
				drw_arrow(
					drw,
					item->x - lrpad / 2 + powerline_size_reduction_pixels,
					0,
					lrpad - 2 * powerline_size_reduction_pixels,
					bh,
					powerline,
					scheme[prev->scheme][ColBg],
					scheme[item->scheme][ColBg]
				);
			}
			prev = item;
		}
		if (next) {
			w = TEXTW(rsymbol);
			drw_setscheme(drw, scheme[SchemeNorm]);
			drw_text(drw, mw - w - rpad, 0, w, bh, lrpad / 2, rsymbol, 0);
		}
	}
	if (enabled(ShowNumbers)) {
		drw_setscheme(drw, scheme[SchemeNorm]);
		drw_text(drw, mw - TEXTW(numbers), 0, TEXTW(numbers), bh, lrpad / 2, numbers, 0);
	}
	drw_map(drw, win, 0, 0, mw, mh);
	free(buffer);
}

void
grabfocus(void)
{
	struct timespec ts = { .tv_sec = 0, .tv_nsec = 10000000  };
	Window focuswin;
	int i, revertwin;

	for (i = 0; i < 100; ++i) {
		XGetInputFocus(dpy, &focuswin, &revertwin);
		if (focuswin == win)
			return;
		XSetInputFocus(dpy, win, RevertToParent, CurrentTime);
		nanosleep(&ts, NULL);
	}
	die("cannot grab focus");
}

void
grabkeyboard(void)
{
	struct timespec ts = { .tv_sec = 0, .tv_nsec = 1000000  };
	int i;

	if (embed || enabled(Managed))
		return;

	/* try to grab keyboard, we may have to wait for another process to ungrab */
	for (i = 0; i < 1000; i++) {
		if (XGrabKeyboard(dpy, DefaultRootWindow(dpy), True, GrabModeAsync,
		                  GrabModeAsync, CurrentTime) == GrabSuccess) {
			/* one off attempt at grabbing the mouse pointer to avoid interactions
			 * with other windows while dmenu is active */
			XGrabPointer(dpy, DefaultRootWindow(dpy), True, ButtonPressMask, GrabModeAsync,
			             GrabModeAsync, None, None, CurrentTime);
			updatenumlockmask();
			return;
		}
		nanosleep(&ts, NULL);
	}
	die("cannot grab keyboard");
}

void
match(void)
{
	if (dynamic && *dynamic)
		refreshoptions();

	if (enabled(FuzzyMatch))
		fuzzymatch();
	else
		exactmatch();
}

void
insert(const char *str, ssize_t n)
{
	if (strlen(text) + n > sizeof text - 1)
		return;

	static char last[BUFSIZ] = "";
	if (enabled(RejectNoMatch)) {
		/* store last text value in case we need to revert it */
		memcpy(last, text, BUFSIZ);
	}

	/* move existing text out of the way, insert new text, and update cursor */
	memmove(&text[cursor + n], &text[cursor], sizeof text - cursor - MAX(n, 0));
	if (n > 0)
		memcpy(&text[cursor], str, n);
	cursor += n;
	match();

	if (!matches && enabled(RejectNoMatch)) {
		/* revert to last text value if theres no match */
		memcpy(text, last, BUFSIZ);
		cursor -= n;
		match();
	}
}

size_t
nextrune(int inc)
{
	ssize_t n;

	/* return location of next utf8 rune in the given direction (+1 or -1) */
	for (n = cursor + inc; n + inc >= 0 && (text[n] & 0xc0) == 0x80; n += inc)
		;
	return n;
}

void
movewordedge(const Arg *arg)
{
	if (arg->i < 0) { /* move cursor to the start of the word*/
		while (cursor > 0 && strchr(worddelimiters, text[nextrune(-1)]))
			cursor = nextrune(-1);
		while (cursor > 0 && !strchr(worddelimiters, text[nextrune(-1)]))
			cursor = nextrune(-1);
	} else { /* move cursor to the end of the word */
		while (text[cursor] && strchr(worddelimiters, text[cursor]))
			cursor = nextrune(+1);
		while (text[cursor] && !strchr(worddelimiters, text[cursor]))
			cursor = nextrune(+1);
	}
}

void
movestart(const Arg *arg)
{
	if (sel == matches) {
		cursor = 0;
		return;
	}
	sel = curr = matches;
	calcoffsets();
}

void
moveend(const Arg *arg)
{
	if (text[cursor] != '\0') {
		cursor = strlen(text);
		return;
	}
	if (next) {
		/* jump to end of list and position items in reverse */
		curr = matchend;
		calcoffsets();
		curr = prev;
		calcoffsets();
		while (next && (curr = curr->right))
			calcoffsets();
	}
	sel = matchend;
}

void
movenext(const Arg *arg)
{
	if (!next)
		return;
	sel = curr = next;
	calcoffsets();
}

void
moveprev(const Arg *arg)
{
	if (!prev)
		return;
	sel = curr = prev;
	calcoffsets();
}

void
moveleft(const Arg *arg)
{
	struct item *tmpsel;
	unsigned int i;
	int offscreen = 0;

	if (columns > 1) {
		if (!sel)
			return;
		tmpsel = sel;
		for (i = 0; i < lines; i++) {
			if (!tmpsel->left ||  tmpsel->left->right != tmpsel)
				return;
			if (tmpsel == curr)
				offscreen = 1;
			tmpsel = tmpsel->left;
		}
		sel = tmpsel;
		if (offscreen) {
			curr = prev;
			calcoffsets();
		}
		return;
	}
	if (cursor > 0 && (!sel || !sel->left || lines > 0)) {
		cursor = nextrune(-1);
		return;
	}
	if (lines > 0)
		return;

	moveup(arg);
}

void
moveright(const Arg *arg)
{
	struct item *tmpsel;
	unsigned int i;
	int offscreen = 0;

	if (columns > 1) {
		if (!sel)
			return;
		tmpsel = sel;
		for (i = 0; i < lines; i++) {
			if (!tmpsel->right ||  tmpsel->right->left != tmpsel)
				return;
			tmpsel = tmpsel->right;
			if (tmpsel == next)
				offscreen = 1;
		}
		sel = tmpsel;
		if (offscreen) {
			curr = next;
			calcoffsets();
		}
		return;
	}
	if (text[cursor] != '\0') {
		cursor = nextrune(+1);
		return;
	}
	if (lines > 0)
		return;

	movedown(arg);
}

void
moveup(const Arg *arg)
{
	if (sel && sel->left && (sel = sel->left)->right == curr) {
		curr = prev;
		calcoffsets();
	}
}

void
movedown(const Arg *arg)
{
	if (sel && sel->right && (sel = sel->right) == next) {
		curr = next;
		calcoffsets();
	}
}

void
keypress(XEvent *e)
{
	unsigned int i;
	int keysyms_return;
	char buf[64];
	KeySym* keysym;
	XKeyEvent *ev;
	KeySym ksym = NoSymbol;
	Status status;

	int n; /* whether to ignore num-lock or not */
	int len = 0;
	int keybind_found = 0;
	ev = &e->xkey;
	len = XmbLookupString(xic, ev, buf, sizeof buf, &ksym, &status);
	keysym = XGetKeyboardMapping(dpy, (KeyCode)ev->keycode, 1, &keysyms_return);

	for (i = 0; i < LENGTH(keys); i++) {
		n = (keys[i].keysym >= XK_KP_Home && keys[i].keysym <= XK_KP_Delete ? 0 : numlockmask);
		if (*keysym == keys[i].keysym
				&& CLEANMASK(keys[i].mod, n) == CLEANMASK(ev->state, n)
				&& keys[i].func) {
			keys[i].func(&(keys[i].arg));
			keybind_found = 1;
		}
	}
	XFree(keysym);

	/* Insert if no keybind triggered above */
	if (keybind_found) {
		if (enabled(Incremental)) {
			puts(text);
			fflush(stdout);
		}
		drawmenu();
	} else if (disabled(NoInput) && !iscntrl(*buf) && type) {
		insert(buf, len);
		if (enabled(Incremental)) {
			puts(text);
			fflush(stdout);
		}
		drawmenu();
	}
}

void
paste(const Arg *arg)
{
	XConvertSelection(dpy, arg->i ? XA_PRIMARY : clip, utf8, utf8, win, CurrentTime);
}

void
pastesel(void)
{
	char *p, *q;
	int di;
	unsigned long dl;
	Atom da;

	/* we have been given the current selection, now insert it into input */
	if (XGetWindowProperty(dpy, win, utf8, 0, (sizeof text / 4) + 1, False,
	                   utf8, &da, &di, &dl, &dl, (unsigned char **)&p)
	    == Success && p) {
		insert(p, (q = strchr(p, '\n')) ? q - p : (ssize_t)strlen(p));
		XFree(p);
	}
	drawmenu();
}

void
quit(const Arg *arg)
{
	cleanup();
	exit(1);
}

void
selectandresume(const Arg *arg)
{
	if (enabled(RestrictReturn))
		return;
	selsel();
}

void
selectinput(const Arg *arg)
{
	if (enabled(RestrictReturn))
		return;

	if (enabled(PrintInputText))
		puts((sel && !cursor) ? sel->text : text);
	else if (enabled(ContinuousOutput)) {
		puts(text);
	}

	savehistory(text);
	if (disabled(ContinuousOutput) && disabled(PrintInputText))
		printinput();
	cleanup();
	exit(0);
}

void
selectandexit(const Arg *arg)
{
	if (enabled(RestrictReturn) && !sel)
		return;
	if (enabled(PrintInputText)) {
		puts((sel && !cursor) ? sel->text : text);
	} else if (enabled(ContinuousOutput)) {
		if (enabled(PrintIndex)) {
			printf("%d\n", sel ? sel->index : -1);
		} else {
			puts(sel ? sel->text_output : text);
		}
	}
	savehistory(sel ? sel->text : text);
	if (disabled(ContinuousOutput) && disabled(PrintInputText)) {
		if (sel) {
			printsel();
		} else {
			puts(text);
		}
	}
	cleanup();
	exit(0);
}

int
xerror(Display *dpy, XErrorEvent *ee)
{
	return 1;
}

int
xerrordummy(Display *dpy, XErrorEvent *ee)
{
    return 0;
}

void
xinitvisual(void)
{
	XVisualInfo *infos;
	XRenderPictFormat *fmt;
	int nitems;
	int i;

	XVisualInfo tpl = {
		.screen = screen,
		.depth = 32,
		.class = TrueColor
	};
	long masks = VisualScreenMask | VisualDepthMask | VisualClassMask;

	infos = XGetVisualInfo(dpy, masks, &tpl, &nitems);
	visual = NULL;
	for (i = 0; i < nitems; i++) {
		fmt = XRenderFindVisualFormat(dpy, infos[i].visual);
		if (fmt->type == PictTypeDirect && fmt->direct.alphaMask) {
			visual = infos[i].visual;
			depth = infos[i].depth;
			cmap = XCreateColormap(dpy, root, visual, AllocNone);
			useargb = 1;
			break;
		}
	}

	XFree(infos);

	if (!visual || disabled(Alpha)) {
		visual = DefaultVisual(dpy, screen);
		depth = DefaultDepth(dpy, screen);
		cmap = DefaultColormap(dpy, screen);
	}
}

void
readstdin(void)
{
	char *line = NULL, *p;
	size_t i, linesize, itemsize = 0;
	ssize_t len;

	if (hpitems && hplength > 0)
		qsort(hpitems, hplength, sizeof *hpitems, str_compare);

	if (enabled(PasswordInput)) {
		inputw = lines = 0;
		return;
	}

	/* read each line from stdin and add it to the item list */
	for (i = 0; (len = getline(&line, &linesize, stdin)) != -1; i++) {
		if (i + 1 >= itemsize) {
			itemsize += 256;
			if (!(items = realloc(items, itemsize * sizeof(*items))))
				die("cannot realloc %zu bytes:", itemsize * sizeof(*items));
		}
		if (line[len - 1] == '\n')
			line[len - 1] = '\0';
		if (!(items[i].text = strdup(line)))
			die("strdup:");
		if (separator && (p = sepchr(items[i].text, separator)) != NULL) {
			*p = '\0';
			items[i].text_output = ++p;
		} else {
			items[i].text_output = items[i].text;
		}
		if (separator_reverse) {
			p = items[i].text;
			items[i].text = items[i].text_output;
			items[i].text_output = p;
		}

		items[i].id = i; /* for multiselect */
		items[i].index = i;
		p = hpitems == NULL ? NULL : bsearch(
			&items[i].text, hpitems, hplength, sizeof *hpitems,
			str_compare
		);
		items[i].hp = p != NULL;
	}
	free(line);
	if (items)
		items[i].text = NULL;
	lines = MIN(lines, i);
}

void
run(void)
{
	XEvent ev;

	while (!XNextEvent(dpy, &ev)) {
		if (XFilterEvent(&ev, win))
			continue;
		switch(ev.type) {
		case ButtonPress:
			buttonpress(&ev);
			break;
		case MotionNotify:
			motionevent(&ev.xbutton);
			break;
		case DestroyNotify:
			if (ev.xdestroywindow.window != win)
				break;
			cleanup();
			exit(1);
		case Expose:
			if (ev.xexpose.count == 0)
				drw_map(drw, win, 0, 0, mw, mh);
			break;
		case FocusOut:
			if (enabled(Managed))
				drawmenu();
			break;
		case FocusIn:
			/* regrab focus from parent window */
			if (ev.xfocus.window != win) {
				if (enabled(Managed)) {
					drawmenu();
				} else {
					grabfocus();
				}
			}
			break;
		case KeyPress:
			keypress(&ev);
			break;
		case SelectionNotify:
			if (ev.xselection.property == utf8)
				pastesel();
			break;
		case VisibilityNotify:
			if (ev.xvisibility.state != VisibilityUnobscured)
				XRaiseWindow(dpy, win);
			break;
		}
	}
}

void
setup(void)
{
	int x, y, i, j, max_h, max_w;
	int minstrlen = 0, curstrlen = 0;
	int numwidthchecks = 100;
	int xoffset = 0, yoffset = 0, height = 0, width = 0;
	unsigned int du, tmp;
	XSetWindowAttributes swa;
	XIM xim;
	Window w, dw, *dws;
	XWindowAttributes wa;
	XClassHint ch = {"dmenu", "dmenu"};
	struct item *item;
#ifdef XINERAMA
	XineramaScreenInfo *info;
	Window pw;
	int a, di, n, area = 0;
#endif

	/* init appearance */
	for (j = 0; j < SchemeLast; j++)
		scheme[j] = drw_scm_create(drw, (const char**)colors[j], alphas[j], 2);

	clip = XInternAtom(dpy, "CLIPBOARD",   False);
	utf8 = XInternAtom(dpy, "UTF8_STRING", False);
	type = XInternAtom(dpy, "_NET_WM_WINDOW_TYPE", False);
	dock = XInternAtom(dpy, "_NET_WM_WINDOW_TYPE_DOCK", False);

#ifdef XINERAMA
	i = 0;
	if (parentwin == root && (info = XineramaQueryScreens(dpy, &n))) {
		XGetInputFocus(dpy, &w, &di);
		if (mon >= 0 && mon < n)
			i = mon;
		else if (w != root && w != PointerRoot && w != None) {
			/* find top-level window containing current input focus */
			do {
				if (XQueryTree(dpy, (pw = w), &dw, &w, &dws, &du) && dws)
					XFree(dws);
			} while (w != root && w != pw);
			/* find xinerama screen with which the window intersects most */
			if (XGetWindowAttributes(dpy, pw, &wa))
				for (j = 0; j < n; j++)
					if ((a = INTERSECT(wa.x, wa.y, wa.width, wa.height, info[j])) > area) {
						area = a;
						i = j;
					}
		}
		/* no focused window is on screen, so use pointer location instead */
		if (mon < 0 && !area && XQueryPointer(dpy, root, &dw, &dw, &x, &y, &di, &di, &du))
			for (i = 0; i < n; i++)
				if (INTERSECT(x, y, 1, 1, info[i]) != 0)
					break;

		xoffset = info[i].x_org;
		yoffset = info[i].y_org;
		width = info[i].width;
		height = info[i].height;

		XFree(info);
	} else
#endif
	{
		if (!XGetWindowAttributes(dpy, parentwin, &wa))
			die("could not get embedding window attributes: 0x%lx",
			    parentwin);

		width = wa.width;
		height = wa.height;
	}

	/* calculate menu geometry */
	bh = MAX(drw->fonts->h + 2, lineheight);
	lines = MAX(lines, 0);
	mh = (lines + 1) * bh;
	promptw = (prompt && *prompt) ? TEXTW(prompt) : 0;
 	max_h = height - vertpad * 2 - border_width * 2;
 	max_w = width - sidepad * 2;

	if (mh > max_h) {
		mh = max_h;
		bh = max_h / (lines + 1);
	}

	if (enabled(Centered)) {
		dmxp = 50;
		dmyp = 50;
		if (dmw <= 0 && dmwp == ~0)
			dmw = min_width + dmw;
	}

	if (dmw <= 0)
		dmw = max_w + dmw; // dmw can be a negative adjustment
	if (dmwp != ~0)
		dmw = dmw * dmwp / 100;

	if (enabled(Centered))
		dmw = MIN(MAX(max_textw() + promptw, dmw), max_w);

	mw = dmw - border_width * 2;
	if (enabled(NoInput) && lines) {
		if (!promptw) {
			mh -= bh;
		} else {
			promptw = mw;
		}
	}

	if (dmxp != ~0)
		dmx = sidepad + (max_w - dmw) * dmxp / 100;
	else if (dmx == ~0)
		dmx = sidepad;

	if (dmyp != ~0) {
		dmy = vertpad + (max_h - mh) * dmyp / 100;
	} else if (dmy == ~0)
		dmy = enabled(TopBar) ? vertpad : max_h - mh;

	x = xoffset + dmx;
	y = yoffset + dmy;

	/* Recalculate columns if gridcolw is set and:
	 *    - columns is not set with the -g argument or
	 *    - the calculated number of columns is less than the given columns
	 */
	if (gridcolw > 0 && (!columns || (mw / gridcolw) < columns))
		columns = mw / gridcolw;

	if (disabled(NoInput)) {
		for (item = items; !lines && item && item->text; ++item) {
			curstrlen = strlen(item->text);
			if (numwidthchecks || minstrlen < curstrlen) {
				numwidthchecks = MAX(numwidthchecks - 1, 0);
				minstrlen = MAX(minstrlen, curstrlen);
				if ((tmp = textw_clamp(item->text, mw/3)) > inputw) {
					inputw = tmp;
					if (tmp == mw/3)
						break;
				}
			}
		}
	}
	match();

	/* create menu window */
	swa.override_redirect = enabled(Managed) ? False : True;
	swa.background_pixel = 0;
	swa.colormap = cmap;
	swa.event_mask = ExposureMask | KeyPressMask | VisibilityChangeMask | ButtonPressMask | PointerMotionMask;
	win = XCreateWindow(dpy, root, x, y, mw, mh, border_width,
		depth, InputOutput, visual,
		CWOverrideRedirect|CWBackPixel|CWBorderPixel|CWColormap|CWEventMask, &swa
	);

	if (border_width)
		XSetWindowBorder(dpy, win, scheme[SchemeBorder][ColBg].pixel);

	XSetClassHint(dpy, win, &ch);
	XChangeProperty(dpy, win, type, XA_ATOM, 32, PropModeReplace, (unsigned char *) &dock, 1);

	/* input methods */
	if ((xim = XOpenIM(dpy, NULL, NULL, NULL)) == NULL)
		die("XOpenIM failed: could not open input device");

	xic = XCreateIC(xim, XNInputStyle, XIMPreeditNothing | XIMStatusNothing,
	                XNClientWindow, win, XNFocusWindow, win, NULL);

	if (enabled(Managed)) {
		XTextProperty prop;
		char *windowtitle = prompt != NULL ? prompt : "dmenu";
		Xutf8TextListToTextProperty(dpy, &windowtitle, 1, XUTF8StringStyle, &prop);
		XSetWMName(dpy, win, &prop);
		XSetTextProperty(dpy, win, &prop, XInternAtom(dpy, "_NET_WM_NAME", False));
		XFree(prop.value);
	}

	if (embed || enabled(Managed)) {
		XReparentWindow(dpy, win, parentwin, x, y);
		XMapWindow(dpy, win);
		XSelectInput(dpy, parentwin, FocusChangeMask | SubstructureNotifyMask);
		if (XQueryTree(dpy, parentwin, &dw, &w, &dws, &du) && dws) {
			for (i = 0; i < du && dws[i] != win; ++i)
				XSelectInput(dpy, dws[i], FocusChangeMask);
			XFree(dws);
		}
		if (disabled(Managed))
			grabfocus();
	} else {
		XMapRaised(dpy, win);
	}
	drw_resize(drw, mw, mh);

	if (preselected) {
		for (i = 0; i < preselected; i++) {
			if (sel && sel->right && (sel = sel->right) == next) {
				curr = next;
				calcoffsets();
			}
		}
	}
	drawmenu();
}

unsigned int
textw_clamp(const char *str, unsigned int n)
{
	unsigned int w = drw_fontset_getwidth_clamp(drw, str, n) + lrpad;
	return MIN(w, n);
}

void
updatenumlockmask(void)
{
	unsigned int i, j;
	XModifierKeymap *modmap;

	numlockmask = 0;
	modmap = XGetModifierMapping(dpy);
	for (i = 0; i < 8; i++)
		for (j = 0; j < modmap->max_keypermod; j++)
			if (modmap->modifiermap[i * modmap->max_keypermod + j]
				== XKeysymToKeycode(dpy, XK_Num_Lock))
				numlockmask = (1 << i);
	XFreeModifiermap(modmap);
}

void
usage(FILE *stream)
{
	fputs("usage: dmenu [-bcfiIjJkKnNrRsStuUvxyz]"
		" [-bw width]"
		" [-g columns]"
		" [-gw width]"
		" [-l lines]"
		" [-p prompt]"
		"\n            "
		" [-dy command]"
		" [-it text]"
		" [-hp items]"
		" [-H histfile]"
		" [-h height]"
		" [-ps index]"
		"\n            "
		" [-x offset]"
		" [-y offset]"
		" [-z width]"
		" [-m monitor]"
		" [-w windowid]"
		"\n            "
		" [-fn font] [-nb color] [-nf color] [-sb color] [-sf color] ..."
		"\n\n", stream);

	fputs("dmenu is a dynamic menu for X, which reads a list of newline-separated items from stdin."
		"\nWhen the user selects an item and presses Return, their choice is printed to stdout and"
		"\ndmenu terminates. Entering text will narrow the items to those matching the tokens in the"
		"\ninput.\n\n", stream);

	char ofmt[] = "   %-30s%s%s\n";
	fprintf(stream, "Placement options:\n");
	fprintf(stream, ofmt, "-t", "dmenu is shown at the top of the screen", enabled(TopBar) ? " (default)" : "");
	fprintf(stream, ofmt, "-b", "dmenu is shown at the bottom of the screen", disabled(TopBar) ? " (default)" : "");
	fprintf(stream, ofmt, "-c", "dmenu is shown in the center of the screen", enabled(Centered) ? " (default)" : "");
	fprintf(stream, ofmt, "-e <windowid>", "embed into the given window ID", "");
	fprintf(stream, ofmt, "-ea", "embed into the currently focused (active) window", "");
	fprintf(stream, ofmt, "-m <monitor>", "specifies the monitor index to place dmenu on (starts at 0)", "");
	fprintf(stream, ofmt, "-x <offset>", "specifies the x position relative to monitor", "");
	fprintf(stream, ofmt, "-y <offset>", "specifies the y position relative to monitor", "");
	fprintf(stream, ofmt, "-w <width>", "specifies the width of dmenu", "");

	fprintf(stream, "\nAppearance:\n");
	fprintf(stream, ofmt, "-bw <width>", "specifies the border width", "");
	fprintf(stream, ofmt, "-h <height>", "specifies the height of dmenu lines", "");
	fprintf(stream, ofmt, "-p <text>, -prompt <text>", "defines the prompt to be displayed to the left of the input field", "");
	fprintf(stream, ofmt, "-l <lines>", "specifies the number of lines for grid presentation", "");
	fprintf(stream, ofmt, "-g <columns>", "specifies the number of columns for grid presentation", "");
	fprintf(stream, ofmt, "-gw <width>", "specifies the minimum width of columns in a grid presentation", "");
	fprintf(stream, ofmt, "-pwrl <int>", "specifies the powerline separator to use (values 0 through 4)", "");
	fprintf(stream, ofmt, "-pwrl_reduction <pixels>", "adjusts the angle and size of the powerline separator", "");

	fprintf(stream, "\nColors:\n");
	fprintf(stream, ofmt, "-fn <font>", "defines the font or font set used", "");
	fprintf(stream, ofmt, "-fns <font>", "defines the selected item font or font set used", "");
	fprintf(stream, ofmt, "-fno <font>", "defines the output item font or font set used", "");
	fprintf(stream, ofmt, "-nb <color>", "defines the normal background color", "");
	fprintf(stream, ofmt, "-nf <color>", "defines the normal foreground color", "");
	fprintf(stream, ofmt, "-sb <color>", "defines the selected background color", "");
	fprintf(stream, ofmt, "-sf <color>", "defines the selected foreground color", "");
	fprintf(stream, ofmt, "-bb <color>", "defines the border background color", "");
	fprintf(stream, ofmt, "-bf <color>", "defines the border foreground color", "");
	fprintf(stream, ofmt, "-pb <color>", "defines the prompt background color", "");
	fprintf(stream, ofmt, "-pf <color>", "defines the prompt foreground color", "");
	fprintf(stream, ofmt, "-ab <color>", "defines the adjacent background color", "");
	fprintf(stream, ofmt, "-af <color>", "defines the adjacent foreground color", "");
	fprintf(stream, ofmt, "-ob <color>", "defines the out(put) background color", "");
	fprintf(stream, ofmt, "-of <color>", "defines the out(put) foreground color", "");
	fprintf(stream, ofmt, "-hb <color>", "defines the high priority background color", "");
	fprintf(stream, ofmt, "-hf <color>", "defines the high priority foreground color", "");
	fprintf(stream, ofmt, "-nhb <color>", "defines the normal highlight background color", "");
	fprintf(stream, ofmt, "-nhf <color>", "defines the normal highlight foreground color", "");
	fprintf(stream, ofmt, "-shb <color>", "defines the selected highlight background color", "");
	fprintf(stream, ofmt, "-shf <color>", "defines the selected highlight foreground color", "");

	fprintf(stream, "\nFor color settings #RGB, #RRGGBB, and X color names are supported.\n");

	fprintf(stream, "\nFunctionality:\n");
	fprintf(stream, ofmt, "-d <delimiter>", "separates the input in two halves; display first and return second", "");
	fprintf(stream, ofmt, "-D <delimiter>", "as -d but based on the last occurrence of the delimiter", "");
	fprintf(stream, ofmt, "-dp", "when using -d or -D, display first and return original line (double print)", "");
	fprintf(stream, ofmt, "-dy <command>", "a command used to dynamically change the dmenu options", "");
	fprintf(stream, ofmt, "-hp <items>", "comma separated list of high priority items", "");
	fprintf(stream, ofmt, "-it <text>", "starts dmenu with initial text already typed in", "");
	fprintf(stream, ofmt, "-ps <index>", "preselect the item with the given index", "");
	fprintf(stream, ofmt, "-f", "dmenu grabs the keyboard before reading stdin if not reading from a tty", "");
	fprintf(stream, ofmt, "-H <histfile>", "specifies the history file to use", "");
	fprintf(stream, ofmt, "-i, -NoCaseSensitive", "makes dmenu case-insensitive", disabled(CaseSensitive) ? " (default)" : "");
	fprintf(stream, ofmt, "-I, -CaseSensitive", "makes dmenu case-sensitive", enabled(CaseSensitive) ? " (default)" : "");
	fprintf(stream, ofmt, "-j, -RejectNoMatch", "makes dmenu reject input if it would result in no matching item", enabled(RejectNoMatch) ? " (default)" : "");
	fprintf(stream, ofmt, "-J, -NoRejectNoMatch", "input can be entered into dmenu freely", disabled(RejectNoMatch) ? " (default)" : "");
	fprintf(stream, ofmt, "-k, -PrintIndex", "makes dmenu print out the 0-based index instead of the matched text", enabled(PrintIndex) ? " (default)" : "");
	fprintf(stream, ofmt, "-K, -NoPrintIndex", "makes dmenu print out matched text itself", disabled(PrintIndex) ? " (default)" : "");
	fprintf(stream, ofmt, "-n, -InstantReturn", "makes dmenu select an item immediately if there is only one matching option left", enabled(InstantReturn) ? " (default)" : "");
	fprintf(stream, ofmt, "-N, -NoInstantReturn", "user must press enter to select an item (disables auto-select)", disabled(InstantReturn) ? " (default)" : "");
	fprintf(stream, ofmt, "-u, -PasswordInput", "indicates that the input is a password and should be masked", enabled(PasswordInput) ? " (default)" : "");
	fprintf(stream, ofmt, "-U, -NoPasswordInput", "indicates that the input is not a password", disabled(PasswordInput) ? " (default)" : "");
	fprintf(stream, ofmt, "-s, -Sort", "enables sorting of menu items after matching", enabled(Sort) ? " (default)" : "");
	fprintf(stream, ofmt, "-S, -NoSort", "disables sorting of menu items after matching", disabled(Sort) ? " (default)" : "");
	fprintf(stream, ofmt, "-r, -RestrictReturn", "disables Shift-Return and Ctrl-Return to restrict dmenu to only output one item", enabled(RestrictReturn) ? " (default)" : "");
	fprintf(stream, ofmt, "-R, -NoRestrictReturn", "enables Shift-Return and Ctrl-Return to allow dmenu to output more than one item", disabled(RestrictReturn) ? " (default)" : "");
	fprintf(stream, ofmt, "-v", "prints version information to stdout, then exits", "");
	fprintf(stream, ofmt, "-xpad <offset>", "sets the horizontal padding value for dmenu", "");
	fprintf(stream, ofmt, "-ypad <offset>", "sets the vertical padding value for dmenu", "");
	fprintf(stream, ofmt, "    -Alpha", "enables transparency", enabled(Alpha) ? " (default)" : "");
	fprintf(stream, ofmt, "    -NoAlpha", "disables transparency", disabled(Alpha) ? " (default)" : "");
	fprintf(stream, ofmt, "    -ColorEmoji", "enables color emoji in dmenu (requires libxft-bgra)", enabled(ColorEmoji) ? " (default)" : "");
	fprintf(stream, ofmt, "    -NoColorEmoji", "disables color emoji", disabled(ColorEmoji) ? " (default)" : "");
	fprintf(stream, ofmt, "    -ContinuousOutput", "makes dmenu print out selected items immediately rather than at the end", enabled(ContinuousOutput) ? " (default)" : "");
	fprintf(stream, ofmt, "    -NoContinuousOutput", "dmenu prints out the selected items when enter is pressed", disabled(ContinuousOutput) ? " (default)" : "");
	fprintf(stream, ofmt, "    -FuzzyMatch", "allows fuzzy-matching of items in dmenu", enabled(FuzzyMatch) ? " (default)" : "");
	fprintf(stream, ofmt, "    -NoFuzzyMatch", "enables exact matching of items in dmenu", disabled(FuzzyMatch) ? " (default)" : "");
	fprintf(stream, ofmt, "    -HighlightAdjacent", "makes dmenu highlight items adjacent to the selected item", enabled(HighlightAdjacent) ? " (default)" : "");
	fprintf(stream, ofmt, "    -NoHighlightAdjacent", "only the selected item is highlighted", disabled(HighlightAdjacent) ? " (default)" : "");
	fprintf(stream, ofmt, "    -Incremental", "makes dmenu print out the current text each time a key is pressed", enabled(Incremental) ? " (default)" : "");
	fprintf(stream, ofmt, "    -NoIncremental", "dmenu will not print out the current text each time a key is pressed", disabled(Incremental) ? " (default)" : "");
	fprintf(stream, ofmt, "    -Input", "enables input field allowing the user to search through the options", disabled(NoInput) ? " (default)" : "");
	fprintf(stream, ofmt, "    -NoInput", "disables the input field, forcing the user to select options using mouse or keyboard", enabled(NoInput) ? " (default)" : "");
	fprintf(stream, ofmt, "    -Managed", "allows dmenu to be managed by a window manager", enabled(Managed) ? " (default)" : "");
	fprintf(stream, ofmt, "    -NoManaged", "dmenu manages itself, window manager not to interfere", disabled(Managed) ? " (default)" : "");
	fprintf(stream, ofmt, "    -PrintInputText", "makes dmenu print the input text instead of the selected item", enabled(PrintInputText) ? " (default)" : "");
	fprintf(stream, ofmt, "    -NoPrintInputText", "dmenu to print the text of the selected item", disabled(PrintInputText) ? " (default)" : "");
	fprintf(stream, ofmt, "    -PromptIndent", "makes dmenu indent items at the same level as the prompt on multi-line views", enabled(PromptIndent) ? " (default)" : "");
	fprintf(stream, ofmt, "    -NoPromptIndent", "items on multi-line views are not indented", disabled(PromptIndent) ? " (default)" : "");
	fprintf(stream, ofmt, "    -ShowNumbers", "makes dmenu display the number of matched and total items in the top right corner", enabled(ShowNumbers) ? " (default)" : "");
	fprintf(stream, ofmt, "    -NoShowNumbers", "dmenu will not show item count", disabled(ShowNumbers) ? " (default)" : "");
	fprintf(stream, ofmt, "    -Xresources", "makes dmenu read X resources at startup", enabled(Xresources) ? " (default)" : "");
	fprintf(stream, ofmt, "    -NoXresources", "dmenu will not read X resources", disabled(Xresources) ? " (default)" : "");
	fprintf(stream, "\n");
}

#define arg(A) (!strcmp(argv[i], A))

int
main(int argc, char *argv[])
{
	XWindowAttributes wa;
	int i, val;
	char ch;
	int fast = 0;

	enablefunc(functionality);

	if (disabled(CaseSensitive)) {
		fstrncmp = strncasecmp;
		fstrcmp = strcasecmp;
		fstrstr = cistrstr;
	}

	if (!setlocale(LC_CTYPE, "") || !XSupportsLocale())
		fputs("warning: no locale support\n", stderr);
	if (!(dpy = XOpenDisplay(NULL)))
		die("cannot open display");

	/* These need to be checked before we init the visuals and read X resources. */
	for (i = 1; i < argc; i++) {
		if arg("-v") { /* prints version information */
			puts("dmenu-"VERSION);
			exit(0);
		} else if arg("--help") {
			usage(stdout);
			exit(0);
		} else if arg("-Alpha") { /* enables transparency (alpha, opacity) */
			enablefunc(Alpha);
		} else if arg("-NoAlpha") { /* disables transparency (alpha, opacity) */
			disablefunc(Alpha);
		} else if arg("-Xresources") {
			enablefunc(Xresources);
		} else if arg("-NoXresources") {
			disablefunc(Xresources);
		} else if (arg("-e") && i + 1 < argc) { /* embedding window id */
			argv[i][0] = '\0';
			embed = strtol(argv[++i], NULL, 0);
		} else if (arg("-ea")) { /* embedding currently focused (active) window */
			Atom netactive = XInternAtom(dpy, "_NET_ACTIVE_WINDOW", True);
			Atom type;
			int format;
			unsigned long nitems, dl;
			unsigned char *prop = NULL;
			if (netactive != None) {
				if (XGetWindowProperty(dpy, DefaultRootWindow(dpy), netactive, 0, (~0L),
					                   False, AnyPropertyType, &type, &format,
					                   &nitems, &dl, &prop) == Success) {
					if (prop != NULL) {
						if (format == 32 && nitems == 1)
							embed = *(Window *)prop;
						XFree(prop);
					}
				}
			}
		} else
			continue;
		argv[i][0] = '\0'; // mark as used
	}

	/* Set up the X window */
	screen = DefaultScreen(dpy);
	root = RootWindow(dpy, screen);
	parentwin = embed ? embed : root;
	XSetErrorHandler(xerrordummy);
	if (!XGetWindowAttributes(dpy, parentwin, &wa))
		die("could not get embedding window attributes: 0x%lx", parentwin);
	XSetErrorHandler(xerror);
	xinitvisual();
	drw = drw_create(dpy, screen, root, wa.width, wa.height, visual, depth, cmap);

	/* X resources are loaded before the rest of the parameter are read. This is
	 * to allow for command line arguments to override the X resource colours. */
	if (enabled(Xresources))
		readxresources();

	/* Parse remaining options */
	for (i = 1; i < argc; i++) {
		if (argv[i][0] == '\0')
			continue;

		/* Placement */
		if (arg("-TopBar") || arg("-t")) { /* dmenu appears at the top of the screen */
			enablefunc(TopBar);
			disablefunc(Centered);
		} else if (arg("-BottomBar") || arg("-b")) { /* dmenu appears at the bottom of the screen */
			disablefunc(TopBar);
			disablefunc(Centered);
		} else if (arg("-Centered") || arg("-c")) { /* centers dmenu window on the screen */
			enablefunc(Centered);
			disablefunc(TopBar);
		} else if arg("-x") { /* window x offset */
			switch (sscanf(argv[++i], "%d%c", &val, &ch)) {
				case 2:
					if (ch == '%') {
						dmxp = val;
						break;
					}
					/* falls through */
				case 1:
					dmx = val;
					break;
			}
			disablefunc(Centered);
		} else if arg("-y") { /* window y offset (from bottom up if -b) */
			switch (sscanf(argv[++i], "%d%c", &val, &ch)) {
				case 2:
					if (ch == '%') {
						dmyp = val;
						break;
					}
					/* falls through */
				case 1:
					dmy = val;
					break;
			}
			disablefunc(Centered);
		} else if (arg("-w") || arg("-z")) { /* make dmenu this wide, -z for compatibility reasons */
			switch (sscanf(argv[++i], "%d%c", &val, &ch)) {
				case 2:
					if (ch == '%') {
						dmwp = val;
						break;
					}
					/* falls through */
				case 1:
					dmw = val;
					break;
			}
		/* Functionality toggles */
		} else if (arg("-CaseSensitive") || arg("-I")) { /* case-sensitive item matching */
			fstrncmp = strncmp;
			fstrcmp = strcmp;
			fstrstr = strstr;
		} else if (arg("-NoCaseSensitive") || arg("-i")) { /* case-insensitive item matching */
			fstrncmp = strncasecmp;
			fstrcmp = strcasecmp;
			fstrstr = cistrstr;
		} else if (arg("-InstantReturn") || arg("-n")) { /* instant select only match */
			enablefunc(InstantReturn);
		} else if (arg("-NoInstantReturn") || arg("-N")) { /* instant select only match */
			disablefunc(InstantReturn);
		} else if (arg("-PasswordInput") || arg("-u")) { /* indicates that the input is a password and should be masked */
			enablefunc(PasswordInput);
		} else if (arg("-NoPasswordInput") || arg("-U")) { /* indicates that the input is not a password */
			disablefunc(PasswordInput);
		} else if (arg("-Sort") || arg("-s")) { /* sort matches */
			enablefunc(Sort);
		} else if (arg("-NoSort") || arg("-S")) { /* do not sort matches */
			disablefunc(Sort);
		} else if arg("-Incremental") { /* incremental, print out the current text each time a key is pressed */
			enablefunc(Incremental);
		} else if arg("-NoIncremental") {
			disablefunc(Incremental);
		} else if arg("-Input") { /* whether text input is available for search functionality */
			disablefunc(NoInput);
		} else if arg("-NoInput") {
			enablefunc(NoInput);
		} else if (arg("-PrintIndex") || arg("-k")) { /* makes dmenu print out the 0-based index instead of the matched text itself */
			enablefunc(PrintIndex);
		} else if (arg("-NoPrintIndex") || arg("-K")) { /* makes dmenu print out the matched text itself */
			disablefunc(PrintIndex);
		} else if (arg("-RejectNoMatch") || arg("-j")) { /* makes dmenu reject input if it would result in no matching item */
			enablefunc(RejectNoMatch);
		} else if (arg("-NoRejectNoMatch") || arg("-J")) { /* allow input to be added freely into dmenu */
			disablefunc(RejectNoMatch);
		} else if (arg("-RestrictReturn") || arg("-r")) { /* disallow Shift-Return and Ctrl-Return */
			enablefunc(RestrictReturn);
		} else if (arg("-NoRestrictReturn") || arg("-R")) { /* allow Shift-Return and Ctrl-Return */
			disablefunc(RestrictReturn);
		} else if arg("-Managed") { /* display as managed wm window */
			enablefunc(Managed);
		} else if arg("-NoManaged") { /* dmenu manages itself, window manager not to interfere */
			disablefunc(Managed);
		} else if arg("-ColorEmoji") { /* enables color emoji in dmenu (requires libxft-bgra) */
			enablefunc(ColorEmoji);
		} else if arg("-NoColorEmoji") {
			disablefunc(ColorEmoji);
		} else if arg("-ContinuousOutput") { /* makes dmenu print out selected items immediately rather than at the end */
			enablefunc(ContinuousOutput);
		} else if arg("-NoContinuousOutput") {
			disablefunc(ContinuousOutput);
		} else if arg("-FuzzyMatch") { /* allows fuzzy-matching of items in dmenu */
			enablefunc(FuzzyMatch);
		} else if arg("-NoFuzzyMatch") {
			disablefunc(FuzzyMatch);
		} else if arg("-HighlightAdjacent") {
			enablefunc(HighlightAdjacent);
		} else if arg("-NoHighlightAdjacent") {
			disablefunc(HighlightAdjacent);
		} else if arg("-PrintInputText") {
			enablefunc(PrintInputText);
		} else if arg("-NoPrintInputText") {
			disablefunc(PrintInputText);
		} else if arg("-PromptIndent") {
			enablefunc(PromptIndent);
		} else if arg("-NoPromptIndent") {
			disablefunc(PromptIndent);
		} else if arg("-ShowNumbers") {
			enablefunc(ShowNumbers);
		} else if arg("-NoShowNumbers") {
			disablefunc(ShowNumbers);

		/* These options take one argument */
		} else if (i + 1 == argc) {
			usage(stderr);
			exit(1);
		} else if arg("-m") {
			mon = atoi(argv[++i]);
		} else if arg("-bw") { /* border width around dmenu */
			border_width = atoi(argv[++i]);
		} else if arg("-pwrl") { /* powerline separator between items */
			powerline = atoi(argv[++i]);
		} else if arg("-pwrl_reduction") { /* powerline separator between items */
			powerline_size_reduction_pixels = atoi(argv[++i]);
		} else if arg("-d") {
			sepchr = strchr;
			separator = argv[++i][0];
			separator_reverse = argv[i][1] == '|';
		} else if arg("-D") {
			sepchr = strrchr;
			separator = argv[++i][0];
			separator_reverse = argv[i][1] == '|';
		} else if arg("-l") { /* number of lines in vertical list */
			lines = atoi(argv[++i]);
		} else if arg("-g") {   /* number of columns in grid */
			columns = atoi(argv[++i]);
			if (columns && lines == 0)
				lines = 1;
		} else if arg("-gw") { /* grid column width used to calculate the number of columns */
			gridcolw = atoi(argv[++i]);
			if (gridcolw && lines == 0)
				lines = 1;
		} else if arg("-dp") { /* double print when using separator */
			double_print = 1;
		} else if arg("-f") { /* grabs keyboard before reading stdin */
			fast = 1;
		} else if arg("-H") {
			histfile = argv[++i];
		} else if (arg("-p") || arg("-prompt")) { /* adds prompt to left of input field */
			prompt = argv[++i];
		} else if arg("-h") { /* minimum height of one menu line */
			lineheight = atoi(argv[++i]);
		} else if arg("-it") { /* initial text */
		    const char * text = argv[++i];
		    insert(text, strlen(text));
		} else if arg("-ps") { /* preselected item */
			preselected = atoi(argv[++i]);
		} else if arg("-dy") { /* dynamic command to run */
			dynamic = argv[++i];
		} else if arg("-hp") { /* high priority items */
			parse_hpitems(argv[++i]);
		} else if arg("-xpad") { /* sets horizontal padding */
			sidepad = atoi(argv[++i]);
		} else if arg("-ypad") { /* sets vertical padding */
			vertpad = atoi(argv[++i]);
		/* Color arguments */
		} else if arg("-fn") { /* font or font set */
			fonts[0] = argv[++i];
		} else if arg("-fns") { /* selected font or font set */
			selfonts[0] = argv[++i];
		} else if arg("-fno") { /* selected font or font set */
			outfonts[0] = argv[++i];
		} else if arg("-ab") { /* adjacent background color */
			colors[SchemeAdjacent][ColBg] = argv[++i];
		} else if arg("-af") { /* adjacent foreground color */
			colors[SchemeAdjacent][ColFg] = argv[++i];
		} else if arg("-bb") { /* border background color */
			colors[SchemeBorder][ColBg] = argv[++i];
		} else if arg("-bf") { /* border foreground color */
			colors[SchemeBorder][ColFg] = argv[++i];
		} else if arg("-nb") { /* normal background color */
			colors[SchemeNorm][ColBg] = argv[++i];
		} else if arg("-nf") { /* normal foreground color */
			colors[SchemeNorm][ColFg] = argv[++i];
		} else if arg("-ob") { /* out(put) background color */
			colors[SchemeOut][ColBg] = argv[++i];
		} else if arg("-of") { /* out(put) foreground color */
			colors[SchemeOut][ColFg] = argv[++i];
		} else if arg("-sb") { /* selected background color */
			colors[SchemeSel][ColBg] = argv[++i];
		} else if arg("-sf") { /* selected foreground color */
			colors[SchemeSel][ColFg] = argv[++i];
		} else if arg("-pb") { /* prompt background color */
			colors[SchemePrompt][ColBg] = argv[++i];
		} else if arg("-pf") { /* prompt foreground color */
			colors[SchemePrompt][ColFg] = argv[++i];
		} else if arg("-hb") { /* high priority background color */
			colors[SchemeHp][ColBg] = argv[++i];
		} else if arg("-hf") { /* high priority foreground color */
			colors[SchemeHp][ColFg] = argv[++i];
		} else if arg("-nhb") { /* normal hi background color */
			colors[SchemeNormHighlight][ColBg] = argv[++i];
		} else if arg("-nhf") { /* normal hi foreground color */
			colors[SchemeNormHighlight][ColFg] = argv[++i];
		} else if arg("-shb") { /* selected hi background color */
			colors[SchemeSelHighlight][ColBg] = argv[++i];
		} else if arg("-shf") { /* selected hi foreground color */
			colors[SchemeSelHighlight][ColFg] = argv[++i];
		} else { /* a catch all for any argument that is not recognised */
			usage(stderr);
			exit(1);
		}
	}

	if (!drw_fontset_create(drw, (const char**)fonts, LENGTH(fonts)))
		die("no fonts could be loaded.");
	selected_fonts = output_fonts = normal_fonts = drw->fonts;

	if (selfonts[0]) {
		if (!drw_fontset_create(drw, (const char**)selfonts, LENGTH(selfonts)))
			die("no selected fonts could be loaded.");
		selected_fonts = drw->fonts;
	}

	if (outfonts[0]) {
		if (!drw_fontset_create(drw, (const char**)outfonts, LENGTH(outfonts)))
			die("no output fonts could be loaded.");
		output_fonts = drw->fonts;
	}

	drw->fonts = normal_fonts;

	lrpad = drw->fonts->h;

	if (lineheight == -1)
		lineheight = drw->fonts->h * 2.5;

	if (powerline < 0 || powerline >= PwrlLast || powerline_size_reduction_pixels >= lrpad / 2)
		powerline = PwrlNone;

#ifdef __OpenBSD__
	if (pledge("stdio rpath wpath cpath", NULL) == -1)
		die("pledge");
#endif
	loadhistory();

	if (fast && !isatty(0)) {
		grabkeyboard();
		if (!(dynamic && *dynamic))
			readstdin();
	} else {
		if (!(dynamic && *dynamic))
			readstdin();
		grabkeyboard();
	}
	setup();
	run();

	return 1; /* unreachable */
}
