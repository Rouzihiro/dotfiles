from . import BaseGenerator

class LazygitGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "lazygit.yml"
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)
        
        template = f"""gui:
  theme:
    activeBorderColor:
      - '{self.colors['purple']}'
      - bold
    inactiveBorderColor:
      - '{self.colors['color8']}'
    optionsTextColor:
      - '{self.colors['blue']}'
    selectedLineBgColor:
      - '{self.colors['background']}'
    cherryPickedCommitBgColor:
      - '{self.colors['color0']}'
    cherryPickedCommitFgColor:
      - '{self.colors['color5']}'
    unstagedChangesColor:
      - '{self.colors['red']}'
    defaultFgColor:
      - '{self.colors['foreground']}'
    searchingActiveBorderColor:
      - '{self.colors['yellow']}'

  authorColors:
    '*': '{self.colors['green']}'

  nerdFontsVersion: "3"
  showFileTree: true
  showIcons: true
  skipRewordInEditorWarning: true
  expandFocusedSidePanel: true
  mouseEvents: true
  editor: "nvim"

  git:
    paging:
      colorArg: always
      pager: delta --dark --paging=never
    merging:
      manualCommit: false
    commit:
      signOff: false
    log:
      showGraph: true

notARepository: "quit"
"""
        
        with open(output_file, 'w') as f:
            f.write(template)
        return output_file
