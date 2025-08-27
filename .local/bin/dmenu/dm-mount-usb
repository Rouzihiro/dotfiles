#!/bin/sh

# Configuration - Change these to match your dmenu preferences
DMENU_CMD="dmenu"
# DMENU_CMD="rofi -dmenu" # Uncomment this if you prefer rofi's dmenu mode
DMENU_OPTS="-i -l 10"     # Case-insensitive, 10 lines shown

# Helper: show menu with title on top (one column, ignores title/separator if selected)
menu_with_title() {
  local title="$1"
  shift
  local items="$*"

  choice=$(printf "%s\n---\n%s\n" "$title" "$items" | ${DMENU_CMD} ${DMENU_OPTS})

  if [ "$choice" = "$title" ] || [ "$choice" = "---" ]; then
    echo ""
  else
    echo "$choice"
  fi
}

# Function to get partition list in a dmenu-friendly format
get_partitions() {
  lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,LABEL -l | \
    grep -E 'sd[a-z][0-9]|nvme[0-9]n[0-9]p[0-9]' | \
    awk '{print $1 " | " $2 " | " $3 " | " $4 " | " $5}'
}

# Function to select a partition using dmenu
select_partition() {
  local partitions
  partitions=$(get_partitions)

  if [ -z "$partitions" ]; then
    echo "No partitions found!" | ${DMENU_CMD} ${DMENU_OPTS} -p "Error"
    exit 1
  fi

  selected=$(menu_with_title "Select partition" "$partitions")
  selected_partition=$(echo "$selected" | awk -F ' | ' '{print $1}')

  if [ -z "$selected_partition" ]; then
    echo "No partition selected. Exiting." | ${DMENU_CMD} ${DMENU_OPTS} -p "Info"
    exit 0
  fi

  echo "$selected_partition"
}

# Function to select action using dmenu
select_action() {
  menu_with_title "Choose action" "mount\nunmount\nremove"
}

# Function to handle mount/unmount/remove for partitions
partition_action() {
  selected_partition=$(select_partition)

  if [ -z "$selected_partition" ]; then
    exit 1
  fi

  action=$(select_action)

  case "$action" in
    mount)
      mount_point="$HOME/mount/usb"
      echo "Creating mount point at $mount_point..." | ${DMENU_CMD} ${DMENU_OPTS} -p "Info"
      mkdir -p "$mount_point"

      # Get the filesystem type
      fs_type=$(lsblk -o FSTYPE -n "/dev/$selected_partition")

      echo "Mounting /dev/$selected_partition to $mount_point..." | ${DMENU_CMD} ${DMENU_OPTS} -p "Info"
      if [ "$fs_type" = "ntfs" ]; then
        if sudo ntfs-3g "/dev/$selected_partition" "$mount_point" -o "uid=$(id -u),gid=$(id -g)"; then
          echo "NTFS partition mounted successfully at $mount_point." | ${DMENU_CMD} ${DMENU_OPTS} -p "Success"
        else
          echo "Failed to mount NTFS partition." | ${DMENU_CMD} ${DMENU_OPTS} -p "Error"
        fi
      else
        if sudo mount "/dev/$selected_partition" "$mount_point" -o "uid=$(id -u),gid=$(id -g)"; then
          echo "Partition mounted successfully at $mount_point." | ${DMENU_CMD} ${DMENU_OPTS} -p "Success"
        else
          echo "Failed to mount partition." | ${DMENU_CMD} ${DMENU_OPTS} -p "Error"
        fi
      fi
      ;;
    unmount)
      echo "Unmounting /dev/$selected_partition..." | ${DMENU_CMD} ${DMENU_OPTS} -p "Info"
      if sync && sudo umount "/dev/$selected_partition"; then
        echo "Partition unmounted successfully." | ${DMENU_CMD} ${DMENU_OPTS} -p "Success"
      else
        echo "Failed to unmount partition." | ${DMENU_CMD} ${DMENU_OPTS} -p "Error"
      fi
      ;;
    remove)
      echo "Removing /dev/$selected_partition..." | ${DMENU_CMD} ${DMENU_OPTS} -p "Info"
      if udisksctl power-off -b "/dev/$selected_partition"; then
        echo "Partition removed successfully." | ${DMENU_CMD} ${DMENU_OPTS} -p "Success"
      else
        echo "Failed to remove partition." | ${DMENU_CMD} ${DMENU_OPTS} -p "Error"
      fi
      ;;
    *)
      echo "Invalid action. Exiting." | ${DMENU_CMD} ${DMENU_OPTS} -p "Error"
      exit 1
      ;;
  esac
}

# Main script
partition_action
