{pkgs}:
pkgs.writeShellScriptBin "android" ''
  #!/bin/sh

  # Check if WayDroid is installed
  if ! command -v waydroid >/dev/null 2>&1; then
      echo "WayDroid is not installed. Please install WayDroid first."
      exit 1
  fi

  while true; do
      clear
      echo "Waydroid Manager"
      echo "Select an option:"
      echo "1) Fetch WayDroid images (GAPPS)"
      echo "2) Start the WayDroid LXC container"
      echo "3) Check WayDroid journal logs"
      echo "4) Start WayDroid session"
      echo "5) Start Android UI"
      echo "6) List all installed apps"
      echo "7) Launch an Android app"
      echo "8) Install an Android app"
      echo "9) Enter waydroid-shell"
      echo "10) Set full-UI width to 608"
      echo "11) Update Android"
      echo "12) Stop Waydroid container"
      echo "13) Remove all WayDroid images and user data"
      echo "14) Google Play Certification @ https://www.google.com/android/uncertified after you run the following command in waydroid-shell"
      echo "15) Stop all WayDroid sessions and processes"
      echo "0) Exit"
      echo -n "Enter choice: "
      read choice

      case "$choice" in
          1)
              sudo waydroid init -s GAPPS -f
              ;;
          2)
              sudo systemctl start waydroid-container
              ;;
          3)
              sudo journalctl -u waydroid-container
              ;;
          4)
              waydroid session start
              ;;
          5)
              waydroid show-full-ui
              ;;
          6)
              waydroid app list
              ;;
          7)
              echo -n "Enter application name: "
              read app_name
              waydroid app launch "$app_name" || echo "Failed to launch app '$app_name'."
              ;;
          8)
              echo -n "Enter path to APK: "
              read apk_path
              waydroid app install "$apk_path" || echo "Failed to install app from '$apk_path'."
              ;;
          9)
              sudo waydroid shell
              ;;
          10)
              echo "This will set the full UI width to 608. Are you sure? (y/n)"
              read confirm
              if [ "$confirm" = 'y' ]; then
                  waydroid prop set persist.waydroid.width 608
                  echo "UI width set to 608."
              else
                  echo "Operation canceled."
              fi
              ;;
          11)
              sudo waydroid upgrade
              ;;
          12)
              sudo systemctl stop waydroid-container
              ;;
          13)
              echo "This will remove all WayDroid images and user data. Are you sure? (y/n)"
              read confirm
              if [ "$confirm" = 'y' ]; then
                  sudo rm -r /var/lib/waydroid/* ~/.local/share/waydroid
                  echo "WayDroid images and user data removed."
              else
                  echo "Operation canceled."
              fi
              ;;
          14)
              command="ANDROID_RUNTIME_ROOT=/apex/com.android.runtime ANDROID_DATA=/data ANDROID_TZDATA_ROOT=/apex/com.android.tzdata ANDROID_I18N_ROOT=/apex/com.android.i18n sqlite3 /data/data/com.google.android.gsf/databases/gservices.db \"select * from main where name = \"android_id\";\""
              echo "$command"
              echo "$command" | wl-copy
              echo "Command copied to clipboard!"
              ;;
          15)
              sudo waydroid session stop
              sudo systemctl stop waydroid-container
              sudo pkill -f waydroid
              echo "WayDroid sessions and processes stopped."
              ;;
          0)
              exit 0
              ;;
          *)
              echo "Invalid option! Press enter to try again."
              ;;
      esac

      echo "Press enter to return to menu..."
      read
  done
''
