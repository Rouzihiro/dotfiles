#!/bin/bash
#
image=$1

# Create the color profile with pywal
wal -i $image

# Copy image to the .cache
cp $image ~/.cache/current_wallpaper.jpg

# Set the image as wallpaper using swww
swww img ~/.cache/current_wallpaper.jpg

# Reload Qtile
qtile cmd-obj -o cmd -f reload_config

