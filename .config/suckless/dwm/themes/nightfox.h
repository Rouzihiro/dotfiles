/* Nightfox theme colors */
static const char col_bg[]      = "#192330";  // background
static const char col_fg[]      = "#cdcecf";  // foreground
static const char col_border[]  = "#393b44";  // unfocused border
static const char col_accent[]  = "#81b29a";  // selection highlight
static const char col_sel_fg[]  = "#e0def4";  // selected text fg
static const char col_sel_bg[]  = "#3e4c59";  // selected text bg

static const char *colors[][3]  = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_fg,    col_bg,    col_border },
	[SchemeSel]  = { col_sel_fg,col_sel_bg,col_accent },
};
