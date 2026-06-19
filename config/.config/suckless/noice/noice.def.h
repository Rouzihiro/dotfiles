/* See LICENSE file for copyright and license details. */

/* comment to disable the loading bar for copy
 * as well as the move, remove, and link info (slight speed gain) */
#define USE_LOADING

/* indicator for the currently selected entry */
const char *cursor = " > ";

/* spacer to align (or not) the selected entry and the rest */
const char *nocursor = "   ";

/* indicator for what files are currently yanked */
const char *yanksym = "* ";

int dirsort = 1;     /* sort by grouping directories first */
int sizesort = 0;    /* sort by size (directories will always be 4 KB) */
int timesort = 1;    /* sort by last modified time */
int verssort = 1;    /* sort by version number */

int tildehome = 1;   /* draw a tilde (~) for $HOME instead of the full path */
int usecolour = 1;   /* use colour to better distinguish between filetypes */
int showsize = 0;    /* show the file size (doesn't affect sizesort) */
int showhidden = 1;  /* show hidden files begging with a period "." */
int redrawtime = 20; /* time between updates to the directory listing when idle */

/* masks used to match filetypes, their colour, and symbol */
struct filetype filetypes[] = {
	/* symbol   filetype    colour mask */
	{ '/',      S_IFDIR,    A_NORMAL|COLOR_PAIR(4) },  /* directory */
	{ '@',      S_IFLNK,    A_NORMAL|COLOR_PAIR(6) },  /* symlink */
	{ '=',      S_IFSOCK,   A_NORMAL|COLOR_PAIR(5) },  /* socket */
	{ '|',      S_IFIFO,    A_NORMAL|COLOR_PAIR(5) },  /* fifo */
	{ '#',      S_IFBLK,    A_NORMAL|COLOR_PAIR(3) },  /* block */
	{ '*',      S_IXUSR,    A_NORMAL|COLOR_PAIR(3) },  /* exec */
	/* when non match we consider it a normal file and no highlighting is used */
};

/* jump characters and matching path to jump to for use with g and ' binds */
struct dirjump dirjumps[] = {
	/* char  path */
	{ 'h',   "~" },
	{ '~',   "~" },
	{ 'r',   "/" },
	{ '/',   "/" },
	{ '.',   "~/.config" },
  { 'd', "~/Downloads" },
 	{ 'w', "~/Documents/" },
  { 'f', "~/dotfiles" },
  { 'v', "~/Videos" },  
  { 'p', "~/Pictures" }, 
	{ 's', "~/suckless/" }, 
  { 'l', "~/.local/bin" },
  { 'm', "~/mount" },  
	/* lastdir will be the last directory before jumping */
	{ '\'',  lastdir },
};

/* file opening application matching */
struct filerule filerules[] = {
	/* regex to match against file name         command + flags */
	{ "\\.(avi|mp4|mkv|mp3|ogg|flac|mov|wav)$", "mpv &"  		},
	{ "\\.(xz|gz|tar|zip|7z|rar|deb|bz2)$",     "extract &" },
	{ "\\.(png|jpg|jpeg|gif)$", 								"viewimg &" },
	{ "\\.(html|svg)$",                         "brave"   	},
	{ "\\.pdf$",                                "zathura" 	},
	{ ".*",                                     "nvim" },
};

/* associate keys with an action */
struct keybind keybinds[] = {
	/* exit noice */
	{ 'q',             SEL_QUIT   },
	{ 'o', SEL_RUNARG, "xdg-open" },
	/* go back up the directory tree */
	{ 'h',             SEL_BACK   },
	{ KEY_LEFT,        SEL_BACK   },
	{ KEY_BACKSPACE,   SEL_BACK   },
	/* descend into directory or try to open file */
	{ 'l',             SEL_GOIN   },
	{ KEY_RIGHT,       SEL_GOIN   },
	{ KEY_ENTER,       SEL_GOIN   },
	{ '\r',            SEL_GOIN   },
	/* change filter applied to the directory listing */
	{ '/',             SEL_FLTR   },
	/* move to the next entry */
	{ 'j',             SEL_NEXT   },
	{ KEY_DOWN,        SEL_NEXT   },
	{ BUTTON5_PRESSED, SEL_NEXT   },
	/* move to the previous entry */
	{ 'k',             SEL_PREV   },
	{ KEY_UP,          SEL_PREV   },
	{ BUTTON4_PRESSED, SEL_PREV   },
	/* go down one page (terminal lines) */
	{ CONTROL('D'),    SEL_PGDN   },
	{ KEY_NPAGE,       SEL_PGDN   },
	/* go up one page (terminal lines) */
	{ CONTROL('U'),    SEL_PGUP   },
	{ KEY_PPAGE,       SEL_PGUP   },
	/* go to the last entry */
	{ 'G',             SEL_LAST   },
	{ KEY_END,         SEL_LAST   },
	/* go to the first entry, 'gg' also works */
	{ KEY_HOME,        SEL_FIRST  },
	/* prompt for a jump key */
	{ 'g',             SEL_JUMP   },
	{ '\'',            SEL_JUMP   },
	/* toggle the marked state of the current entry */
	{ ' ',             SEL_MARK   },
	/* yanked marked entries or the current when none are marked */
	{ 'y',             SEL_YANK   },
	/* un-yank previously yanked entries */
	{ 'u',             SEL_UNYANK },
	/* prompt to remove marked entries or the current when none are marked */
	{ 'D',             SEL_RM     },
	/* create link(s) to the last yanked entries */
	{ 'L',             SEL_LN     },
	/* copy last yanked entries to the current directory */
	{ 'p',             SEL_CP     },
	/* move last yanked entries to the current directory */
	{ 'm',             SEL_MV     },
	/* change directory */
	{ 'c',             SEL_CD     },
	/* prompt to create a new file or directory, nested paths are supported */
	{ 'a',             SEL_NEW    },
	/* toggle sorting by directories first */
	{ 'd',             SEL_DSORT  },
	/* toggle sorting by version number */
	{ 'v',             SEL_VERS   },
	/* toggle sorting by last modified time */
	{ 'w',             SEL_MTIME  },
	/* toggle sorting by file size */
	{ 's',             SEL_SIZE   },
	/* toggle showing file size */
	{ 'S',             SEL_SSIZE  },
	/* toggle showing hidden files */
	{ '.',             SEL_DOTS   },
	/* force a redraw */
	{ CONTROL('L'),    SEL_REDRAW },
	/* rename marked entries */
	{ 'r',             SEL_RENAME, "nvim", "EDITOR" },
	{ 't',             SEL_RUN,    "sh",  "SHELL" },
	{ 'z',             SEL_RUN,    "top", "NOICETOP" }, /* run NOICETOP or top if empty */
	{ '?',             SEL_RUN,    "man noice", "NOICEMAN" }, /* run NOICEMAN or man noice if empty */
	{ 'e',             SEL_RUNARG, "nvim",            "EDITOR" },
	{ 'M',             SEL_RUNARG, "mpv --shuffle", "NOICEMP" },
	{ 'x', SEL_RUNARG, "extract &" },
};
