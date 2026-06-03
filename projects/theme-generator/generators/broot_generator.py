from . import BaseGenerator


class BrootGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "broot.hjson"

    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)

        template = f"""
# /* ---- auto-generated broot theme ---- */

skin: {{

    default: {self.colors['color7']} none / {self.colors['color8']} none

    tree: {self.colors['color0']} none / {self.colors['background']} none
    parent: {self.colors['color4']} none / {self.colors['color6']} none

    file: {self.colors['color7']} none / {self.colors['color15']} none
    directory: {self.colors['color4']} none bold / {self.colors['color5']} none

    exe: {self.colors['color2']} none
    link: {self.colors['color5']} none

    pruning: {self.colors['color8']} none italic

    perm__: {self.colors['color0']} none
    perm_r: {self.colors['color3']} none
    perm_w: {self.colors['color1']} none
    perm_x: {self.colors['color2']} none

    owner: {self.colors['color6']} none
    group: {self.colors['color4']} none

    count: {self.colors['color3']} {self.colors['background']}

    dates: {self.colors['color8']} none
    sparse: {self.colors['color3']} none

    content_extract: {self.colors['color6']} none
    content_match: {self.colors['color2']} none bold

    git_branch: {self.colors['color3']} none
    git_insertions: {self.colors['color2']} none
    git_deletions: {self.colors['color1']} none

    git_status_current: {self.colors['color7']} none
    git_status_modified: {self.colors['color3']} none
    git_status_new: {self.colors['color2']} none bold
    git_status_ignored: {self.colors['color8']} none
    git_status_conflicted: {self.colors['color1']} none

    selected_line: none {self.colors['color8']} / none {self.colors['background']}

    char_match: {self.colors['color4']} none bold
    file_error: {self.colors['color1']} none bold

    input: {self.colors['color7']} {self.colors['background']} / {self.colors['color15']} none

    status_error: {self.colors['background']} {self.colors['color1']}
    status_job: {self.colors['color3']} {self.colors['background']}

    status_normal: {self.colors['color7']} {self.colors['background']}

    status_bold: {self.colors['color3']} {self.colors['background']} bold

    scrollbar_thumb: {self.colors['color8']} none

    help_headers: {self.colors['color4']} none bold

    preview: {self.colors['color7']} {self.colors['background']}

    preview_title: {self.colors['color4']} {self.colors['background']} bold

    preview_match: none {self.colors['color8']}

    mode_command_mark: {self.colors['background']} {self.colors['color4']} bold

}}
"""

        with open(output_file, "w") as f:
            f.write(template)

        return output_file
