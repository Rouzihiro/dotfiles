/* Everforest Hard — Optimized for readability */
static const char *colors[SchemeLast][2] = {
    /*                     fg        bg       */
    [SchemeNorm]          = { "#d3c6aa", "#272e33" }, // normal text on hard bg
    [SchemeSel]           = { "#ffffff", "#a7c080" }, // bright text on green
    [SchemeSelHighlight]  = { "#2e383c", "#a7c080" }, // dark bg behind highlights
    [SchemeNormHighlight] = { "#e69875", "#272e33" }, // orange highlight on dark bg
    [SchemeOut]           = { "#000000", "#83c092" }, // output (cyan)
};
