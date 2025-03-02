{pkgs}:
pkgs.writeShellScriptBin "nx" ''
  #!/bin/sh

  # Function Definitions
  nx_search() {
      echo "-> Function nx_search called"
      echo "Enter package name to search:"
      read -r package_name
      nix search nixpkgs "$package_name"
  }

  nx_config() {
      echo "-> Function nx_config called"
      cd ~/dotfiles || exit 1
      nvim flake.nix
      cd - || exit 1
  }

  nx_deploy() {
      echo "-> Function nx_deploy called"
      current_hostname=$(hostname | xargs)
      echo "-> Hostname: $current_hostname"
      cd ~/dotfiles || exit 1
      git diff -U0 **.nix
      sudo nixos-rebuild switch --flake "./#$current_hostname" --verbose 2>&1 | tee nixos-switch.log

      # Commit and push changes
      gen=$(nixos-rebuild list-generations | grep "current" | head -n 1 | xargs)
      echo "-> Committing changes: $gen"
      git commit -am "$gen"
      echo "-> Pushing changes to remote repository..."
      git push || { echo "Error: Failed to push changes."; exit 1; }

      cd - || exit 1
  }

  nx_up() {
      echo "-> Function nx_up called"
      sudo nix flake update --verbose
      current_hostname=$(hostname | xargs)
      sudo nixos-rebuild switch --flake "$HOME/dotfiles#$current_hostname" --verbose
  }

  nx_clean() {
      echo "-> Function nx_clean called"
      echo "-> Running nix-collect-garbage..."
      sudo nix-collect-garbage -d --verbose || {
          echo "Error: Failed to collect garbage."
          exit 1
      }

      # Additional cleanup steps
      echo "-> Deleting unused generations..."
      sudo nix-collect-garbage -d

      echo "-> Cleaning up unused dependencies..."
      sudo nix-collect-garbage

      echo "-> Optimizing the Nix store..."
      sudo nix-store --optimise

      echo "-> Listing installed packages in user profile:"
      nix-env -q

      echo "-> Cleaning cache directory..."
      sudo nix-store --gc

      echo "-> Removing temporary files..."
      sudo rm -rf /tmp/*

      echo "-> Cleaning log files..."
      sudo journalctl --vacuum-time=2weeks

      echo "-> Cleaning Trash..."
      rm -rf ~/.local/share/Trash/files/*
      rm -rf ~/.local/share/Trash/info/*

      echo "-> System cleanup completed successfully."
  }

  nx_gc() {
      echo "-> Function nx_gc called"
      echo "-> Wiping old profile history..."
      sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d --verbose || {
          echo "Error: Failed to wipe history."
          exit 1
      }
  }

  nx_doctor() {
      echo "-> Function nx_doctor called"
      echo "-> Running system maintenance tasks..."

      echo "-> Updating system..."
      nx_up || { echo "Error: nx_up failed."; exit 1; }

      echo "-> Running garbage collection..."
      nx_gc || { echo "Error: nx_gc failed."; exit 1; }

      echo "-> Cleaning old generations..."
      nx_clean || { echo "Error: nx_clean failed."; exit 1; }

      echo "-> System maintenance completed successfully."
  }

  nx_pull() {
      echo "-> Function nx_pull called"
      cd ~/dotfiles || exit 1
      git pull --verbose || {
          echo "Error: Failed to pull changes."
          cd - || exit 1
          exit 1
      }
      cd - || exit 1
  }

  # Interactive Prompt
  nx_prompt() {
      echo "Available options:"
      echo "1) search   - Search for a package in nixpkgs"
      echo "2) config   - Edit NixOS configuration"
      echo "3) deploy   - Deploy current NixOS configuration"
      echo "4) up       - Update NixOS flake"
      echo "5) clean    - Remove old generations and clean system"
      echo "6) gc       - Run garbage collection"
      echo "7) doctor   - Run maintenance tasks"
      echo "8) pull     - Pull latest GitHub version"
      echo "Enter the number of your choice (1-8):"

      # Read a single character without requiring Enter
      read -n 1 -r choice
      echo "" # Add a newline after input

      case "$choice" in
          1) nx_search ;;
          2) nx_config ;;
          3) nx_deploy ;;
          4) nx_up ;;
          5) nx_clean ;;
          6) nx_gc ;;
          7) nx_doctor ;;
          8) nx_pull ;;
          *) echo "Invalid choice. Exiting."; exit 1 ;;
      esac
  }

  # Command Parsing
  if [ -z "$1" ]; then
      nx_prompt
  else
      case "$1" in
          search) nx_search ;;
          config) nx_config ;;
          deploy) nx_deploy ;;
          up) nx_up ;;
          clean) nx_clean ;;
          gc) nx_gc ;;
          doctor) nx_doctor ;;
          pull) nx_pull ;;
          *) echo "Unknown command: $1"; exit 1 ;;
      esac
  fi
''
