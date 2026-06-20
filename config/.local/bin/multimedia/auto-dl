#!/usr/bin/env bash
# Paths
URL_FILE="$HOME/Documents/Notes/downloads.md"
DOWNLOAD_DIR="$HOME/Downloads/"
DOWNLOADED_FILE="$HOME/Downloads/downloaded_links.txt"
LOG_FILE="$HOME/Downloads/download.log"
PROGRESS_DIR="$HOME/Downloads/.progress"
# Ensure folders exist
mkdir -p "$DOWNLOAD_DIR"
mkdir -p "$(dirname "$DOWNLOADED_FILE")"
mkdir -p "$PROGRESS_DIR"
touch "$URL_FILE" "$DOWNLOADED_FILE" "$LOG_FILE"
rm -f "$PROGRESS_DIR"/* 2>/dev/null
# Max parallel downloads
MAX_PARALLEL=3
# Is stdout an interactive terminal? Dashboard only makes sense if so.
IS_TTY=0
[ -t 1 ] && IS_TTY=1

# Logging helper (file-only — stdout is reserved for the dashboard)
log() {
    ts="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$ts] $*" >> "$LOG_FILE"
}
# Check if link already downloaded
is_link_downloaded() {
    grep -qxF "$1" "$DOWNLOADED_FILE"
}
# Notification helpers
notify_success() { notify-send --expire-time=5000 "Download completed" "$1"; }
notify_error() { notify-send --expire-time=5000 "Download failed" "$1"; }

# ── URL validation ────────────────────────────────────────────────────────────
# Flexible: must be http(s), has hostname with a dot, not localhost/loopback, min length 8
is_valid_url() {
    local url="$1"
    [[ "$url" =~ ^https?:// ]] || return 1

    local hostname
    hostname=$(echo "$url" | sed -E 's#^https?://([^/:]+).*$#\1#')

    [[ "$hostname" == "localhost" ]] && return 1
    [[ "$hostname" =~ ^127\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && return 1
    [[ "$hostname" =~ \. ]] || return 1
    [[ ${#url} -lt 8 ]] && return 1

    return 0
}

# Strip trailing punctuation that clipboard often captures: .,);'"
sanitize_url() { echo "$1" | sed -E "s/[.,;)\"']+\$//"; }

# ── Type detection ────────────────────────────────────────────────────────────
detect_type() {
    local url="$1"
    if echo "$url" | grep -qE 'youtube\.com/watch|youtu\.be/|vimeo\.com/[0-9]|dailymotion\.com/video|twitch\.tv/videos|twitter\.com/.*status|x\.com/.*status|reddit\.com/.*comments'; then
        echo "video"
    elif echo "$url" | grep -qE '\.(mp3|flac|opus|ogg|wav|m4a)(\?|$)'; then
        echo "audio"
    elif echo "$url" | grep -qE '\.(jpg|jpeg|png|gif|webp|svg)(\?|$)'; then
        echo "image"
    else
        echo "file"
    fi
}

# ── Filename prediction ───────────────────────────────────────────────────────
# Only "video" (site-embedded) goes through yt-dlp; everything else is a direct
# link, so basename is both correct and avoids a doomed yt-dlp call.
predict_filename() {
    local url="$1" type="$2"
    if [[ "$type" == "video" ]]; then
        local f
        f=$(yt-dlp --get-filename -o "%(title)s.%(ext)s" "$url" 2>/dev/null | head -1)
        [[ -z "$f" ]] && f="unknown.mp4"
        echo "$f"
    else
        local f; f=$(basename "${url%%\?*}")
        [[ -z "$f" || "$f" == "/" ]] && f="download"
        echo "$f"
    fi
}

# ── Progress bar rendering ────────────────────────────────────────────────────
# Draws a filled/empty block bar for an integer percent (0-100)
make_bar() {
    local pct=${1%.*}
    [[ -z "$pct" || ! "$pct" =~ ^[0-9]+$ ]] && pct=0
    (( pct > 100 )) && pct=100
    local width=24
    local filled=$(( pct * width / 100 ))
    local empty=$(( width - filled ))
    local bar
    bar=$(printf '%*s' "$filled" '')
    bar=${bar// /█}
    local rest
    rest=$(printf '%*s' "$empty" '')
    rest=${rest// /░}
    echo "${bar}${rest}"
}

# Pulls the latest percent/speed/ETA out of a raw aria2c or yt-dlp output file.
# Best-effort: regexes cover both tools' default progress line formats.
parse_progress() {
    local raw="$1"
    local last
    last=$(tail -c 4000 "$raw" 2>/dev/null | tr '\r' '\n' | grep -E '%' | tail -1)
    if [ -z "$last" ]; then
        echo "0|-|-"
        return
    fi

    local pct speed eta
    pct=$(echo "$last" | grep -oE '[0-9]{1,3}(\.[0-9]+)?%' | head -1 | tr -d '%')
    speed=$(echo "$last" | grep -oE '[0-9.]+[KMGT]i?B/s' | head -1)
    [ -z "$speed" ] && speed=$(echo "$last" | grep -oE 'DL:[0-9.]+[KMGT]i?B' | head -1 | sed 's/DL://')
    eta=$(echo "$last" | grep -oE 'ETA[: ]+[0-9a-zA-Z:]+' | head -1 | sed -E 's/ETA[: ]+//')

    [ -z "$pct" ] && pct=0
    [ -z "$speed" ] && speed="-"
    [ -z "$eta" ] && eta="-"
    echo "${pct}|${speed}|${eta}"
}

LAST_LINES=0
render_dashboard() {
    [ "$IS_TTY" = "1" ] || return

    if [ "$LAST_LINES" -gt 0 ]; then
        tput cuu "$LAST_LINES"
    fi
    tput ed

    local printed=0
    shopt -s nullglob
    local metas=("$PROGRESS_DIR"/*.meta)
    shopt -u nullglob

    if [ "${#metas[@]}" -eq 0 ]; then
        printf "💤 Idle — watching clipboard for links...\n"
        printed=1
    else
        for meta in "${metas[@]}"; do
            local job_id name
            job_id=$(basename "$meta" .meta)
            name=$(cat "$meta" 2>/dev/null)
            local done_file="$PROGRESS_DIR/$job_id.done"
            local failed_file="$PROGRESS_DIR/$job_id.failed"
            local raw_file="$PROGRESS_DIR/$job_id.raw"

            if [ -f "$done_file" ]; then
                local ticks; ticks=$(cat "$done_file" 2>/dev/null); [ -z "$ticks" ] && ticks=0
                printf "✅ %-40s complete\n" "${name:0:40}"
                ticks=$((ticks - 1))
                if [ "$ticks" -le 0 ]; then
                    rm -f "$done_file" "$meta" "$raw_file"
                else
                    echo "$ticks" > "$done_file"
                fi
            elif [ -f "$failed_file" ]; then
                local ticks; ticks=$(cat "$failed_file" 2>/dev/null); [ -z "$ticks" ] && ticks=0
                printf "❌ %-40s failed\n" "${name:0:40}"
                ticks=$((ticks - 1))
                if [ "$ticks" -le 0 ]; then
                    rm -f "$failed_file" "$meta" "$raw_file"
                else
                    echo "$ticks" > "$failed_file"
                fi
            else
                local info pct speed eta bar
                info=$(parse_progress "$raw_file")
                pct=$(echo "$info" | cut -d'|' -f1)
                speed=$(echo "$info" | cut -d'|' -f2)
                eta=$(echo "$info" | cut -d'|' -f3)
                bar=$(make_bar "$pct")
                printf "⬇️  %-30s %s %3s%%  %10s  ETA %s\n" "${name:0:30}" "$bar" "$pct" "$speed" "$eta"
            fi
            printed=$((printed + 1))
        done
    fi
    LAST_LINES=$printed
}

# Function to download a link (runs in background)
download_link() {
    url="$1"
    [ -z "$url" ] && return

    if is_link_downloaded "$url"; then
        log "⚠️ Already downloaded: $url"
        notify-send --expire-time=5000 "Already downloaded" "$url"
        return
    fi

    log "⬇️ Starting download: $url"

    type=$(detect_type "$url")
    filename=$(predict_filename "$url" "$type")

    job_id="$(date +%s%N)_${RANDOM}"
    raw_file="$PROGRESS_DIR/$job_id.raw"
    : > "$raw_file"
    echo "$filename" > "$PROGRESS_DIR/$job_id.meta"

    case "$type" in
        "video")
            if yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4' \
                      --merge-output-format mp4 \
                      --newline \
                      --external-downloader aria2c \
                      --external-downloader-args 'aria2c:-x2 -s2' \
                      -o "$DOWNLOAD_DIR/$filename" \
                      "$url" > >(tee -a "$raw_file" >> "$LOG_FILE") 2>&1; then
                log "✅ Download completed: $filename"
                notify_success "$filename"
                echo 3 > "$PROGRESS_DIR/$job_id.done"
            else
                log "❌ Download failed: $url"
                notify_error "$url"
                echo 3 > "$PROGRESS_DIR/$job_id.failed"
            fi
            ;;
        *)
            if aria2c --check-certificate=false -x2 -s2 --summary-interval=1 -d "$DOWNLOAD_DIR" -o "$filename" "$url" > >(tee -a "$raw_file" >> "$LOG_FILE") 2>&1; then
                log "✅ Download completed: $filename"
                notify_success "$filename"
                echo 3 > "$PROGRESS_DIR/$job_id.done"
            else
                log "❌ Download failed: $url"
                notify_error "$filename"
                echo 3 > "$PROGRESS_DIR/$job_id.failed"
            fi
            ;;
    esac

    echo "$url" >> "$DOWNLOADED_FILE"
}

# Wrapper to respect MAX_PARALLEL
run_with_limit() {
    while [ "$(jobs -rp | wc -l)" -ge "$MAX_PARALLEL" ]; do
        sleep 1
    done
    download_link "$1" &
}

# Function to process URLs from a file (does NOT block — dashboard picks up
# these jobs in the main loop below)
process_file() {
    while IFS= read -r url; do
        [[ -z "$url" || "$url" =~ ^# ]] && continue
        url=$(sanitize_url "$url")
        if ! is_valid_url "$url"; then
            log "🚫 Skipping invalid URL in $URL_FILE: $url"
            continue
        fi
        run_with_limit "$url"
    done < "$URL_FILE"
}

# Restore cursor on exit, whatever happens
cleanup() {
    [ "$IS_TTY" = "1" ] && tput cnorm
}
trap cleanup EXIT INT TERM

if [ "$IS_TTY" = "1" ]; then
    tput civis
    clear
    printf "📥 Download Manager — watching clipboard for links\n\n"
fi

# Initial run: queue URLs from the file (non-blocking)
process_file

# --- Main loop: clipboard watcher + dashboard, both on a 1s tick ---
old_clipboard=""
while true; do
    if [ -n "$WAYLAND_DISPLAY" ] && command -v wl-paste >/dev/null 2>&1; then
        new_clipboard=$(wl-paste 2>/dev/null)
    elif [ -n "$DISPLAY" ] && command -v xclip >/dev/null 2>&1; then
        new_clipboard=$(xclip -o -selection clipboard 2>/dev/null)
    else
        log "❌ No compatible clipboard tool found (wl-paste or xclip required)"
        exit 1
    fi

    if [ "$new_clipboard" != "$old_clipboard" ]; then
        log "📋 Clipboard changed: ${new_clipboard:0:100}..."
        echo "$new_clipboard" | grep -Eo 'https?://[^ ]+' | while read -r raw_url; do
            url=$(sanitize_url "$raw_url")
            if is_valid_url "$url"; then
                log "🔗 Detected URL: $url"
                run_with_limit "$url"
            else
                log "🚫 Ignored non-URL/invalid clipboard match: $raw_url"
            fi
        done
        old_clipboard="$new_clipboard"
    fi

    render_dashboard
    sleep 1
done
