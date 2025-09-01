/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

/* -fn option overrides fonts[0]; default X11 font or font set */
static char *fonts[] =
{
	"monospace:size=10"
};

/* Optionally specify separate font sets for selected and output menu items */
static char *selfonts[] = {0};
static char *outfonts[] = {0};

static char *prompt        = NULL; /* -p  option; prompt to the left of input field */
static const char *dynamic = NULL; /* -dy option; dynamic command to run on input change */
static const char *lsymbol = "<";  /* shown when there are more items on the left */
static const char *rsymbol = ">";  /* shown when there are more items on the right */
static const char csymbol = '*';   /* shown when password input is enabled */

/* Powerline options, one of:
 *    PwrlNone, PwrlRightArrow, PwrlLeftArrow, PwrlForwardSlash or PwrlBackslash */
static int powerline = PwrlNone;
/* By default the powerline separator will take up the full space between dmenu items.
 * This option allows for the size to be reduced by a number of pixels, e.g. a value of 3
 * will shave off three pixels on each side of the separator. This can be used to adjust
 * the angle of a powerline slash or arrow. */
static int powerline_size_reduction_pixels = 0;

/* Functionality that is enabled by default, see util.h for options */
static uint64_t functionality = 0
	|Alpha // enables transparency
	|CaseSensitive // makes dmenu case sensitive by default
//	|Centered // dmenu appears in the center of the screen
//	|ColorEmoji // enables color emoji support (removes Xft workaround)
//	|ContinuousOutput // makes dmenu print out selected items immediately rather than at the end
	|FuzzyMatch // allows fuzzy-matching of items in dmenu
//	|HighlightAdjacent // makes dmenu highlight items adjacent to the selected item
//	|Incremental // makes dmenu print out the current text each time a key is pressed
//	|InstantReturn // makes dmenu select an item immediately if there is only one matching option left
//	|Managed // allow dmenu to be managed by window managers (disables override_redirect)
//	|NoInput // disables the input field in dmenu, forcing the user to select options using mouse or keyboard
//	|PasswordInput // indicates that the input is a password and should be masked
//	|PrintIndex // makes dmenu print out the 0-based index instead of the matched text itself
//	|PrintInputText // makes dmenu print the input text instead of the selected item
	|PromptIndent // makes dmenu indent items at the same level as the prompt on multi-line views
//	|RejectNoMatch // makes dmenu reject input if it would result in no matching item
//	|RestrictReturn // disables Shift-Return and Ctrl-Return to restrict dmenu to only output one item
//	|ShowNumbers // makes dmenu display the number of matched and total items in the top right corner
	|Sort // allow dmenu to sort menu items after matching
	|TopBar // dmenu appears at the top of the screen
	|Xresources // makes dmenu read X resources at startup
;

/* Alpha values. You only need to add colour schemes here if you want different levels of
 * transparency per scheme. The default values are defined in the alpha_default array in drw.c. */
static const unsigned int alphas[SchemeLast][2] = {
	/*               fg      bg   */
	[SchemeNorm] = { OPAQUE, 0xd0 },
};

static char *colors[SchemeLast][ColCount] = {
	/*                        fg         bg         resource prefix */
	[SchemeNorm]          = { "#bbbbbb", "#222222", "norm" },
	[SchemeSel]           = { "#eeeeee", "#005577", "sel" },
	[SchemeOut]           = { "#000000", "#00ffff", "out" },
	[SchemeBorder]        = { "#000000", "#005577", "border" },
	[SchemePrompt]        = { "#eeeeee", "#005577", "prompt" },
	[SchemeAdjacent]      = { "#eeeeee", "#770000", "adjacent" },
	[SchemeSelHighlight]  = { "#ffc978", "#005577", "selhl" },
	[SchemeNormHighlight] = { "#ffc978", "#222222", "normhl" },
	[SchemeHp]            = { "#bbbbbb", "#333333", "hp" },
};
/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 0;
/* -g option; if nonzero, dmenu uses a grid comprised of columns and lines */
static unsigned int columns    = 0;
static unsigned int lineheight = 0; /* -h option; minimum height of a menu line */
static unsigned int min_width  = 500; /* minimum width when centered */
static unsigned int maxhist    = 15;
static int histnodup           = 1;	/* if 0, record repeated histories */

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";

/* Default size of the window border */
static unsigned int border_width = 0;

/* Vertical and horizontal padding of dmenu in relation to monitor border */
static int vertpad = 0;
static int sidepad = 0;

#define Shift ShiftMask
#define Ctrl ControlMask
#define Alt Mod1Mask
#define AltGr Mod3Mask
#define Super Mod4Mask
#define ShiftGr Mod5Mask

static Key keys[] = {
	/* modifier          key              function         argument  */
	{ 0,                 XK_BackSpace,    backspace,       {0} },
	{ Ctrl,              XK_h,            backspace,       {0} },
	{ 0,                 XK_Tab,          complete,        {0} },
	{ Ctrl,              XK_i,            complete,        {0} },
	{ 0,                 XK_Delete,       delete,          {0} },
	{ 0,                 XK_KP_Delete,    delete,          {0} },
	{ Ctrl,              XK_d,            delete,          {0} },
	{ Ctrl,              XK_u,            deleteleft,      {0} },
	{ Ctrl,              XK_k,            deleteright,     {0} },
	{ Ctrl,              XK_w,            deleteword,      {0} },
	{ 0,                 XK_Home,         movestart,       {0} },
	{ 0,                 XK_KP_Home,      movestart,       {0} },
	{ Ctrl,              XK_a,            movestart,       {0} },
	{ Alt,               XK_g,            movestart,       {0} },
	{ 0,                 XK_End,          moveend,         {0} },
	{ 0,                 XK_KP_End,       moveend,         {0} },
	{ Ctrl,              XK_e,            moveend,         {0} },
	{ Alt|Shift,         XK_g,            moveend,         {0} },
	{ 0,                 XK_Next,         movenext,        {0} },
	{ 0,                 XK_KP_Next,      movenext,        {0} },
	{ Alt,               XK_j,            movenext,        {0} },
	{ 0,                 XK_Prior,        moveprev,        {0} },
	{ 0,                 XK_KP_Prior,     moveprev,        {0} },
	{ Alt,               XK_k,            moveprev,        {0} },
	{ 0,                 XK_Up,           moveup,          {0} },
	{ 0,                 XK_KP_Up,        moveup,          {0} },
	{ Alt,               XK_h,            moveup,          {0} },
	{ Ctrl,              XK_p,            moveup,          {0} },
	{ 0,                 XK_Down,         movedown,        {0} },
	{ 0,                 XK_KP_Down,      movedown,        {0} },
	{ Alt,               XK_l,            movedown,        {0} },
	{ Ctrl,              XK_n,            movedown,        {0} },
	{ 0,                 XK_Left,         moveleft,        {0} },
	{ 0,                 XK_KP_Left,      moveleft,        {0} },
	{ 0,                 XK_Right,        moveright,       {0} },
	{ 0,                 XK_KP_Right,     moveright,       {0} },
	{ Ctrl,              XK_Left,         movewordedge,    {-1} },
	{ Ctrl,              XK_KP_Left,      movewordedge,    {-1} },
	{ Ctrl,              XK_b,            movewordedge,    {-1} },
	{ Alt,               XK_b,            movewordedge,    {-1} },
	{ Ctrl,              XK_Right,        movewordedge,    {+1} },
	{ Ctrl,              XK_KP_Right,     movewordedge,    {+1} },
	{ Ctrl,              XK_f,            movewordedge,    {+1} },
	{ Alt,               XK_f,            movewordedge,    {+1} },
	{ Alt,               XK_p,            navhistory,      {.i = -1 } },
	{ Alt,               XK_n,            navhistory,      {.i = +1 } },
	{ Ctrl,              XK_y,            paste,           {1} }, /* primary buffer */
	{ Ctrl,              XK_v,            paste,           {1} }, /* primary buffer */
	{ Ctrl|Shift,        XK_y,            paste,           {0} }, /* clipboard */
	{ Ctrl|Shift,        XK_v,            paste,           {0} }, /* clipboard */
	{ 0,                 XK_Escape,       quit,            {0} },
	{ Ctrl,              XK_c,            quit,            {0} },
	{ Ctrl,              XK_g,            quit,            {0} },
	{ Ctrl,              XK_bracketleft,  quit,            {0} },
	{ 0,                 XK_Return,       selectandexit,   {0} },
	{ 0,                 XK_KP_Enter,     selectandexit,   {0} },
	{ Ctrl,              XK_j,            selectandexit,   {0} },
	{ Ctrl|Shift,        XK_j,            selectandexit,   {0} },
	{ Ctrl,              XK_m,            selectandexit,   {0} },
	{ Ctrl,              XK_Return,       selectandresume, {0} },
	{ Ctrl,              XK_KP_Enter,     selectandresume, {0} },
	{ Shift,             XK_Return,       selectinput,     {0} },
	{ Shift,             XK_KP_Enter,     selectinput,     {0} },
};
