/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int refresh_rate        = 60;  /* matches dwm's mouse event processing to your monitor's refresh rate for smoother window interactions */
static const unsigned int enable_noborder     = 1;   /* toggles noborder feature (0=disabled, 1=enabled) */
static const unsigned int borderpx            = 1;   /* border pixel of windows */
static const unsigned int snap                = 26;  /* snap pixel */
static const int swallowfloating              = 1;   /* 1 means swallow floating windows by default */
static const unsigned int systraypinning      = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft       = 0;   /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing      = 5;   /* systray spacing */
static const int systraypinningfailfirst      = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor */
static const int showsystray                  = 1;   /* 0 means no systray */
static const int showbar                      = 1;   /* 0 means no bar */
static const int topbar                       = 1;   /* 0 means bottom bar */
#define ICONSIZE                              24     /* icon size */
#define ICONSPACING                           5      /* space between icon and title */
#define SHOWWINICON                           1      /* 0 means no winicon */
static const char *fonts[]          = { "JetBrainsMono Nerd Font:style:semibold:size=12" };
static const char dmenufont[]       = "monospace:size=10";
static const char col_gray1[]       = "#2e3440";
static const char col_gray2[]       = "#4c566a";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#5e81ac";
static const char col_cyan1[]       = "#88c0d0";
static const char col_red[]	    		= "#bf616a";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_red },
	[SchemeSel]  = { col_cyan, col_gray1,  col_cyan  },
};

static const char *tagsel[][2] = {
   /*   fg         bg    */
  { col_cyan1, col_gray1 }, /* norm */
  { col_gray4, col_cyan  }, /* sel */
  { col_red,  col_gray1  }, /* occ but not sel */
  { col_cyan,  col_gray3 }, /* has pinned tag */
};

/* tagging */
static const char *tags[] = {"", "󰈹", "", "", ""};

static const char *const autostart[] = {
    "xset", "s", "off", NULL,
    "xset", "s", "noblank", NULL,
    "xset", "-dpms", NULL,
    "dbus-update-activation-environment", "--systemd", "--all", NULL,
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1", NULL,
 		"sh", "-c", "$HOME/.local/bin/dwm/superbar.sh", NULL,
    "flameshot", NULL,
    "dunst", NULL,
    "picom", "-b", NULL,
    "sh", "-c", "feh --randomize --bg-fill ~/Pictures/wallpapers/*", NULL,
    NULL /* terminate */
};

static const Rule rules[] = {
    /* class                instance  title           tags mask  isfloating  isterminal  noswallow  monitor */
    { "St",                 NULL,     NULL,           0,         0,          1,          0,         0 },
    { "kitty",              NULL,     NULL,           0,         0,          1,          0,         0 },
    { "alacritty",          NULL,     NULL,           0,         0,          1,          0,         0 },
    { "ghostty",            NULL,     NULL,           0,         0,          1,          0,         0 },
    { "warp-terminal",      NULL,     NULL,           0,         0,          1,          0,         0 },
    { "terminator",         NULL,     NULL,           0,         0,          1,          0,         0 },
    { "lutris",             NULL,     NULL,           0,         1,          0,          0,         0 },
    { "steam_app_default",  NULL,     NULL,           0,         1,          0,          0,         0 },
    { "thunar",             NULL,     NULL,           0,         1,          0,          0,         0 },
    { NULL,                 NULL,     "Event Tester", 0,         0,          0,          1,        -1 }, /* xev */
};

/* layout(s) */
static const float mfact     = 0.6; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

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
static const char *termcmd[]     = { "kitty", NULL };

static const char *launchercmd[] = {
    "dmenu_run",
    "-fn", "monospace-12",
    "-nb", "#1F1F28", // normal background
    "-nf", "#DCD7BA", // normal foreground
    "-sb", "#2D4F67", // selected background
    "-sf", "#C8C093", // selected foreground
    "-nhb", "#1F1F28", // normal highlight background
    "-nhf", "#7E9CD8", // normal highlight foreground
    "-shb", "#2D4F67", // selected highlight background
    "-shf", "#7E9CD8", // selected highlight foreground
    NULL
};

static Key keys[] = {
    /* modifier                     key                        function        argument */
    { MODKEY,                       XK_r,                      spawn,          {.v = launchercmd} },
    { MODKEY,                       XK_Return,                 spawn,          {.v = termcmd } },
    { MODKEY,                       XK_b,                      spawn,          SHCMD ("xdg-open https://")},
    { MODKEY,                       XK_p,                      spawn,          SHCMD ("flameshot full -p $HOME/Pictures/screenshot/")},
    { MODKEY|ShiftMask,             XK_p,                      spawn,          SHCMD ("flameshot gui -p $HOME/Pictures/screenshot/")},
    { MODKEY|ControlMask,           XK_p,                      spawn,          SHCMD ("flameshot gui --clipboard")},
    { MODKEY,                       XK_e,                      spawn,          SHCMD ("xdg-open .")},
    // { MODKEY,                       XK_w,                      spawn,          SHCMD ("looking-glass-client -F")},
		{ MODKEY|ControlMask, 					XK_w, 										 spawn, 				 SHCMD("bash -c '$HOME/.local/bin/rofi/rofi-wall-x11'") },
    { MODKEY|ShiftMask,             XK_w,                      spawn,          SHCMD ("feh --randomize --bg-fill ~/Pictures/wallpapers/*")},
    // { 0,                            XF86XK_MonBrightnessUp,    spawn,          SHCMD ("xbacklight -inc 10")},
    // { 0,                            XF86XK_MonBrightnessDown,  spawn,          SHCMD ("xbacklight -dec 10")},
		{ 0, XF86XK_MonBrightnessUp,   spawn, SHCMD("$HOME/.local/bin/multimedia/brightness.sh up") },
		{ 0, XF86XK_MonBrightnessDown, spawn, SHCMD("$HOME/.local/bin/multimedia/brightness.sh down") },
		{ 0, XF86XK_AudioLowerVolume, spawn, SHCMD("$HOME/.local/bin/multimedia/volume.sh down") },
		{ 0, XF86XK_AudioRaiseVolume, spawn, SHCMD("$HOME/.local/bin/multimedia/volume.sh up") },
		{ 0, XF86XK_AudioMute,        spawn, SHCMD("$HOME/.local/bin/multimedia/volume.sh mute") },
    { MODKEY|ShiftMask,             XK_b,                      togglebar,      {0} },
    { MODKEY,                       XK_j,                      focusstack,     {.i = +1 } },
    { MODKEY,                       XK_k,                      focusstack,     {.i = -1 } },
    { MODKEY|ShiftMask,             XK_j,                      movestack,      {.i = +1 } },
    { MODKEY|ShiftMask,             XK_k,                      movestack,      {.i = -1 } },
    { MODKEY,                       XK_i,                      incnmaster,     {.i = +1 } },
    { MODKEY,                       XK_d,                      incnmaster,     {.i = -1 } },
    { MODKEY,                       XK_h,                      setmfact,       {.f = -0.05} },
    { MODKEY,                       XK_l,                      setmfact,       {.f = +0.05} },
    { MODKEY|ShiftMask,             XK_h,                      setcfact,       {.f = +0.25} },
    { MODKEY|ShiftMask,             XK_l,                      setcfact,       {.f = -0.25} },
    { MODKEY|ShiftMask,             XK_o,                      setcfact,       {.f =  0.00} },
    { MODKEY,                       XK_z,                 		 zoom,           {0} },
    { MODKEY,                       XK_Tab,                    view,           {0} },
    { MODKEY,                       XK_q,                      killclient,     {0} },
    { MODKEY,                       XK_t,                      setlayout,      {.v = &layouts[0]} },
    { MODKEY,                       XK_m,                      setlayout,      {.v = &layouts[1]} },
    { MODKEY,                       XK_f,                      fullscreen,     {0} },
    { MODKEY,                       XK_space,                  setlayout,      {0} },
    { MODKEY|ShiftMask,             XK_m,                      togglefloating, {0} },
    { MODKEY|ShiftMask,             XK_f,                      togglefakefullscreen, {0} },
    { MODKEY,                       XK_0,                      view,           {.ui = ~0 } },
    { MODKEY,                       XK_comma,                  focusmon,       {.i = -1 } },
    { MODKEY,                       XK_period,                 focusmon,       {.i = +1 } },
    { MODKEY|ShiftMask,             XK_comma,                  tagmon,         {.i = -1 } },
    { MODKEY|ShiftMask,             XK_period,                 tagmon,         {.i = +1 } },
    TAGKEYS(                        XK_1,                      0)
    TAGKEYS(                        XK_2,                      1)
    TAGKEYS(                        XK_3,                      2)
    TAGKEYS(                        XK_4,                      3)
    TAGKEYS(                        XK_5,                      4)
    { MODKEY|ShiftMask,             XK_q,                      quit,           {0} },
    { MODKEY|ControlMask,           XK_p,                      spawn,          SHCMD("$HOME/.local/bin/rofi/rofi-power")},
    { MODKEY|ControlMask|ShiftMask, XK_r,                      spawn,          SHCMD("systemctl reboot")},
    { MODKEY|ControlMask|ShiftMask, XK_s,                      spawn,          SHCMD("systemctl suspend")},
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
    /* click                event mask      button          function        argument */
    { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
    { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
    { ClkClientWin,         MODKEY,         Button1,        moveorplace,    {.i = 2} },
    { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
    { ClkTagBar,            0,              Button1,        view,           {0} },
    { ClkTagBar,            0,              Button3,        toggleview,     {0} },
    { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
    { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
