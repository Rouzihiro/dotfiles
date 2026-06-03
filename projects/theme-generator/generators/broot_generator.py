from . import BaseGenerator


def hex_to_rgb(hex_color: str, fallback="#000000") -> str:
    """
    Safely convert hex -> rgb.
    Never crashes on missing/invalid input.
    """
    if not hex_color:
        hex_color = fallback

    hex_color = hex_color.strip()

    if not hex_color.startswith("#") or len(hex_color) != 7:
        hex_color = fallback

    h = hex_color.lstrip("#")
    r = int(h[0:2], 16)
    g = int(h[2:4], 16)
    b = int(h[4:6], 16)

    return f"rgb({r}, {g}, {b})"


class BrootGenerator(BaseGenerator):

    @property
    def default_filename(self):
        return "broot.hjson"

    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)

        # ----------------------------
        # SAFE color accessor
        # ----------------------------
        def rgb(name, fallback="color7"):
            value = self.colors.get(name) or self.colors.get(fallback) or "#000000"
            return hex_to_rgb(value)

        # background/foreground safety (some palettes name inconsistently)
        bg = rgb("background", "color0")
        fg = rgb("foreground", "color7")
        muted = rgb("color8", "color8")

        template = f"""
skin: {{

    default: {fg} none / {muted} none

    tree: {rgb('color0')} none / {bg} none
    parent: {rgb('color4')} none / {rgb('color6')} none

    file: {fg} none / {rgb('color15')} none
    directory: {rgb('color4')} none bold / {rgb('color5')} none

    exe: {rgb('color2')} none
    link: {rgb('color5')} none

    pruning: {muted} none italic

    perm__: {rgb('color0')} none
    perm_r: {rgb('color3')} none
    perm_w: {rgb('color1')} none
    perm_x: {rgb('color2')} none

    owner: {rgb('color6')} none
    group: {rgb('color4')} none

    count: {rgb('color3')} {bg}

    dates: {muted} none
    sparse: {rgb('color3')} none

    content_extract: {rgb('color6')} none
    content_match: {rgb('color2')} none bold

    git_branch: {rgb('color3')} none
    git_insertions: {rgb('color2')} none
    git_deletions: {rgb('color1')} none

    git_status_current: {fg} none
    git_status_modified: {rgb('color3')} none
    git_status_new: {rgb('color2')} none bold
    git_status_ignored: {muted} none
    git_status_conflicted: {rgb('color1')} none

    selected_line: none {muted} / none {bg}

    char_match: {rgb('color4')} none bold
    file_error: {rgb('color1')} none bold

    input: {fg} {bg} / {rgb('color15')} none

    status_error: {bg} {rgb('color1')}
    status_job: {rgb('color3')} {bg}

    status_normal: {fg} {bg}

    status_bold: {rgb('color3')} {bg} bold

    scrollbar_thumb: {muted} none

    help_headers: {rgb('color4')} none bold

    preview: {fg} {bg}

    preview_title: {rgb('color4')} {bg} bold

    preview_match: none {muted}

    mode_command_mark: {bg} {rgb('color4')} bold

}}
"""

        with open(output_file, "w") as f:
            f.write(template)

        return output_file
