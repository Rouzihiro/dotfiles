#!/bin/mksh

# Script to download video or audio from yt

read "media_type?audio(0) or video(1): "
read "url?url: "
read "name?media name: "
read "check?everything is good? "

if [ "$media_type" = "0" ]; then
  echo "Installing audio ..."
  yt-dlp --extract-audio --audio-format mp3 "$url" -P ~/Music -o "$name.%(ext)s"
elif [ "$media_type" = "1" ]; then
  echo "Installing video ..."
  yt-dlp "$url" -P ~/Videos -o "$name.%(ext)s"
else
  echo "Invalid media type"
fi
