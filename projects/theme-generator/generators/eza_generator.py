from . import BaseGenerator

class EzaGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "eza.yml"
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)
        
        template = f"""colourful: true

filekinds:
  normal: {{foreground: "{self.colors['foreground']}"}}
  directory: {{foreground: "{self.colors['blue']}"}}
  symlink: {{foreground: "{self.colors['aqua']}"}}
  pipe: {{foreground: "{self.colors['gray']}"}}
  block_device: {{foreground: "{self.colors['red']}"}}
  char_device: {{foreground: "{self.colors['red']}"}}
  socket: {{foreground: "{self.colors['color8']}"}}
  special: {{foreground: "{self.colors['purple']}"}}
  executable: {{foreground: "{self.colors['green']}"}}
  mount_point: {{foreground: "{self.colors['orange']}"}}

perms:
  user_read: {{foreground: "{self.colors['foreground']}"}}
  user_write: {{foreground: "{self.colors['yellow']}"}}
  user_execute_file: {{foreground: "{self.colors['green']}"}}
  user_execute_other: {{foreground: "{self.colors['green']}"}}
  group_read: {{foreground: "{self.colors['foreground']}"}}
  group_write: {{foreground: "{self.colors['yellow']}"}}
  group_execute: {{foreground: "{self.colors['green']}"}}
  other_read: {{foreground: "{self.colors['color7']}"}}
  other_write: {{foreground: "{self.colors['yellow']}"}}
  other_execute: {{foreground: "{self.colors['green']}"}}
  special_user_file: {{foreground: "{self.colors['purple']}"}}
  special_other: {{foreground: "{self.colors['gray']}"}}
  attribute: {{foreground: "{self.colors['color7']}"}}

size:
  major: {{foreground: "{self.colors['color7']}"}}
  minor: {{foreground: "{self.colors['aqua']}"}}
  number_byte: {{foreground: "{self.colors['foreground']}"}}
  number_kilo: {{foreground: "{self.colors['foreground']}"}}
  number_mega: {{foreground: "{self.colors['blue']}"}}
  number_giga: {{foreground: "{self.colors['purple']}"}}
  number_huge: {{foreground: "{self.colors['purple']}"}}
  unit_byte: {{foreground: "{self.colors['color7']}"}}
  unit_kilo: {{foreground: "{self.colors['blue']}"}}
  unit_mega: {{foreground: "{self.colors['purple']}"}}
  unit_giga: {{foreground: "{self.colors['purple']}"}}
  unit_huge: {{foreground: "{self.colors['orange']}"}}

users:
  user_you: {{foreground: "{self.colors['foreground']}"}}
  user_root: {{foreground: "{self.colors['red']}"}}
  user_other: {{foreground: "{self.colors['purple']}"}}
  group_yours: {{foreground: "{self.colors['foreground']}"}}
  group_other: {{foreground: "{self.colors['gray']}"}}
  group_root: {{foreground: "{self.colors['red']}"}}

links:
  normal: {{foreground: "{self.colors['aqua']}"}}
  multi_link_file: {{foreground: "{self.colors['orange']}"}}

git:
  new: {{foreground: "{self.colors['green']}"}}
  modified: {{foreground: "{self.colors['yellow']}"}}
  deleted: {{foreground: "{self.colors['red']}"}}
  renamed: {{foreground: "{self.colors['aqua']}"}}
  typechange: {{foreground: "{self.colors['purple']}"}}
  ignored: {{foreground: "{self.colors['gray']}"}}
  conflicted: {{foreground: "{self.colors['color9']}"}}

git_repo:
  branch_main: {{foreground: "{self.colors['foreground']}"}}
  branch_other: {{foreground: "{self.colors['purple']}"}}
  git_clean: {{foreground: "{self.colors['green']}"}}
  git_dirty: {{foreground: "{self.colors['red']}"}}

security_context:
  colon: {{foreground: "{self.colors['gray']}"}}
  user: {{foreground: "{self.colors['foreground']}"}}
  role: {{foreground: "{self.colors['purple']}"}}
  typ: {{foreground: "{self.colors['color8']}"}}
  range: {{foreground: "{self.colors['purple']}"}}

file_type:
  image: {{foreground: "{self.colors['yellow']}"}}
  video: {{foreground: "{self.colors['red']}"}}
  music: {{foreground: "{self.colors['green']}"}}
  lossless: {{foreground: "{self.colors['aqua']}"}}
  crypto: {{foreground: "{self.colors['gray']}"}}
  document: {{foreground: "{self.colors['foreground']}"}}
  compressed: {{foreground: "{self.colors['purple']}"}}
  temp: {{foreground: "{self.colors['color9']}"}}
  compiled: {{foreground: "{self.colors['blue']}"}}
  build: {{foreground: "{self.colors['gray']}"}}
  source: {{foreground: "{self.colors['blue']}"}}

punctuation: {{foreground: "{self.colors['gray']}"}}
date: {{foreground: "{self.colors['yellow']}"}}
inode: {{foreground: "{self.colors['color7']}"}}
blocks: {{foreground: "{self.colors['gray']}"}}
header: {{foreground: "{self.colors['foreground']}"}}
octal: {{foreground: "{self.colors['aqua']}"}}
flags: {{foreground: "{self.colors['purple']}"}}

symlink_path: {{foreground: "{self.colors['aqua']}"}}
control_char: {{foreground: "{self.colors['blue']}"}}
broken_symlink: {{foreground: "{self.colors['red']}"}}
broken_path_overlay: {{foreground: "{self.colors['gray']}"}}
"""
        
        with open(output_file, 'w') as f:
            f.write(template)
        return output_file
