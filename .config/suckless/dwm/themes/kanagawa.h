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

