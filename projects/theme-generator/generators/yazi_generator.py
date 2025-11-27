from . import BaseGenerator

class YaziGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "yazi.toml"
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)
        
        template = f"""# vim:fileencoding=utf-8:foldmethod=marker

# : Manager {{{{

[mgr]
cwd = {{ fg = "{self.colors['aqua']}" }}

# Hovered
hovered         = {{ reversed = true }}
preview_hovered = {{ underline = true }}

# Find
find_keyword  = {{ fg = "{self.colors['yellow']}", bold = true, italic = true, underline = true }}
find_position = {{ fg = "{self.colors['purple']}", bg = "reset", bold = true, italic = true }}

# Marker
marker_copied   = {{ fg = "{self.colors['green']}", bg = "{self.colors['green']}" }}
marker_cut      = {{ fg = "{self.colors['red']}", bg = "{self.colors['red']}" }}
marker_marked   = {{ fg = "{self.colors['aqua']}", bg = "{self.colors['aqua']}" }}
marker_selected = {{ fg = "{self.colors['yellow']}", bg = "{self.colors['yellow']}" }}

# Count
count_copied   = {{ fg = "{self.colors['background']}", bg = "{self.colors['green']}" }}
count_cut      = {{ fg = "{self.colors['background']}", bg = "{self.colors['red']}" }}
count_selected = {{ fg = "{self.colors['background']}", bg = "{self.colors['yellow']}" }}

# Border
border_symbol = "│"
border_style  = {{ fg = "{self.colors['color8']}" }}

# : }}}}


# : Tabs {{{{

[tabs]
active   = {{ fg = "{self.colors['background']}", bg = "{self.colors['blue']}", bold = true }}
inactive = {{ fg = "{self.colors['blue']}", bg = "{self.colors['color8']}" }}

# : }}}}


# : Mode {{{{

[mode]

normal_main = {{ fg = "{self.colors['background']}", bg = "{self.colors['blue']}", bold = true }}
normal_alt  = {{ fg = "{self.colors['blue']}", bg = "{self.colors['color8']}" }}

# Select mode
select_main = {{ fg = "{self.colors['background']}", bg = "{self.colors['aqua']}", bold = true }}
select_alt  = {{ fg = "{self.colors['aqua']}", bg = "{self.colors['color8']}" }}

# Unset mode
unset_main = {{ fg = "{self.colors['background']}", bg = "{self.colors['color7']}", bold = true }}
unset_alt  = {{ fg = "{self.colors['color7']}", bg = "{self.colors['color8']}" }}

# : }}}}


# : Status bar {{{{

[status]
# Permissions
perm_sep   = {{ fg = "{self.colors['color8']}" }}
perm_type  = {{ fg = "{self.colors['blue']}" }}
perm_read  = {{ fg = "{self.colors['yellow']}" }}
perm_write = {{ fg = "{self.colors['red']}" }}
perm_exec  = {{ fg = "{self.colors['green']}" }}

# Progress
progress_label  = {{ fg = "{self.colors['foreground']}", bold = true }}
progress_normal = {{ fg = "{self.colors['green']}", bg = "{self.colors['color8']}" }}
progress_error  = {{ fg = "{self.colors['yellow']}", bg = "{self.colors['red']}" }}

# : }}}}


# : Pick {{{{

[pick]
border   = {{ fg = "{self.colors['blue']}" }}
active   = {{ fg = "{self.colors['purple']}", bold = true }}
inactive = {{}}

# : }}}}


# : Input {{{{

[input]
border   = {{ fg = "{self.colors['blue']}" }}
title    = {{}}
value    = {{}}
selected = {{ reversed = true }}

# : }}}}


# : Completion {{{{

[cmp]
border = {{ fg = "{self.colors['blue']}" }}

# : }}}}


# : Tasks {{{{

[tasks]
border  = {{ fg = "{self.colors['blue']}" }}
title   = {{}}
hovered = {{ fg = "{self.colors['purple']}", bold = true }}

# : }}}}


# : Which {{{{

[which]
mask            = {{ bg = "{self.colors['color8']}" }}
cand            = {{ fg = "{self.colors['aqua']}" }}
rest            = {{ fg = "{self.colors['color8']}" }}
desc            = {{ fg = "{self.colors['purple']}" }}
separator       = "  "
separator_style = {{ fg = "{self.colors['color8']}" }}

# : }}}}


# : Help {{{{

[help]
on      = {{ fg = "{self.colors['aqua']}" }}
run     = {{ fg = "{self.colors['purple']}" }}
hovered = {{ reversed = true, bold = true }}
footer  = {{ fg = "{self.colors['color8']}", bg = "{self.colors['foreground']}" }}

# : }}}}


# : Spotter {{{{

[spot]
border   = {{ fg = "{self.colors['blue']}" }}
title    = {{ fg = "{self.colors['blue']}" }}
tbl_col  = {{ fg = "{self.colors['aqua']}" }}
tbl_cell = {{ fg = "{self.colors['purple']}", bg = "{self.colors['color8']}" }}

# : }}}}


# : Notification {{{{

[notify]
title_info  = {{ fg = "{self.colors['green']}" }}
title_warn  = {{ fg = "{self.colors['yellow']}" }}
title_error = {{ fg = "{self.colors['red']}" }}

# : }}}}


# : File-specific styles {{{{

[filetype]

rules = [
    # Image
    {{ mime = "image/*", fg = "{self.colors['aqua']}" }},
    # Media
    {{ mime = "{{audio,video}}/*", fg = "{self.colors['yellow']}" }},
    # Archive
    {{ mime = "application/{{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}}", fg = "{self.colors['purple']}" }},
    # Document
    {{ mime = "application/{{pdf,doc,rtf}}", fg = "{self.colors['green']}" }},
    # Virtual file system
    {{ mime = "vfs/{{absent,stale}}", fg = "{self.colors['color8']}" }},
    # Fallback
    {{ url = "*", fg = "{self.colors['foreground']}" }},
    {{ url = "*/", fg = "{self.colors['blue']}" }},
    # TODO: remove
    {{ name = "*", fg = "{self.colors['foreground']}" }},
    {{ name = "*/", fg = "{self.colors['blue']}" }}
]

# : }}}}
"""
        
        with open(output_file, 'w') as f:
            f.write(template)
        return output_file
