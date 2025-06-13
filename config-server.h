/* See LICENSE file for copyright and license details. */
//Desktop
/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft = 1;    /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;        /* 0 means no systray */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int focusonwheel       = 0;
static const int user_bh            = 5;        /* 0 means that dwm will calculate bar height, >= 1 means dwm will user_bh as bar height */
static const char *fonts[]          = { "cantarell:size=30", "Symbols Nerd Font Mono:pixelsize=35" };
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#005577";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};

static const char *const autostart[] = {
	"sh", "-c", "feh --randomize --bg-fill /usr/share/dwm-rysn/wallpapers/*", NULL,
	"/usr/share/dwm-rysn/audio.sh", NULL,
	"/usr/share/dwm-rysn/cpptime", NULL,
	NULL /* terminate */
};

/* tagging */
static const char *tags[] = { "", "󰈹", "", "4", "5", "6"};

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     iscentered   isfloating*/
	{ "Gimp",     NULL,       NULL,       0,            0,           1},
	{ "LibreWolf",NULL,       NULL,       1 << 1,       0,           0},
	{ "firefox",NULL,       NULL,       1 << 1,       0,           0},
	{ "Code",     NULL,       NULL,       1 << 2,       0,           0},
};

/* layout(s) */
static const float mfact     = 0.5; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int decorhints  = 1;    /* 1 means respect decoration hints */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "[F]",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
//#define MODKEY Mod1Mask
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *roficmd[] = { "rofi", "-show", "drun", NULL };
static const char *termcmd[]  = { "kitty", NULL };
static const char *lock[] = { "/usr/bin/slock", NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */
	// Spawn functions
	{ MODKEY,                       XK_r,      spawn,          {.v = roficmd } },
	{ MODKEY,             			XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,             			XK_F10, spawn,          {.v = lock } },
	{ MODKEY,             			XK_l, spawn,          {.v = lock } },
	{ MODKEY|ShiftMask,             XK_w,  spawn,          SHCMD ("feh --randomize --bg-fill /usr/share/dwm-rysn/wallpapers/*")},
	// toggles
	{ MODKEY,             		    XK_f,      togglefullscr,  {0} },
	{ MODKEY,			    		XK_space,  togglefloating, {0} },
	{ MODKEY|ShiftMask,           	XK_space,  togglecanfocusfloating,   {0} },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	// modify Layout
	{ MODKEY,                       XK_a,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_x,      focusstack,     {.i = -1 } },
	{ MODKEY|ShiftMask,           	XK_w,      incnmaster,     {.i = +1 } },
	{ MODKEY|ShiftMask,           	XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,             			XK_w,     rotatestack,    {.i = +1 } },
	{ MODKEY,             			XK_d,     rotatestack,    {.i = -1 } },
	// modify layout size
	{ MODKEY,                       XK_q,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_s,      setmfact,       {.f = +0.05} },
	// set layouts 
	{ MODKEY|ShiftMask,             XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY|ShiftMask,             XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY|ShiftMask,             XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY,                       XK_e,  setlayout,      {0} },	
	// shift monitors
	{ MODKEY|ShiftMask,             XK_i,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_j,  tagmon,         {.i = +1 } },
	{ MODKEY,                       XK_i,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_j, focusmon,       {.i = +1 } },
	// tags
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	// quit
	{ MODKEY|ShiftMask,             XK_Escape,      quit,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
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