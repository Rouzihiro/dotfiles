/* See LICENSE file for copyright and license details. */

static int topbar = 1;			/* -b option; if 0, dmenu appears at bottom */
static int centered = 0;		/* -c option; centers dmenu on screen */
static int min_width = 400;		/* minimum width when centered */
static int fuzzy = 1;			/* -F option; if 0, dmenu doesn't use fuzzy matching */
/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	"RobotoMono Nerd Font:size=10.5:antialias=true:autohint=true",
};

static const char col_soft_black[] = "#212121";
static const char col_gray[] = "#313131";
static const char col_dirty_white[] = "#eeeeee";
static const char col_red[] = "#d75f5f";
static const char col_dark_yellow[] = "#f7ca88";
static const char col_white[] = "#eeeeee";
static const char col_green[] = "#87af5f";
static const char col_blue[] = "#8197bf";
static const char *prompt = NULL;	/* -p option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
	/* fg bg */
	[SchemeNorm] = {col_dirty_white, col_soft_black},	// Normal
	[SchemeSel] = {col_dirty_white, col_gray},	// Selected
	[SchemeSelHighlight] = {col_green, col_soft_black},
	[SchemeNormHighlight] = {col_green, col_gray},
	[SchemeOut] = {col_dirty_white, col_soft_black},
	[SchemeMid] = {col_dirty_white, col_soft_black},
};

/* -l and -g options; controls number of lines and columns in grid if > 0 */
static unsigned int lines = 0;
static unsigned int lineheight = 22;	/* -h option; minimum height of a menu line */
static unsigned int columns = 0;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";

/* Size of the window border */
static unsigned int border_width = 0;	/* -bw option; to add border width */
