{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    tools.vifm.enable = lib.mkEnableOption "Enable vifm";
  };

  config = lib.mkIf config.tools.vifm.enable {
    programs.vifm = {
      enable = true;
      extraConfig = ''
                       set vicmd=nvim
                       set syscalls
                       set trash
                       set history=1000
                       set nofollowlinks
                       set sortnumbers
                       set undolevels=100
                       set vimhelp
                       set norunexec
                       set timefmt=%m/%d\ %H:%M
                       set wildmenu
                       set wildstyle=popup
                       set ignorecase
                     	 set smartcase
                       set incsearch
                       set nohlsearch
                       set scrolloff=5
                       set timeoutlen=300

                       filetype * xdg-open %f

                       highlight clear
                       highlight Border cterm=none ctermfg=none ctermbg=default
                   		 highlight TopLine cterm=none ctermfg=none ctermbg=none
                  		 highlight TopLineSel cterm=bold ctermfg=none ctermbg=none
                 			 highlight Win cterm=none ctermfg=none ctermbg=default
                			 highlight CmdLine cterm=none ctermfg=none ctermbg=default

                " --- Directory Navigation Shortcuts ---
                      nnoremap gd :cd ~/Downloads<cr>
                      nnoremap gs :cd ~/dotfiles/home/scripts<cr>
                      nnoremap gf :cd ~/dotfiles<cr>
                      nnoremap gp :cd ~/dotfiles/home/programs<cr>
                      nnoremap gv :cd ~/Videos<cr>
                      nnoremap gx :cd ~/Pictures<cr>
                      nnoremap gc :cd ~/.config<cr>

                      " --- Utility Shortcuts ---
                      nnoremap zy :!echo -n %d/%c | xclip -selection clipboard<cr>:echo 'Path copied to clipboard'<cr>

                      " Open all images in current directory in sxiv thumbnail mode
                      nnoremap tx :!sxiv -t %d & <cr>

        nnoremap tp :!sh -c 'mkdir -p /tmp/pdfthumbs && rm -f /tmp/pdfthumbs/* && for f in %d/*.pdf; do [ -f "$f" ] && pdftoppm -png -f 1 -singlefile "$f" "/tmp/pdfthumbs/$(basename "$f" .pdf)" >/dev/null 2>&1; done && sxiv -t /tmp/pdfthumbs &' <cr>

        nnoremap tv :!sh -c 'mkdir -p /tmp/videothumbs && rm -f /tmp/videothumbs/* && for f in %d/*; do case "$f" in *.mp4|*.mkv|*.webm) ffmpegthumbnailer -i "$f" -o /tmp/videothumbs/$(basename "$f" | sed "s/\\.[^.]*$//").png -s 256 ;; esac; done && sxiv -t /tmp/videothumbs &' <cr>

                    " Start shell in current directory
                    nnoremap s :shell<cr>

                   " Display sorting dialog
                   nnoremap S :sort<cr>

                                                    " Toggle visibility of preview window
                                                    nnoremap w :view<cr>
                                                    vnoremap w :view<cr>gv

                                                    " Mappings for faster renaming
                                                    nnoremap I cw<c-a>
                                                    nnoremap cw cw<c-u>
                                                    nnoremap A cw

                                                    nnoremap e :edit<cr>
                                                    nnoremap <space> :select<CR>
                                                    nnoremap md :mkdir<space>
                                                    nnoremap mf :touch<space>
      '';
    };

    home.packages = with pkgs; [
      poppler_utils
      sxiv
      ffmpegthumbnailer
    ];
  };
}
