{
  config,
  lib,
  pkgs,
  hostname,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  name = "fish";
  category = "shell";
  cfg = config.${category}.${name};
  fishFunctions = import ./fish-functions.nix {inherit pkgs;};
in {
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
    programs.${name} = {
      enable = true;
      interactiveShellInit = ''
          set fish_greeting # Disable greeting
          direnv hook fish | source
          set -g fish_autosuggestion_enabled 1
          set -g fish_autosuggestion_color 555
          set -g fish_complete_dirs_first 1
          set -g fish_completion_pager_min_rows 10

        function lf-cd
          set tempfile (mktemp -t tmp.XXXXXX)
          lf -last-dir-path="$tempfile" $argv

          if test -f "$tempfile"
            set newdir (cat "$tempfile")
            if test "$newdir" != (pwd)
              zoxide add "$newdir"
              cd "$newdir"
            end
            rm -f "$tempfile"
          end
          commandline -f repaint
        end

        bind \cr 'lf-cd; commandline -f repaint'
        bind \er 'lf-cd (pwd); commandline -f repaint'
      '';

      shellAliases = import ./shell-aliases.nix {inherit hostname pkgs;};

      shellInit = ''
                  # Set GPG TTY
                  set -gx GPG_TTY (tty)

                  # Add custom scripts to PATH
                  fish_add_path "$HOME/dotfiles/home/scripts"

                  # Source Fish functions
                  ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: path: "source ${path}") fishFunctions)}

                  # Environment configuration
                  set -g fish_greeting
                  set -g theme_display_virtualenv yes
                  set -g fish_prompt_pwd_dir_length 3
                  set -g TRANSIENT_PROMPT 1  # Enable transient prompt by default

        # Syntax highlighting colors.
        set -g fish_color_autosuggestion 626262
        set -g fish_color_cancel 626262
        set -g fish_color_command 7cb3ff
        set -g fish_color_comment 949494 --italics
        set -g fish_color_cwd 87d787
        set -g fish_color_cwd_root ff5189
        set -g fish_color_end 949494
        set -g fish_color_error ff5454
        set -g fish_color_escape 949494
        set -g fish_color_history_current c6c6c6 --background=323437
        set -g fish_color_host e4e4e4
        set -g fish_color_host_remote e4e4e4
        set -g fish_color_keyword cf87e8
        set -g fish_color_match c6c6c6 --background=323437
        set -g fish_color_normal bdbdbd
        set -g fish_color_operator e65e72
        set -g fish_color_option bdbdbd
        set -g fish_color_param 61d5ae
        set -g fish_color_quote c6c684
        set -g fish_color_redirection 8cc85f
        set -g fish_color_search_match --background=323437
        set -g fish_color_selection --background=323437
        set -g fish_color_status ff5454
        set -g fish_color_user 36c692
        set -g fish_color_valid_path

        # Completion pager colors.
        set -g fish_pager_color_completion c6c6c6
        set -g fish_pager_color_description 949494
        set -g fish_pager_color_prefix 74b2ff
        set -g fish_pager_color_progress 949494
        set -g fish_pager_color_selected_background --background=323437
        set -g fish_pager_color_selected_completion e4e4e4
        set -g fish_pager_color_selected_description e4e4e4

                  # History configuration (reduced to 10,000 entries)
                  set -g fish_history permanent
                  set -g history_size 10000
                  set -g history_save 10000
                  set -g history_merge on

                  # Enhanced VCS configuration
                  set -g __fish_git_prompt_show_informative_status 1
                  set -g __fish_git_prompt_showupstream auto
                  set -g __fish_git_prompt_char_stateseparator " "
                  set -g __fish_git_prompt_char_cleanstate '✔'
                  set -g __fish_git_prompt_char_conflictedstate '✖'
                  set -g __fish_git_prompt_char_dirtystate '✚'
                  set -g __fish_git_prompt_char_stagedstate '●'
                  set -g __fish_git_prompt_char_untrackedfiles '…'
                  set -g __fish_git_prompt_char_upstream_ahead '↑'
                  set -g __fish_git_prompt_char_upstream_behind '↓'

                  # Transient prompt hooks
                  function __prompt_erase --on-event fish_preexec
                    if test "$TRANSIENT_PROMPT" = "1"
                      set -g TRANSIENT 1
                    end
                  end
      '';
    };
  };
}
