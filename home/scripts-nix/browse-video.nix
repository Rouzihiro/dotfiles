{pkgs}:
pkgs.writeShellScriptBin "browse-video" ''
  file_to_play=$(find ~/Videos ~/Downloads -type f \( -iname "*.avi" -o -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.flv" -o -iname "*.webm" \) -print0 | \
      xargs -0 -I{} basename "{}" | \
      wofi --dmenu --prompt "Select a video file")

  # If a file is selected, open it with mpv
  if [ -n "$file_to_play" ]; then
      video_path=$(find ~/Videos ~/Downloads -type f -name "$file_to_play" -print -quit)
      if [ -n "$video_path" ]; then
          mpv "$video_path"
      else
          notify-send "Error" "File not found."
      fi
  else
      notify-send "Error" "No file selected."
  fi
''
