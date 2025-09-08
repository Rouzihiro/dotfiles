/* Functions */
#include <X11/XF86keysym.h>
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int snap      = 20;       /* snap pixel */
static const unsigned int gappih    = 5;       /* horiz inner gap between windows */
static const unsigned int gappiv    = 5;       /* vert inner gap between windows */
static const unsigned int gappoh    = 5;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 5;       /* vert outer gap between windows and screen edge */
static       int smartgaps          = 0;        /* 1 means no outer gap when there is only one window */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int focusonwheel       = 0;
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft  = 0;   /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;        /* 0 means no systray */
static const int vertpad            = 4;       /* vertical padding of bar */
static const int sidepad            = 5;       /* horizontal padding of bar */
static const int horizpadbar        = 5;        /* horizontal padding for statusbar */
static const int vertpadbar         = 5;        /* vertical padding for statusbar */

static const char slopspawnstyle[]  = "-t 0 -c 0.92,0.85,0.69,0.3 -o"; /* do NOT define -f (format) here */
static const char slopresizestyle[] = "-t 0 -c 0.92,0.85,0.69,0.3"; /* do NOT define -f (format) here */
static const int riodraw_borders    = 0; /* 0 or 1, indicates whether the area drawn using slop includes the window borders */
static const int riodraw_matchpid   = 1; /* 0 or 1, indicates whether to match the PID of the client that was spawned with riospawn */
static const int riodraw_spawnasync = 0; /* 0 means that the application is only spawned after a successful selection while
                                          * 1 means that the application is being initialised in the background while the selection is made */
typedef struct {
    const char *name;
    const void *cmd;
} Sp;

const char *spcmd1[] = {"st", "-n", "spterm1", "-g", "120x34", NULL};
const char *spcmd2[] = {"st", "-n", "spterm2", "-g", "120x34", NULL};

void changeopacity(const Arg *arg);

#define ICONSIZE 20   /* icon size */
#define ICONSPACING 3 /* space between icon and title */

/* Pick your theme */
#include "themes/everforest-hard.h"
// #include "themes/everforest-soft.h"
// #include "themes/kanagawa.h"

static const char *fonts[]          = {  "JetBrainsMono Nerd Font:antialias=true:autohint=true:size=11", "Noto Sans CJK JP:size=11"  };


/* tagging */
static const char *tags[] = {"", "󰈹", "󱞁", "", "", "󰺷", ""};

static const unsigned int ulinepad	= 1;	/* horizontal padding between the underline and tag */
static const unsigned int ulinestroke	= 1;	/* thickness / height of the underline */
static const unsigned int ulinevoffset	= 0;	/* how far above the bottom of the bar the line should appear */
static const int ulineall 		= 0;	/* 1 to show underline on all tags, 0 for just the active ones */

static const unsigned int baralpha = 0xd0;   // Example value for bar transparency
static const unsigned int borderalpha = OPAQUE; // OPAQUE is typically 0xffU

const unsigned int alphas[][3] = {
    /*               fg      bg        border*/
    [SchemeNorm] = { OPAQUE, baralpha, borderalpha },
    [SchemeSel]  = { OPAQUE, baralpha, borderalpha },
};

static const Rule rules[] = {
	 /* class      			instance     	title       tags mask       isfloating  monitor  scratchkey */
 	 {"librewolf", 			NULL,       	NULL,       1 << 1,       	0,          -1 },
 	 {"brave-browser", 	NULL,   			NULL,       1 << 1,       	0,       		-1 },
	 {NULL,       			"spterm1",   	NULL,       SPTAG(0),       1,         	-1,      0 },
	 {NULL,       			"spterm2",   	NULL,       SPTAG(1),       1,          -1,      0 },
	 };

static Sp scratchpads[] = {
    /* name      cmd */
    {"spterm1", spcmd1},
    {"spterm2", spcmd2},
};

/* layout(s) */
static const float mfact     = 0.52; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"


static const Layout layouts[] = {
    /* symbol     arrange function */
    { "",      tile },    /* first entry is default */
    { "",      NULL },    /* no layout function means floating behavior */
    { "",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */

static const char *termcmd[]  = { "st", NULL };
static const char *powermenu[] = {"bash", "-c", ".config/rofi/powermenu/type-4/powermenu.sh", NULL};
static const char *rofi[] = {"bash", "-c", ".config/rofi/launchers/type-7/launcher.sh", NULL};
static const char *ncducmd[] = { "st", "-e", "ncdu", NULL };
static const char *dmenucmd[] = { "dmenu_run", "-l", "17", NULL };

static const Key keys[] = {

    {MODKEY,					 XK_Return,spawn, {.v = termcmd}},
		{MODKEY|ShiftMask, XK_Return,spawn, SHCMD ("dm-runner")},
		{MODKEY|Mod1Mask,	 XK_space, spawn, SHCMD("dmenu_desktop_run")},
		{MODKEY, 					 XK_space, spawn, {.v = dmenucmd}},
		{MODKEY,           XK_Escape,spawn, SHCMD ("st -e btop") },

		{MODKEY, 					 XK_a,spawn,SHCMD ("dm-aria")},

 		{MODKEY,           XK_b,spawn,SHCMD ("xdg-open https://")},
		{MODKEY|ShiftMask, XK_b,spawn,SHCMD ("librewolf")},

		{MODKEY, 					 XK_c,spawn,SHCMD ("dm-cfg-files")},

		{MODKEY, 					 XK_d,spawn,SHCMD ("dm-aria")},
	  {MODKEY|Mod1Mask,  XK_d,spawn,SHCMD ("dm-list-docs")},
    {MODKEY|ShiftMask, XK_d,spawn,      {.v = ncducmd}},

		{MODKEY,           XK_e,spawn,SHCMD ("st -e yazi")},
    // { MODKEY,                    XK_e,     spawn,          SHCMD ("xdg-open .")},

		{MODKEY,           XK_h,      showhideclient, {0} },
    {MODKEY|Mod1Mask,  XK_h,      togglebar,      {0} },

 		{MODKEY, 					 XK_i,spawn,SHCMD ("dm-wifi")},

		{MODKEY, 					 XK_l,spawn,SHCMD ("i3lock -i ~/Pictures/lockscreen/lock_scaled.png")},

		{MODKEY,	 				 XK_m,spawn,SHCMD ("dm-music-downloader")},
	  {MODKEY|Mod1Mask,	 XK_m,spawn,SHCMD ("dm-mount-usb")},

		{MODKEY,         	 XK_n,spawn,SHCMD ("bash -c 'dm-notes'")},

		{MODKEY,  				 XK_o,spawn,SHCMD ("bash -c 'ocr-x11'")},

		{MODKEY, 					 XK_p, togglescratch, {.ui = 0 } },
		{MODKEY|Mod1Mask,  XK_p, togglescratch, {.ui = 1 } },
		{MODKEY|ShiftMask, XK_p,spawn,SHCMD ("dm-power-profile")},
    // {MODKEY|Mod1Mask,  XK_p, spawn, {.v = powermenu}},

 		{MODKEY|Mod1Mask,  XK_r, riospawn, {.v = termcmd } },
		{MODKEY, 					 XK_r, spawn, SHCMD ("dm-runner")},
		{MODKEY|ShiftMask, XK_r, spawn, {.v = rofi}},

 		{MODKEY, 					 XK_s,spawn,SHCMD ("dm-screenshot")},
		// {MODKEY|Mod1Mask,	 XK_s,spawn,SHCMD ("flameshot")},

	  {MODKEY, 					 XK_v,spawn,SHCMD ("dm-list-videos")},
		{MODKEY|Mod1Mask,	 XK_v,spawn,SHCMD ("dm-video-tool")},

		{MODKEY,           XK_w,spawn,SHCMD ("feh --randomize --bg-fill ~/Pictures/wallpapers/*")},
		{MODKEY|Mod1Mask,	 XK_w,spawn,SHCMD ("bash -c 'rofi-wall-x11'")},
    {MODKEY|ShiftMask, XK_w,spawn,SHCMD ("dm-wifi")},

    {MODKEY,          XK_Right, focusstack,     {.i = +1 }},
    {MODKEY,          XK_Left,  focusstack,     {.i = -1 }},
    {MODKEY,          XK_equal, incnmaster,     {.i = +1 }},
    {MODKEY,          XK_minus, incnmaster,     {.i = -1 }},
    {MODKEY,          XK_Tab,   view,           {0} }, /* ws repeat*/

    {MODKEY,          XK_j,     setmfact,       {.f = -0.05}},
    {MODKEY,          XK_k,     setmfact,       {.f = +0.05}},

		{MODKEY|ShiftMask, XK_equal,	changeopacity, {.f = +0.05 }}, // increase the client opacity (for compositors that support _NET_WM_OPACITY)
		{MODKEY|ShiftMask, XK_minus,	changeopacity, {.f = -0.05 }}, // decrease the client opacity (for compositors that support _NET_WM_OPACITY)

    {MODKEY|Mod1Mask,            XK_0,togglegaps,  {0} },
    {MODKEY|Mod1Mask|ShiftMask,  XK_0,defaultgaps, {0} },
    {MODKEY|Mod1Mask,  XK_equal, incrgaps,       {.i = +1 } },
    {MODKEY|Mod1Mask,  XK_minus, incrgaps,       {.i = -1 } },

    { MODKEY|ShiftMask, XK_0,      tag,            {.ui = ~0 } }, /* Sticky window */
    //{ MODKEY|ShiftMask,        XK_Return,      zoom,           {0} },

    { MODKEY|ShiftMask,             XK_f,      togglefakefullscreen,  {0} },
 		{ MODKEY,             					XK_f,      togglefullscreen,  {0} },
    { MODKEY,                       XK_t,      togglefloating, {0} },

		{ 0, XF86XK_MonBrightnessUp,  spawn, SHCMD("brightness.sh up")},
		{ 0, XF86XK_MonBrightnessDown,spawn, SHCMD("brightness.sh down")},
		{ 0, XF86XK_AudioLowerVolume, spawn, SHCMD("volume.sh down")},
		{ 0, XF86XK_AudioRaiseVolume, spawn, SHCMD("volume.sh up")},
		{ 0, XF86XK_AudioMute,        spawn, SHCMD("volume.sh mute")},

    { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
    TAGKEYS(                        XK_1,                      0)
    TAGKEYS(                        XK_2,                      1)
    TAGKEYS(                        XK_3,                      2)
    TAGKEYS(                        XK_4,                      3)
    TAGKEYS(                        XK_5,                      4)

        { MODKEY|Mod1Mask,              XK_1,      setlayout,      {.v = &layouts[0]} },
        { MODKEY|Mod1Mask,              XK_2,      setlayout,      {.v = &layouts[1]} },
        { MODKEY|Mod1Mask,              XK_3,      setlayout,      {.v = &layouts[2]} },
        { MODKEY|Mod1Mask,              XK_4,      setlayout,      {.v = &layouts[3]} },
        { MODKEY|Mod1Mask,              XK_5,      setlayout,      {.v = &layouts[4]} },
        { MODKEY|Mod1Mask,              XK_6,      setlayout,      {.v = &layouts[5]} },
        { MODKEY|Mod1Mask,              XK_7,      setlayout,      {.v = &layouts[6]} },
        { MODKEY|Mod1Mask,              XK_8,      setlayout,      {.v = &layouts[7]} },
        { MODKEY|Mod1Mask,              XK_9,      setlayout,      {.v = &layouts[8]} },

        { MODKEY,                       XK_q,      killclient,     {0} },
        { MODKEY|Mod1Mask,              XK_q,      quit,           {0} },
};
/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
        /* click                event mask      button          function        argument */
        { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
        { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
        { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
        { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
        { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
        { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
        { ClkTagBar,            0,              Button1,        view,           {0} },
        { ClkTagBar,            0,              Button3,        toggleview,     {0} },
        { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
        { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
