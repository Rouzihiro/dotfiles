#!/bin/bash
#
image=$1

# Create the color profile with wallust
wallust run $image

# Copy image to the .cache
cp $image ~/.cache/current_wallpaper.jpg

# Set wallpaper in qtile
qtile cmd-obj -o cmd -f reload_config
