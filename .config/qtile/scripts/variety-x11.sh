#!/bin/bash
#
image=$1

# Create the color profile with wallust
wallust run $image

# Copy image to the .cache
cp $image ~/.cache/current_wallpaper.jpg

# Set wallpaper in qtile
qtile cmd-obj -o cmd -f restart

# Update betterlockscreen image
betterlockscreen -u ~/.cache/current_wallpaper.jpg
