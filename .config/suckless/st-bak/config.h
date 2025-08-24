
/* See LICENSE file for copyright and license details. */

/*
 * appearance
 */
static const unsigned int borderpx = 2; /* border pixel of terminal */
static char *font = "monospace:size=16";  /* Bigger font */

/* Kanagawa color scheme */
static const char *colorname[] = {
	/* 8 normal colors */
	[0] = "#1f1f28", /* black   */
	[1] = "#c34043", /* red     */
	[2] = "#76946a", /* green   */
	[3] = "#c0a36e", /* yellow  */
	[4] = "#7e9cd8", /* blue    */
	[5] = "#957fb8", /* magenta */
	[6] = "#6a9589", /* cyan    */
	[7] = "#dcd7ba", /* white   */

	/* 8 bright colors */
	[8]  = "#54546d", /* bright black */
	[9]  = "#e82424", /* bright red */
	[10] = "#98bb6c", /* bright green */
	[11] = "#e6c384", /* bright yellow */
	[12] = "#7fb4ca", /* bright blue */
	[13] = "#938aa9", /* bright magenta */
	[14] = "#7aa89f", /* bright cyan */
	[15] = "#c8c093", /* bright white */

	/* special colors */
	[256] = "#1f1f28", /* background */
	[257] = "#dcd7ba", /* foreground */
	[258] = "#dcd7ba", /* cursor */
};

/*
 * Default colors (colorname index)
 * foreground, background, cursor
 */
unsigned int defaultfg = 257;
unsigned int defaultbg = 256;
unsigned int defaultcs = 258;
static unsigned int defaultitalic = 7;
static unsigned int defaultunderline = 7;

/*
 * Terminal options
 */
char *termname = "st-256color";
unsigned int tabspaces = 8;
int allowaltscreen = 1;
int allowwindowops = 0;

/*
 * Cursor
 */
static unsigned int cursorshape = 2; /* 2: block */
static int bellvolume = 0;

/*
 * Keyboard shortcuts
 */
static Shortcut shortcuts[] = {
	/* mask                 keysym          function        argument */
	{ ControlMask|ShiftMask, XK_C,          clipcopy,       {.i =  0} },
	{ ControlMask|ShiftMask, XK_V,          clippaste,      {.i =  0} },

	/* font zoom (MacBook friendly) */
	{ ControlMask|ShiftMask, XK_K,          zoom,           {.f = +1} },
	{ ControlMask|ShiftMask, XK_J,          zoom,           {.f = -1} },
	{ ControlMask|ShiftMask, XK_0,          zoomreset,      {.f =  0} },
};
