/* Everforest Hard */
static const char normal_bar_background[]          = "#272e33";
static const char selected_bar_background[]        = "#2e383c";
static const char normal_bar_foreground[]          = "#d3c6aa";
static const char selected_bar_foreground[]        = "#a7c080";
static const char normal_window_border[]           = "#4b565c";
static const char selected_window_border[]         = "#a7c080";
static const char special_normal_window_border[]   = "#83c092";
static const char special_selected_window_border[] = "#e67e80";

static const char *colors[][3] = {
        [SchemeNorm] = { normal_bar_foreground, normal_bar_background, normal_window_border },
        [SchemeSel]  = { selected_bar_foreground, selected_bar_background, selected_window_border },
};
