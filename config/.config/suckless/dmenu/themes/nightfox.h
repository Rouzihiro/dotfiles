/* Nightfox — Fixed for readability */
static const char *colors[SchemeLast][2] = {
    /*                     fg        bg       */
    [SchemeNorm]          = { "#cdcecf", "#2e3440" }, // light grey on dark bg
    [SchemeSel]           = { "#192330", "#81b29a" }, // dark text on green
    [SchemeSelHighlight]  = { "#e0def4", "#394b58" }, // lilac on muted bg
    [SchemeNormHighlight] = { "#f6c177", "#2e3440" }, // gold on dark bg
    [SchemeOut]           = { "#e0def4", "#9d79d6" }, // lilac on violet
    [SchemePrompt]        = { "#f6c177", "#2e3440" }, // gold prompt text on dark bg
};
