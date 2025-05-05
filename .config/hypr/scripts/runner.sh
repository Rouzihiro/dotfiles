#!/usr/bin/env bash

TERM=xterm-256color
APP=$(echo -e "Neovim\nBrowser\nThunar\nFoot\nBluetooth\nReddit\nChatGPT\nGitHub\nDeepSeek\nTranslate\nYouTube\nRapidMovies\nNoodle\nFitGirl\nDodi\nFzMovies\nMaps" | fzf --reverse --border rounded)

open_url() {
    xdg-open "$1"
}

case "$APP" in
    [Nn]eovim) setsid foot -e nvim & ;;
    [Bb]rowser) open_url "about:blank" ;; 
    [Tt]hunar) setsid thunar & ;;
    [Ff]oot) setsid foot > /dev/null 2>&1 & ;;
    [Bb]luetooth) setsid blueman-manager & ;;
    [Rr]eddit) open_url "reddit.com" ;;
    [Cc]hatGPT) open_url "chatgpt.com" ;;
    [Gg]it[Hh]ub) open_url "github.com" ;;
    [Dd]eep[Ss]eek) open_url "https://chat.deepseek.com" ;;
    [Tt]ranslate) open_url "https://translate.google.com" ;;
    [Yy]ou[Tt]ube) open_url "https://www.youtube.com" ;;
    [Rr]apid[Mm]ovies) open_url "https://rmz.cr" ;;
    [Nn]oodle) open_url "https://noodlemagazine.com" ;;
    [Ff]it[Gg]irl) open_url "https://fitgirl-repacks.site" ;;
    [Dd]odi) open_url "https://dodi-repacks.site" ;;
    [Ff]z[Mm]ovies) open_url "https://fzmovies.net/movieslist.php?catID=2&by=latest" ;;
    [Mm]aps) open_url "https://www.google.de/maps" ;;
esac

sleep 0.1
