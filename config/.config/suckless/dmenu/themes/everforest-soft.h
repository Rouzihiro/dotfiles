/* Everforest Soft — Optimized for readability */
static const char *colors[SchemeLast][2] = {
    /*                     fg        bg       */
    [SchemeNorm]          = { "#d3c6aa", "#2d353b" }, // normal text on soft bg
    [SchemeSel]           = { "#ffffff", "#a7c080" }, // white text on green
    [SchemeSelHighlight]  = { "#2e383c", "#a7c080" }, // dark highlight on green
    [SchemeNormHighlight] = { "#e69875", "#2d353b" }, // orange highlight on bg
    [SchemeOut]           = { "#000000", "#83c092" }, // output (cyan)
};
