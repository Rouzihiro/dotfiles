{ pkgs }:

pkgs.writeShellScriptBin "bitwarden" ''
  #!/bin/sh

  # Ensure dependencies are installed
  if ! command -v bw &> /dev/null; then
      echo "Bitwarden CLI (bw) is not installed. Please install it first."
      exit 1
  fi

  if ! command -v wofi &> /dev/null; then
      echo "Wofi is not installed. Please install it first."
      exit 1
  fi

  if ! command -v jq &> /dev/null; then
      echo "jq is not installed. Please install it first."
      exit 1
  fi

  if ! command -v wl-copy &> /dev/null; then
      echo "wl-copy (Wayland clipboard utility) is not installed. Please install it first."
      exit 1
  fi

  if ! command -v notify-send &> /dev/null; then
      echo "notify-send is not installed. Please install it first."
      exit 1
  fi

  # Sync function to ensure the vault is up-to-date
  sync_vault() {
      echo "Syncing Bitwarden vault..."
      if ! bw sync > /dev/null 2>&1; then
          echo "Failed to sync Bitwarden vault. Please check your connection."
          exit 1
      fi
  }

  # Ensure the vault is unlocked
  unlock_vault() {
      if ! bw unlock --check > /dev/null 2>&1; then
          echo "Bitwarden vault is locked. Unlocking..."
          export BW_SESSION=$(bw unlock --raw)
          if [ -z "$BW_SESSION" ]; then
              echo "Failed to unlock Bitwarden vault."
              exit 1
          fi
      fi
  }

  # Fetch and display items
  fetch_items() {
      ITEMS=$(bw list items --search "$1" | jq -r '.[] | "\(.name) [username: \(.login.username)]"')
      if [ -z "$ITEMS" ]; then
          echo "No items found in your Bitwarden vault."
          exit 1
      fi
  }

  # Select an item using Wofi
  select_item() {
      SELECTED=$(echo "$ITEMS" | wofi --dmenu --prompt "Bitwarden")
      if [ -z "$SELECTED" ]; then
          echo "No item selected."
          exit 1
      fi
  }

  # Extract the item name from the selection
  extract_item_name() {
      ITEM_NAME=$(echo "$SELECTED" | awk -F' \\[username: ' '{print $1}')
      if [ -z "$ITEM_NAME" ]; then
          echo "Failed to extract item name."
          exit 1
      fi
  }

  # Get the password for the selected item
  get_password() {
      PASSWORD=$(bw get password "$ITEM_NAME")
      if [ -z "$PASSWORD" ]; then
          echo "Failed to retrieve password for '$ITEM_NAME'."
          exit 1
      fi
  }

  # Copy the password to the clipboard
  copy_to_clipboard() {
      echo -n "$PASSWORD" | wl-copy
      if [ $? -ne 0 ]; then
          echo "Failed to copy password to clipboard."
          exit 1
      fi
  }

  # Notify the user
  notify_user() {
      notify-send "Bitwarden" "Password for '$ITEM_NAME' copied to clipboard."
      if [ $? -ne 0 ]; then
          echo "Failed to send notification."
          exit 1
      fi
  }

  # Main script logic
  sync_vault
  unlock_vault
  fetch_items "$1"
  select_item
  extract_item_name
  get_password
  copy_to_clipboard
  notify_user
''
