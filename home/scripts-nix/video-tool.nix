{pkgs, ...}:
pkgs.writeShellScriptBin "video-tool" ''

  #!/bin/sh

  # Create the output folder in ~/Videos if it doesn't exist
  mkdir -p ~/Videos/converted ~/Videos/split ~/Videos/merged ~/Videos/thumbnails ~/Videos/gifs

  # Function to convert video
  convert_video() {
      local input_file="$1"
      local output_file="$2"
      local video_codec="$3"
      local audio_codec="$4"
      local preset="$5"

      if [ "$video_codec" = "Passthrough" ]; then
          video_codec="copy"
      fi

      if [ "$audio_codec" = "Passthrough" ]; then
          audio_codec="copy"
      fi

      ffmpeg -i "$input_file" -c:v "$video_codec" -preset "$preset" -c:a "$audio_codec" "$output_file"
  }

  # Function to split video
  split_video() {
      local input_file="$1"
      local output_file="$2"
      local start_time="$3"
      local end_time="$4"

      ffmpeg -i "$input_file" -ss "$start_time" -to "$end_time" -c copy "$output_file"
  }

  # Function to merge videos
  merge_videos() {
      local input_files="$1"
      local output_file="$2"

      ffmpeg -f concat -safe 0 -i "$input_files" -c copy "$output_file"
  }

  # Function to create a GIF
  create_gif() {
      local input_file="$1"
      local start_time="$2"
      local duration="$3"
      local output_file="$4"

      ffmpeg -ss "$start_time" -t "$duration" -i "$input_file" -vf "fps=15,scale=480:-1:flags=lanczos" "$output_file"
  }

  # Function to create a thumbnail grid
  create_thumbnail() {
      local input_file="$1"
      local output_file="$2"

      local duration=$(ffprobe -i "$input_file" -show_entries format=duration -v quiet -of csv="p=0" | awk '{print int($1)}')
      local interval=$((duration / 16))

      ffmpeg -i "$input_file" -vf "select='not(mod(n,''${interval}))',scale=320:240,tile=4x4" -frames:v 1 "$output_file"
  }

  # Function to remove metadata
  remove_metadata() {
      local input_file="$1"
      local output_file="$2"

      ffmpeg -i "$input_file" -map_metadata -1 -c:v copy -c:a copy "$output_file"
  }

  # Function to handle file selection
  select_file() {
      find ~/Downloads ~/Videos -type f \( -iname "*.avi" -o -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.flv" -o -iname "*.webm" \) \
          -exec realpath {} \; | sort -u | wofi --dmenu --prompt "Select a video file"
  }

  # Function to ask the operation type
  select_operation() {
      echo -e "Convert\nSplit\nMerge\nCreate GIF\nCreate Thumbnail\nRemove Metadata" | wofi --dmenu --prompt "Select an operation"
  }

  # Function to ask for start time for splitting or GIF creation
  get_start_time() {
      wofi --dmenu --prompt "Enter start time (HH:MM:SS, default 00:00:00)" <<< "00:00:00"
  }

  # Function to ask for end time for splitting
  get_end_time() {
      wofi --dmenu --prompt "Enter end time (HH:MM:SS, default 00:01:00)" <<< "00:01:00"
  }

  # Function to ask for GIF duration
  get_duration() {
      wofi --dmenu --prompt "Enter GIF duration in seconds (default 5)" <<< "5"
  }

  # Function to ask how many videos to merge
  get_merge_count() {
      wofi --dmenu --prompt "How many video files do you want to merge?"
  }

  # Function to ask if user wants to select another file
  ask_for_another_file() {
      echo -e "Yes\nNo" | wofi --dmenu --prompt "Do you want to select another file?"
  }

  # Function to select video codec
  select_video_codec() {
      echo -e "Passthrough\nlibx264\nlibx265" | wofi --dmenu --prompt "Select video codec"
  }

  # Function to select audio codec
  select_audio_codec() {
      echo -e "Passthrough\naac\nmp3" | wofi --dmenu --prompt "Select audio codec"
  }

  # Function to select preset (encoding speed)
  select_preset() {
      echo -e "fast\nnormal\nslow" | wofi --dmenu --prompt "Select encoding preset"
  }

  # Main workflow
  operation=$(select_operation)
  if [ -z "$operation" ]; then
      notify-send "Video Tool" "No operation selected. Exiting."
      exit 1
  fi

  selected_files=()
  if [ "$operation" = "Merge" ]; then
      merge_count=$(get_merge_count)
      if ! [[ "$merge_count" =~ ^[0-9]+$ ]]; then
          notify-send "Video Tool" "Invalid number entered. Exiting."
          exit 1
      fi

      for ((i = 1; i <= merge_count; i++)); do
          file_to_merge=$(select_file)

          if [ -z "$file_to_merge" ]; then
              notify-send "Video Tool" "No file selected. Exiting."
              exit 1
          fi

          selected_files+=("$file_to_merge")
      done

      temp_file_list=$(mktemp)
      for file in "''${selected_files[@]}"; do
          echo "file '$file'" >> "$temp_file_list"
      done

      output_file="$HOME/Videos/merged/merged_video_$(date +%Y%m%d%H%M%S).mkv"
      merge_videos "$temp_file_list" "$output_file"
      rm "$temp_file_list"

      notify-send "Video Tool" "Merging complete: $output_file"
      exit 0
  elif [ "$operation" = "Split" ]; then
      while true; do
          file_to_split=$(select_file)
          if [ -z "$file_to_split" ]; then
              notify-send "Video Tool" "No file selected. Exiting."
              exit 1
          fi

          start_time=$(get_start_time)
          if [ -z "$start_time" ]; then
              notify-send "Video Tool" "No start time provided. Exiting."
              exit 1
          fi

          end_time=$(get_end_time)
          if [ -z "$end_time" ]; then
              notify-send "Video Tool" "No end time provided. Exiting."
              exit 1
          fi

          output_file="$HOME/Videos/split/$(basename "$file_to_split" .''${file_to_split##*.})_split_''${start_time}_''${end_time}.mp4"
          split_video "$file_to_split" "$output_file" "$start_time" "$end_time"
          notify-send "Video Tool" "Split complete: $output_file"

          another_file=$(ask_for_another_file)
          if [ "$another_file" != "Yes" ]; then
              break
          fi
      done
      exit 0
  elif [ "$operation" = "Create GIF" ]; then
      file_to_process=$(select_file)
      if [ -z "$file_to_process" ]; then
          notify-send "Video Tool" "No file selected. Exiting."
          exit 1
      fi

      start_time=$(get_start_time)
      if [ -z "$start_time" ]; then
          notify-send "Video Tool" "No start time provided. Exiting."
          exit 1
      fi

      duration=$(get_duration)
      if [ -z "$duration" ]; then
          notify-send "Video Tool" "No duration provided. Exiting."
          exit 1
      fi

      output_file="$HOME/Videos/gifs/$(basename "$file_to_process" .''${file_to_process##*.}).gif"
      create_gif "$file_to_process" "$start_time" "$duration" "$output_file"
      notify-send "Video Tool" "GIF creation complete: $output_file"
      exit 0
  elif [ "$operation" = "Create Thumbnail" ]; then
      file_to_process=$(select_file)
      if [ -z "$file_to_process" ]; then
          notify-send "Video Tool" "No file selected. Exiting."
          exit 1
      fi

      output_file="$HOME/Videos/thumbnails/$(basename "$file_to_process" .''${file_to_process##*.})_preview.jpg"
      create_thumbnail "$file_to_process" "$output_file"
      notify-send "Video Tool" "Thumbnail creation complete: $output_file"
      exit 0
  elif [ "$operation" = "Remove Metadata" ]; then
      file_to_process=$(select_file)
      if [ -z "$file_to_process" ]; then
          notify-send "Video Tool" "No file selected. Exiting."
          exit 1
      fi

      output_file="$HOME/Videos/$(basename "$file_to_process" .''${file_to_process##*.})_nometa.''${file_to_process##*.}"
      remove_metadata "$file_to_process" "$output_file"
      notify-send "Video Tool" "Metadata removal complete: $output_file"
      exit 0
  fi

  while true; do
      file_to_process=$(select_file)

      if [ -z "$file_to_process" ]; then
          notify-send "Video Tool" "No file selected. Exiting."
          exit 1
      fi

      selected_files+=("$file_to_process")

      another_file=$(ask_for_another_file)

      if [ "$another_file" != "Yes" ]; then
          break
      fi
  done

  for file_to_process in "''${selected_files[@]}"; do
      if [ "$operation" = "Convert" ]; then
          video_codec_choice=$(select_video_codec)
          if [ -z "$video_codec_choice" ]; then
              notify-send "Video Tool" "No video codec selected. Exiting."
              exit 1
          fi

          audio_codec_choice=$(select_audio_codec)
          if [ -z "$audio_codec_choice" ]; then
              notify-send "Video Tool" "No audio codec selected. Exiting."
              exit 1
          fi

          preset_choice=$(select_preset)
          if [ -z "$preset_choice" ]; then
              notify-send "Video Tool" "No preset selected. Exiting."
              exit 1
          fi

          output_file="$HOME/Videos/converted/$(basename "$file_to_process" .''${file_to_process##*.}).mkv"
          convert_video "$file_to_process" "$output_file" "$video_codec_choice" "$audio_codec_choice" "$preset_choice"
          notify-send "Video Tool" "Conversion complete: $output_file"
      fi
  done
''
