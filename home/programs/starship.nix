{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      # Default settings
      add_newline = true;
      continuation_prompt = "[▸▹ ](dimmed white)";

      format = ''
        ($nix_shell$container$fill$git_metrics)$cmd_duration
        $character
      '';

      right_format = ''
        $singularity
        $kubernetes
        $directory
        $vcsh
        $fossil_branch
        $git_branch
        $git_commit
        $git_state
        $git_status
        $hg_branch
        $pijul_channel
        $docker_context
        $package
        $c
        $cmake
        $cobol
        $daml
        $dart
        $deno
        $dotnet
        $elixir
        $elm
        $erlang
        $fennel
        $golang
        $guix_shell
        $haskell
        $haxe
        $helm
        $java
        $julia
        $kotlin
        $gradle
        $lua
        $nim
        $nodejs
        $ocaml
        $opa
        $perl
        $php
        $pulumi
        $purescript
        $python
        $raku
        $rlang
        $red
        $ruby
        $rust
        $scala
        $solidity
        $swift
        $terraform
        $vlang
        $vagrant
        $zig
        $buf
        $conda
        $meson
        $spack
        $memory_usage
        $aws
        $gcloud
        $openstack
        $azure
        $crystal
        $custom
        $status
        $os
        $battery
        $time
      '';

      # Fill Settings
      fill.symbol = " ";

      # Character Settings
      character = {
        format = "$symbol ";
        success_symbol = "[◎](bold italic bright-yellow)";
        error_symbol = "[○](italic purple)";
        vimcmd_symbol = "[■](italic dimmed green)";
        vimcmd_replace_one_symbol = "◌";
        vimcmd_replace_symbol = "□";
        vimcmd_visual_symbol = "▼";
      };

      # Env Var Settings
      env_var = {
        VIMSHELL = {
          format = "[$env_value]($style)";
          style = "green italic";
        };
      };

      # Sudo Settings
      sudo = {
        format = "[$symbol]($style)";
        style = "bold italic bright-purple";
        symbol = "⋈┈";
        disabled = true;
      };

      # Username Settings
      username = {
        style_user = "bright-yellow bold italic";
        style_root = "purple bold italic";
        format = "[⭘ $user]($style) ";
        disabled = true;
        show_always = false;
      };

      # Directory Settings
      directory = {
        home_symbol = "⌂";
        truncation_length = 2;
        truncation_symbol = "□ ";
        read_only = " ◈";
        use_os_path_sep = true;
        style = "italic blue";
        format = "[$path]($style)[$read_only]($read_only_style)";
        repo_root_style = "bold blue";
        repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) [△](bold bright-blue)";
      };

      # Cmd Duration Settings
      cmd_duration = {
        format = "[◄ $duration ](italic white)";
      };

      # Jobs Settings
      jobs = {
        format = "[$symbol$number]($style) ";
        style = "white";
        symbol = "[▶](blue italic)";
      };

      # Local IP Settings
      localip = {
        ssh_only = true;
        format = " ◯[$localipv4](bold magenta)";
        disabled = false;
      };

      # Time Settings
      time = {
        disabled = false;
        format = "[ $time]($style)";
        time_format = "%R";
        utc_time_offset = "local";
        style = "italic dimmed white";
      };

      # Battery Settings
      battery = {
        format = "[ $percentage $symbol]($style)";
        full_symbol = "█";
        charging_symbol = "[↑](italic bold green)";
        discharging_symbol = "↓";
        unknown_symbol = "░";
        empty_symbol = "▃";

        display = [
          {
            threshold = 20;
            style = "italic bold red";
          }
          {
            threshold = 60;
            style = "italic dimmed bright-purple";
          }
          {
            threshold = 70;
            style = "italic dimmed yellow";
          }
        ];
      };

      # Git Branch Settings
      git_branch = {
        format = " [$branch(:$remote_branch)]($style)";
        symbol = "[△](bold italic bright-blue)";
        style = "italic bright-blue";
        truncation_symbol = "⋯";
        truncation_length = 11;
        ignore_branches = ["main" "master"];
        only_attached = true;
      };

      # Git Metrics Settings
      git_metrics = {
        format = "([▴$added]($added_style))([▿$deleted]($deleted_style))";
        added_style = "italic dimmed green";
        deleted_style = "italic dimmed red";
        ignore_submodules = true;
        disabled = false;
      };

      # Git Status Settings
      git_status = {
        style = "bold italic bright-blue";
        format = "([⎪$ahead_behind$staged$modified$untracked$renamed$deleted$conflicted$stashed⎥]($style))";
        conflicted = "[◪◦](italic bright-magenta)";
        ahead = "[▴│[\${count}](bold white)│](italic green)";
        behind = "[▿│[\${count}](bold white)│](italic red)";
        diverged = "[◇ ▴┤[\${ahead_count}](regular white)│▿┤[\${behind_count}](regular white)│](italic bright-magenta)";
        untracked = "[◌◦](italic bright-yellow)";
        stashed = "[◃◈](italic white)";
        modified = "[●◦](italic yellow)";
        staged = "[▪┤[$count](bold white)│](italic bright-cyan)";
        renamed = "[◎◦](italic bright-blue)";
        deleted = "[✕](italic red)";
      };

      # Deno Settings
      deno = {
        format = " [deno](italic) [∫ $version](green bold)";
        version_format = "\${raw}";
      };

      # Lua Settings
      lua = {
        format = " [lua](italic) [\${symbol}\${version}]($style)";
        version_format = "\${raw}";
        symbol = "⨀ ";
        style = "bold bright-yellow";
      };

      # Node.js Settings
      nodejs = {
        format = " [node](italic) [◫ ($version)](bold bright-green)";
        version_format = "\${raw}";
        detect_files = ["package-lock.json" "yarn.lock"];
        detect_folders = ["node_modules"];
        detect_extensions = [];
      };

      # Python Settings
      python = {
        format = " [py](italic) [\${symbol}\${version}]($style)";
        symbol = "[⌉](bold bright-blue)⌊ ";
        version_format = "\${raw}";
        style = "bold bright-yellow";
      };

      # Ruby Settings
      ruby = {
        format = " [rb](italic) [\${symbol}\${version}]($style)";
        symbol = "◆ ";
        version_format = "\${raw}";
        style = "bold red";
      };

      # Rust Settings
      rust = {
        format = " [rs](italic) [$symbol$version]($style)";
        symbol = "⊃ ";
        version_format = "\${raw}";
        style = "bold red";
      };

      # Package Settings
      package = {
        format = " [pkg](italic dimmed) [$symbol$version]($style)";
        version_format = "\${raw}";
        symbol = "◨ ";
        style = "dimmed yellow italic bold";
      };

      # Swift Settings
      swift = {
        format = " [sw](italic) [\${symbol}\${version}]($style)";
        symbol = "◁ ";
        style = "bold bright-red";
        version_format = "\${raw}";
      };

      # AWS Settings (disabled)
      aws = {
        disabled = true;
        format = " [aws](italic) [$symbol $profile $region]($style)";
        style = "bold blue";
        symbol = "▲ ";
      };

      # Buf Settings
      buf = {
        symbol = "■ ";
        format = " [buf](italic) [$symbol $version $buf_version]($style)";
      };

      # C Settings
      c = {
        symbol = "ℂ ";
        format = " [$symbol($version(-$name))]($style)";
      };

      # Conda Settings
      conda = {
        symbol = "◯ ";
        format = " conda [$symbol$environment]($style)";
      };

      # Dart Settings
      dart = {
        symbol = "◁◅ ";
        format = " dart [$symbol($version )]($style)";
      };

      # Docker Context Settings
      docker_context = {
        symbol = "◧ ";
        format = " docker [$symbol$context]($style)";
      };

      # Elixir Settings
      elixir = {
        symbol = "△ ";
        format = " exs [$symbol $version OTP $otp_version ]($style)";
      };

      # Elm Settings
      elm = {
        symbol = "◩ ";
        format = " elm [$symbol($version )]($style)";
      };

      # Golang Settings
      golang = {
        symbol = "∩ ";
        format = " go [$symbol($version )]($style)";
      };

      # Haskell Settings
      haskell = {
        symbol = "❯λ ";
        format = " hs [$symbol($version )]($style)";
      };

      # Java Settings
      java = {
        symbol = "∪ ";
        format = " java [\${symbol}(\${version} )]($style)";
      };

      # Julia Settings
      julia = {
        symbol = "◎ ";
        format = " jl [$symbol($version )]($style)";
      };

      # Memory Usage Settings
      memory_usage = {
        symbol = "▪▫▪ ";
        format = " mem [\${ram}( \${swap})]($style)";
      };

      # Nim Settings
      nim = {
        symbol = "▴▲▴ ";
        format = " nim [$symbol($version )]($style)";
      };

      # Nix Shell Settings
      nix_shell = {
        style = "bold italic dimmed blue";
        symbol = "✶";
        format = "[$symbol nix⎪$state⎪]($style) [$name](italic dimmed white)";
        impure_msg = "[⌽](bold dimmed red)";
        pure_msg = "[⌾](bold dimmed green)";
        unknown_msg = "[◌](bold dimmed yellow)";
      };

      # Spack Settings
      spack = {
        symbol = "◇ ";
        format = " spack [$symbol$environment]($style)";
      };
    };
  };
}
