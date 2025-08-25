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

// static const char *fonts[]          = {  "JetBrainsMono Nerd Font:antialias=true:autohint=true:size=11", "Noto Sans CJK JP:size=11"  };


/* Color Scheme — Kanagawa colors */
static const char normal_bar_background[]          = "#1f1f28"; // sumi ink #1
static const char selected_bar_background[]        = "#2f2f3f"; // sumi ink #2
static const char normal_bar_foreground[]          = "#dcd7ba"; // old paper
static const char selected_bar_foreground[]        = "#c8c093"; // fuji gray
static const char normal_window_border[]           = "#4f4f5f"; // sumi shadow
static const char selected_window_border[]         = "#c8c093"; // fuji gray
static const char special_normal_window_border[]   = "#7f7f87"; // sumi middle
static const char special_selected_window_border[] = "#7fbbb3"; // wave green
static const char *colors[][3]      = {
	/*               fg         bg         border   */
   [SchemeNorm] = { normal_bar_foreground, normal_bar_background, normal_window_border },
   [SchemeSel]  = { selected_bar_foreground, selected_bar_background, selected_window_border  },
};


/* tagging */
static const char *tags[] = {"", "󰈹", "", "", ""};

static const char *const autostart[] = {
    "xset", "s", "off", NULL,
    "xset", "s", "noblank", NULL,
    "xset", "-dpms", NULL,
    "dbus-update-activation-environment", "--systemd", "--all", NULL,
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1", NULL,
 		"sh", "-c", "$HOME/.local/bin/dwm/superbar2.sh", NULL,
		"/home/rey/.local/bin/dwm/autolock.sh", NULL,
 		// "xsetroot", "-cursor_name", "left_ptr", NULL,
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
#define STATUSBAR "dwmblocks"
/* commands */
static const char *termcmd[]     = { "st", NULL };
// static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = {
     "dmenu_run",
     "-c",           // center
     "-l", "17",     // number of lines
     "-fn", "JetBrainsMono Nerd Font:size=11",
     "-nb", normal_bar_background,
     "-nf", normal_bar_foreground,
     "-sb", selected_bar_background,
     "-sf", selected_bar_foreground,
     "-nhb", normal_bar_background,
     "-nhf", normal_bar_foreground,
     "-shb", selected_bar_background,
     "-shf", selected_bar_foreground,
     NULL
 };

static Key keys[] = {
    /* modifier                     key                        function        argument */
		{ MODKEY|Mod1Mask,              XK_space,  								 spawn,          SHCMD ("~/.local/bin/dwm/dmenu-desktop") },
    { MODKEY,                       XK_space,                  spawn,          {.v = dmenucmd} },
    { MODKEY,                       XK_Return,                 spawn,          {.v = termcmd } },
    { MODKEY,                       XK_b,                      spawn,          SHCMD ("xdg-open https://")},
    { MODKEY,                       XK_p,                      spawn,          SHCMD ("flameshot full -p $HOME/Pictures/screenshot/")},
    { MODKEY|ShiftMask,             XK_p,                      spawn,          SHCMD ("flameshot gui -p $HOME/Pictures/screenshot/")},
    { MODKEY|ControlMask,           XK_p,                      spawn,          SHCMD ("flameshot gui --clipboard")},
    { MODKEY,                       XK_e,                      spawn,          SHCMD ("xdg-open .")},
    // { MODKEY,                       XK_w,                      spawn,          SHCMD ("looking-glass-client -F")},
		{ MODKEY|ControlMask, 					XK_w, 										 spawn, 				 SHCMD("bash -c '$HOME/.local/bin/rofi/rofi-wall-x11'") },
    { MODKEY|ShiftMask,             XK_w,                      spawn,          SHCMD ("feh --randomize --bg-fill ~/Pictures/wallpapers/*")},
		{ MODKEY|Mod1Mask,           		XK_r,     spawn,          SHCMD ("$HOME/.local/bin/rofi/rofi-power")},
		{ MODKEY|Mod1Mask,           		XK_o,     spawn,          SHCMD ("$HOME/.local/bin/ocr2-x11")},
		{ MODKEY|Mod1Mask,         		  XK_n,     spawn,          SHCMD ("bash -c '$HOME/.local/bin/rofi/rofi-notes'")},
	

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
