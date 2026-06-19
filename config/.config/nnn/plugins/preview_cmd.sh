#!/usr/bin/zsh
# #############################################################################
# File: preview_cmd.sh
# Description: Minimal example to preview files and directories
#              No external dependencies
#              Can be easily extended
#              Automatically exits when the NNN_FIFO closes
#              Prints a `tree` if directory or `head` if it's a file
#
# Shell: POSIX compliant
# Author: Todd Yamakawa
#
# ToDo:
#   1. Add support for more types of files
#         e.g. binary files, we shouldn't try to `head` those
# #############################################################################

# Check FIFO
NNN_FIFO=${NNN_FIFO:-$1}
if [[ ! -r "$NNN_FIFO" ]]; then
    echo "Unable to open \$NNN_FIFO='$NNN_FIFO'" | less
    exit 2
fi

# Read selection from $NNN_FIFO
while read -r selection; do
	clear

	MimeType=$(xdg-mime query filetype "$selection")

	if [[ "$MimeType" == *"image/"* && "$MimeType" != "image/gif" && "$MimeType" != "image/vnd.djvu" ]]
	then
		chafa "$selection"
	elif [[ "$MimeType" == *"text/"* ]]
	then
		bat --style=plain -P "$selection"
	elif [[ "$MimeType" == "inode/directory" ]]
	then
		tree -dah --noreport -L 2 "$selection"
	elif [[ "$MimeType" == "application/pdf" ]]
	then
		pdftoppm "$selection" /tmp/myprev -f 1 -singlefile
		chafa /tmp/myprev.ppm
	else
		echo $MimeType
	fi

done < "$NNN_FIFO"
