#!/bin/bash

CATEGORIES=(
    "PROGRAMMING"
    "OSTEOLOGY"
		"TRAUMA-GERIATRIC(BG)"
		"TRAUMA-GERIATRIC(UKE)"
    "VIDEO/SERIES"
    "YOUTUBE"
		"BROWSING"
    "WASTED"
    "STOP"
)

selected=$(printf "%s\n" "${CATEGORIES[@]}" | fzf --margin=10% --bind 'q:abort' --reverse)
fzf_status=$?

if [[ $fzf_status -ne 0 || -z "$selected" ]]; then
    exit 0
fi

tmux set -g status-interval 5

if [[ "$selected" == "STOP" ]]; then
    timew stop
    tmux set -g status-right "\
#[fg=#719cd6,bg=default]\
#[fg=#192330,bg=#719cd6]  #(echo \"#{pane_current_path}\" | awk -F/ '{ if (NF<=2) print \$NF; else print \$(NF-1)\"/\"\$NF; }') \
#[fg=#719cd6,bg=#9d79d6]#[fg=#192330,bg=#9d79d6]  \
#[fg=#9d79d6,bg=default]"
else
    timew start "$selected"
    tmux set -g status-right "\
#[fg=#719cd6,bg=default]\
#[fg=#192330,bg=#719cd6]  #(echo \"#{pane_current_path}\" | awk -F/ '{ if (NF<=2) print \$NF; else print \$(NF-1)\"/\"\$NF; }') \
#[fg=#719cd6,bg=#9d79d6]#[fg=#192330,bg=#9d79d6] $selected #(timew | awk '/^ *Total/ {split(\$NF,t,\":\"); print t[1]*60+t[2]\" min\"}') \
#[fg=#9d79d6,bg=default]"
fi
