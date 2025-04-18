#!/usr/bin/env bash

# Only load once
[[ -n $__BASH_FUNCTIONS_LOADED ]] && return
__BASH_FUNCTIONS_LOADED=1

# Load Nix environment if available
if [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# Dependency checker with Nix suggestions
nix_require() {
    if ! command -v "$1" >/dev/null; then
        echo >&2 "🔴 Error: Command '$1' not found"
        echo >&2 "💡 Install with: nix-shell -p ${2:-$1} --run 'bash'"
        return 1
    fi
}

# --------------------------------------------------
# Git Functions
# --------------------------------------------------

gitsync() {
    git stash push --include-untracked --message "Local changes stashed by gitsync" &&
    git pull --rebase origin main || {
        echo "🛑 Conflict detected! Resolve conflicts and run:"
        echo "  To continue: git rebase --continue"
        echo "  To abort:    git rebase --abort"
        return 1
    }
    git stash pop
    echo "✅ Sync complete!"
}

gitz() {
    local force_push=false commit_message

    [[ "$1" == "--force" ]] && {
        force_push=true
        shift
    }

    commit_message="$*"
    [[ -z "$commit_message" ]] && {
        echo "Usage: gitz [--force] <commit message>"
        return 1
    }

    git add . &&
    git commit -m "$commit_message" &&
    if $force_push; then git push --force; else git push; fi
}

# --------------------------------------------------
# SSH Functions
# --------------------------------------------------

ssh-start() {
    nix_require keychain || return 1
    local keychain_args=(--agents ssh --quiet)
    keychain "${keychain_args[@]}" ~/.ssh/HP-Nixo
    source ~/.keychain/"$(hostname)"-sh
}

# --------------------------------------------------
# Utility Functions
# --------------------------------------------------

qrimg() {
    nix_require qrencode || return 1
    nix_require imagemagick || return 1
    qrencode -t png -r /dev/stdin -o /dev/stdout | \
        convert - -interpolate Nearest -filter point -resize 1000% png:/dev/stdout
}

compress() { tar c -I "xz -T 0 -7" -f "${1}.tar.xz" "$1"; }
archive()  { tar c -I "xz -T 0 -0" -f "${1}.tar.xz" "$1"; }

ta() {
    if [[ -z "$1" ]]; then
        tmux attach
    else
        tmux attach -t "$1"
    fi
}

yturl() {
    nix_require yt-dlp || return 1
    local url
    url=$(yt-dlp --get-url "$@")
    echo "$url"
    echo "$url" | wl-copy
}


DL() {
    read -rp "Enter URL: " url
    echo "Download with (c)url / (w)get / (a)ria / (y)t-dlp / (u)yturl: "
    read -r tool
    case "$tool" in
        c) curldl "$url" ;;
        w) wget1 "$url" ;;
        a) yt1 "$url" ;;
        y) ytbest "$url" ;;
        u) yturl "$url" ;;
        *) echo "Invalid option. Use (c)url, (w)get, (a)ria, (y)t-dlp, or (u)yturl." ;;
    esac
}

bwu() {
    export BW_SESSION=$(bw unlock --raw)
    bw sync
}

findreplace() {
    if [[ "$1" == "--help" || -z "$1" || -z "$2" ]]; then
        echo "Usage: findreplace <trigger> <sed expression>"
        return 1
    fi
    rg --files-with-matches "$1" | tee /dev/stderr | xargs sed -Ei "$2"
}

cpz() {
    if [[ "$1" == "--help" || $# -ne 2 ]]; then
        echo "Usage: cpz <source> <destination>"
        echo "Copies a file with a progress bar."
        return
    fi
    rsync --progress "$1" "$2"
}

s() {
    if [[ "$1" == "--help" || -z "$1" ]]; then
        echo "Usage: s <search term>"
        return 1
    fi
    grep --color=auto -rin "$1" .
}

catz() {
    if [[ "$1" == "--help" || -z "$1" ]]; then
        echo "Usage: catz <file>"
        echo "Copies file content to clipboard."
        return 1
    fi
    wl-copy < "$1"
}

fontz() {
    if [[ "$1" == "--help" || -z "$1" ]]; then
        echo "Usage: fontz <font name>"
        return 1
    fi
    fc-list | grep --color=auto -i "$1"
}

iso() {
    if [[ "$1" == "--help" || -z "$1" ]]; then
        echo "Usage: iso <iso file>"
        return 1
    fi
    sudo mkdir -p ~/mount/iso
    sudo mount -o loop "$1" ~/mount/iso
}

uniso() {
    echo "Unmounting ~/mount/iso"
    sudo umount ~/mount/iso
}

# lf_cd() {
#   local tempfile
#   tempfile=$(mktemp -t tmp.XXXXXX)
#   lf -last-dir-path="$tempfile" "$@"
#
#   if [[ -f "$tempfile" ]]; then
#     local newdir
#     newdir=$(cat "$tempfile")
#     if [[ "$newdir" != "$(pwd)" ]]; then
#       zoxide add "$newdir"
#       cd "$newdir" || return
#     fi
#     rm -f "$tempfile"
#   fi
# }
#
# # Bind Ctrl+L to lf_cd
# bind -x '"\C-l": lf_cd'


# --------------------------------------------------
# Export All Functions
# --------------------------------------------------

export -f gitsync gitz ssh-start qrimg compress archive ta yturl DL bwu findreplace cpz s catz fontz iso uniso 

