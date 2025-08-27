/* See LICENSE file for copyright and license details. */

static int topbar = 1;			/* -b option; if 0, dmenu appears at bottom */
static int centered = 1;		/* -c option; centers dmenu on screen - CHANGED TO 1 */
static int min_width = 400;		/* minimum width when centered */
static int fuzzy = 1;			/* -F option; if 0, dmenu doesn't use fuzzy matching */

/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	"JetBrainsMono Nerd Font:size=12:antialias=true:autohint=true",  // CHANGED TO YOUR FONT
};

/* Kanagawa color scheme */
static const char col_bg[] = "#1f1f28";        // sumi ink #1
static const char col_fg[] = "#dcd7ba";        // old paper  
static const char col_sel_bg[] = "#2f2f3f";    // sumi ink #2
static const char col_sel_fg[] = "#c8c093";    // fuji gray

static const char *prompt = NULL;	/* -p option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
	/* fg bg */
	[SchemeNorm] = {col_fg, col_bg},	        // Normal
	[SchemeSel] = {col_sel_fg, col_sel_bg},	    // Selected - UPDATED
	[SchemeSelHighlight] = {col_sel_fg, col_sel_bg},
	[SchemeNormHighlight] = {col_fg, col_bg},
	[SchemeOut] = {col_fg, col_bg},
	[SchemeMid] = {col_fg, col_bg},
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
