
#!/usr/bin/env bash
# dlm — fzf download manager
# Dependencies: fzf, yt-dlp, aria2c, wl-paste/xclip, notify-send, gum (optional)

# ── Paths ─────────────────────────────────────────────────────────────────────
URL_FILE="${DLM_URL_FILE:-$HOME/Documents/Notes/downloads.md}"
DOWNLOAD_DIR="${DLM_DOWNLOAD_DIR:-$HOME/Downloads}"
DLM_DATA="${DLM_DATA:-$HOME/Downloads/dlm}"
DOWNLOADED_FILE="$DLM_DATA/downloaded.txt"
QUEUE_FILE="$DLM_DATA/queue.txt"
STATUS_FILE="$DLM_DATA/status.txt"   # "<url>|<status>|<filename>"
LOG_FILE="$DLM_DATA/dlm.log"
CLIP_WHITELIST="$DLM_DATA/clip_whitelist.txt"

mkdir -p "$DLM_DATA"
touch "$DOWNLOADED_FILE" "$QUEUE_FILE" "$STATUS_FILE" "$LOG_FILE" "$CLIP_WHITELIST"

# ── Config ────────────────────────────────────────────────────────────────────
MAX_PARALLEL=3
CLIP_WATCH_INTERVAL=1

# ── Colors (for fzf preview / echo) ──────────────────────────────────────────
RED='\033[0;31m'; GRN='\033[0;32m'; YLW='\033[0;33m'
BLU='\033[0;34m'; CYN='\033[0;36m'; RST='\033[0m'; BLD='\033[1m'

# ── Logging ───────────────────────────────────────────────────────────────────
log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"; }

# ── Notifications ─────────────────────────────────────────────────────────────
notify() { notify-send --expire-time=5000 "$1" "$2" 2>/dev/null || true; }

# ── URL validation ────────────────────────────────────────────────────────────
# Strict: must be http(s), must have a dot in the host, min length 12
is_valid_url() {
    local url="$1"
    [[ "$url" =~ ^https?://[a-zA-Z0-9._-]+\.[a-zA-Z]{2,}(/|$) ]] || return 1
    # Reject clipboard junk: file paths, localhost, IPs-only, one-word blobs
    [[ "$url" =~ ^https?://localhost ]] && return 1
    [[ "$url" =~ ^https?://127\. ]]    && return 1
    [[ ${#url} -lt 12 ]]               && return 1
    return 0
}

# Strip trailing punctuation that clipboard often captures .,);'"
sanitize_url() { echo "$1" | sed 's/[.,;)\x27"]*$//'; }

# ── Type detection ────────────────────────────────────────────────────────────
detect_type() {
    local url="$1"
    if echo "$url" | grep -qE 'youtube\.com/watch|youtu\.be/|vimeo\.com/[0-9]|dailymotion\.com/video|twitch\.tv/videos|twitter\.com/.*status|x\.com/.*status|reddit\.com/.*comments'; then
        echo "video"
    elif echo "$url" | grep -qE '\.(mp3|flac|opus|ogg|wav|m4a)(\?|$)'; then
        echo "audio"
    elif echo "$url" | grep -qE '\.(jpg|jpeg|png|gif|webp|svg)(\?|$)'; then
        echo "image"
    elif echo "$url" | grep -qE '\.(pdf|epub|zip|tar|gz|7z|rar|iso|exe|deb|rpm|AppImage)(\?|$)'; then
        echo "file"
    else
        echo "file"
    fi
}

# ── Filename prediction ───────────────────────────────────────────────────────
predict_filename() {
    local url="$1" type="$2"
    if [[ "$type" == "video" || "$type" == "audio" ]]; then
        yt-dlp --get-filename -o "%(title)s.%(ext)s" "$url" 2>/dev/null | head -1 || echo "unknown.mp4"
    else
        local f; f=$(basename "${url%%\?*}")
        [[ -z "$f" || "$f" == "/" ]] && f="download"
        echo "$f"
    fi
}

# ── Status helpers ────────────────────────────────────────────────────────────
status_set() {
    local url="$1" state="$2" fname="${3:-}"
    # Remove existing entry
    local tmp; tmp=$(mktemp)
    grep -v "^$(echo "$url" | sed 's/[[\.*^$()|?+{}]/\\&/g')|" "$STATUS_FILE" > "$tmp" 2>/dev/null || true
    echo "${url}|${state}|${fname}" >> "$tmp"
    mv "$tmp" "$STATUS_FILE"
}

status_get() {
    grep "^$(echo "$1" | sed 's/[[\.*^$()|?+{}]/\\&/g')|" "$STATUS_FILE" | cut -d'|' -f2
}

is_downloaded() { grep -qxF "$1" "$DOWNLOADED_FILE"; }

enqueue() {
    local url="$1"
    if is_downloaded "$url"; then
        log "Already downloaded: $url"; return 1
    fi
    if grep -qxF "$url" "$QUEUE_FILE" 2>/dev/null; then
        log "Already queued: $url"; return 1
    fi
    echo "$url" >> "$QUEUE_FILE"
    status_set "$url" "queued"
    log "Queued: $url"
    return 0
}

# ── Core downloader ───────────────────────────────────────────────────────────
download_link() {
    local url="$1"
    [[ -z "$url" ]] && return

    local type; type=$(detect_type "$url")
    local filename; filename=$(predict_filename "$url" "$type")
    filename=$(echo "$filename" | tr '/' '_')   # sanitize slashes

    status_set "$url" "downloading" "$filename"
    log "⬇ Starting [$type]: $filename — $url"

    local ok=0
    case "$type" in
        video)
            yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' \
                   --merge-output-format mp4 \
                   --external-downloader aria2c \
                   --external-downloader-args 'aria2c:-x4 -s4 -k1M' \
                   -o "$DOWNLOAD_DIR/%(title)s.%(ext)s" \
                   "$url" >> "$LOG_FILE" 2>&1 && ok=1
            ;;
        audio)
            yt-dlp -x --audio-format best \
                   --external-downloader aria2c \
                   -o "$DOWNLOAD_DIR/%(title)s.%(ext)s" \
                   "$url" >> "$LOG_FILE" 2>&1 && ok=1
            ;;
        *)
            aria2c --check-certificate=false \
                   -x4 -s4 -k1M \
                   -d "$DOWNLOAD_DIR" -o "$filename" \
                   "$url" >> "$LOG_FILE" 2>&1 && ok=1
            ;;
    esac

    if [[ $ok -eq 1 ]]; then
        log "✅ Done: $filename"
        status_set "$url" "done" "$filename"
        echo "$url" >> "$DOWNLOADED_FILE"
        # Remove from queue
        local tmp; tmp=$(mktemp)
        grep -vxF "$url" "$QUEUE_FILE" > "$tmp" 2>/dev/null || true
        mv "$tmp" "$QUEUE_FILE"
        notify "✅ Downloaded" "$filename"
    else
        log "❌ Failed: $url"
        status_set "$url" "failed" "$filename"
        notify "❌ Download failed" "$filename"
    fi
}

# ── Parallel runner ───────────────────────────────────────────────────────────
run_with_limit() {
    while [[ "$(jobs -rp | wc -l)" -ge "$MAX_PARALLEL" ]]; do sleep 0.5; done
    download_link "$1" &
}

# ── Process URL_FILE ──────────────────────────────────────────────────────────
cmd_import() {
    [[ ! -f "$URL_FILE" ]] && echo "URL file not found: $URL_FILE" && return
    local count=0
    while IFS= read -r line; do
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
        # Extract URLs from markdown lines (handles [text](url) and bare urls)
        while read -r url; do
            url=$(sanitize_url "$url")
            is_valid_url "$url" || continue
            enqueue "$url" && (( count++ )) || true
        done < <(echo "$line" | grep -Eo 'https?://[^ )>\]"]+')
    done < "$URL_FILE"
    echo -e "${GRN}Imported $count new URL(s) from $URL_FILE${RST}"
}

# ── Process queue (batch) ─────────────────────────────────────────────────────
cmd_run() {
    local queued=()
    while IFS= read -r url; do
        [[ -z "$url" ]] && continue
        queued+=("$url")
    done < "$QUEUE_FILE"

    if [[ ${#queued[@]} -eq 0 ]]; then
        echo -e "${YLW}Queue is empty.${RST}"; return
    fi

    echo -e "${BLU}Processing ${#queued[@]} queued download(s)…${RST}"
    for url in "${queued[@]}"; do
        run_with_limit "$url"
    done
    wait
    echo -e "${GRN}All downloads finished.${RST}"
}

# ── Add single URL ────────────────────────────────────────────────────────────
cmd_add() {
    local url="${1:-}"
    if [[ -z "$url" ]]; then
        read -rp "URL: " url
    fi
    url=$(sanitize_url "$url")
    if ! is_valid_url "$url"; then
        echo -e "${RED}Invalid URL: $url${RST}"; return 1
    fi
    if enqueue "$url"; then
        echo -e "${GRN}Queued: $url${RST}"
        read -rp "Download now? [y/N] " ans
        [[ "$ans" =~ ^[Yy]$ ]] && download_link "$url"
    else
        echo -e "${YLW}Already in queue or downloaded.${RST}"
    fi
}

# ── Clipboard watcher ─────────────────────────────────────────────────────────
cmd_watch() {
    echo -e "${CYN}Watching clipboard for URLs… (Ctrl-C to stop)${RST}"
    log "Clipboard watcher started"
    local old_clip="" new_clip=""

    while true; do
        if [[ -n "$WAYLAND_DISPLAY" ]] && command -v wl-paste &>/dev/null; then
            new_clip=$(wl-paste 2>/dev/null || true)
        elif [[ -n "$DISPLAY" ]] && command -v xclip &>/dev/null; then
            new_clip=$(xclip -o -selection clipboard 2>/dev/null || true)
        else
            echo -e "${RED}No clipboard tool found (wl-paste or xclip).${RST}"; exit 1
        fi

        if [[ "$new_clip" != "$old_clip" ]]; then
            old_clip="$new_clip"
            # Extract valid URLs only
            while read -r raw_url; do
                local url; url=$(sanitize_url "$raw_url")
                is_valid_url "$url" || continue
                is_downloaded "$url" && continue
                grep -qxF "$url" "$QUEUE_FILE" 2>/dev/null && continue

                log "📋 Clipboard URL detected: $url"
                # Ask (non-blocking) via notify-send action or just auto-queue
                echo -e "${BLU}Detected URL:${RST} $url"
                enqueue "$url"
                notify "📋 URL queued" "$url"
            done < <(echo "$new_clip" | grep -Eo 'https?://[^ \t\n\r"'\''<>]+')
        fi

        sleep "$CLIP_WATCH_INTERVAL"
    done
}

# ── fzf download manager TUI ──────────────────────────────────────────────────
cmd_ui() {
    while true; do
        local entries=()
        while IFS='|' read -r url state fname; do
            [[ -z "$url" ]] && continue
            local icon
            case "$state" in
                queued)      icon="⏳" ;;
                downloading) icon="⬇ " ;;
                done)        icon="✅" ;;
                failed)      icon="❌" ;;
                *)           icon="  " ;;
            esac
            local short_url="${url:0:60}"
            [[ ${#url} -gt 60 ]] && short_url+="…"
            entries+=("${icon} [${state}] ${fname:-$short_url}|${url}|${state}")
        done < "$STATUS_FILE"

        [[ ${#entries[@]} -eq 0 ]] && entries=("(empty — ctrl-a to add)|_empty_|_")

        local header="ctrl-a:add  ctrl-d:download-all  ctrl-r:retry-failed  ctrl-x:remove  ctrl-c:clear-done  ctrl-i:import  ctrl-w:watch  esc/q:quit"

        # --expect outputs the triggered key on line 1, the selected entry on line 2
        # enter produces an empty line 1 (no special key)
        local result key chosen
        result=$(
            printf '%s\n' "${entries[@]}" \
            | fzf \
                --expect='ctrl-a,ctrl-d,ctrl-r,ctrl-x,ctrl-c,ctrl-i,ctrl-w,q' \
                --delimiter='|' \
                --with-nth=1 \
                --ansi \
                --border=rounded \
                --prompt="dlm › " \
                --header="$header" \
                --header-first \
                --height=80% \
                --layout=reverse \
                --preview='
                    url=$(echo {} | cut -d"|" -f2)
                    state=$(echo {} | cut -d"|" -f3)
                    echo "URL:    $url"
                    echo "State:  $state"
                    echo ""
                    echo "── Recent log ──────────────────────────────"
                    grep -F "$url" "'"$LOG_FILE"'" 2>/dev/null | tail -10 || echo "(no log entries)"
                ' \
                --preview-window='down:30%:wrap' \
            2>/dev/null
        ) || true   # fzf exits 130 on Esc — prevent set -e from killing script

        key=$(printf '%s' "$result" | sed -n '1p')
        chosen=$(printf '%s' "$result" | sed -n '2p')

        case "$key" in
            ctrl-a) cmd_add ;;
            ctrl-d) cmd_run ;;
            ctrl-i) cmd_import ;;
            ctrl-w) cmd_watch ;;

            ctrl-r)
                local retried=0
                while IFS='|' read -r url state fname; do
                    [[ "$state" != "failed" ]] && continue
                    status_set "$url" "queued" "$fname"
                    run_with_limit "$url"
                    (( retried++ )) || true
                done < "$STATUS_FILE"
                wait
                echo -e "${GRN}Retried $retried failed download(s).${RST}"
                sleep 1
                ;;

            ctrl-x)
                local url; url=$(printf '%s' "$chosen" | cut -d'|' -f2)
                [[ -z "$url" || "$url" == "_empty_" ]] && continue
                local tmp; tmp=$(mktemp)
                grep -vxF "$url" "$QUEUE_FILE" > "$tmp" 2>/dev/null || true
                mv "$tmp" "$QUEUE_FILE"
                tmp=$(mktemp)
                grep -v "^$(printf '%s' "$url" | sed 's/[[\.*^$()|?+{}]/\\&/g')|" "$STATUS_FILE" > "$tmp" 2>/dev/null || true
                mv "$tmp" "$STATUS_FILE"
                echo -e "${YLW}Removed.${RST}"; sleep 0.5
                ;;

            ctrl-c)
                local tmp; tmp=$(mktemp)
                grep -v '|done|' "$STATUS_FILE" > "$tmp" 2>/dev/null || true
                mv "$tmp" "$STATUS_FILE"
                echo -e "${GRN}Cleared completed entries.${RST}"; sleep 0.5
                ;;

            q|"")
                # q key = quit; empty key + empty selection = Esc or Ctrl-C
                [[ "$key" == "q" || -z "$chosen" ]] && break
                # empty key + a selection = Enter
                local url; url=$(printf '%s' "$chosen" | cut -d'|' -f2)
                local state; state=$(printf '%s' "$chosen" | cut -d'|' -f3)
                [[ -z "$url" || "$url" == "_empty_" ]] && continue
                if [[ "$state" == "done" ]]; then
                    echo -e "${YLW}Already downloaded.${RST}"; sleep 1
                else
                    echo -e "${BLU}Downloading: $url${RST}"
                    download_link "$url"
                fi
                ;;
        esac
    done
}

# ── Log viewer ────────────────────────────────────────────────────────────────
cmd_log() {
    if command -v gum &>/dev/null; then
        gum pager < "$LOG_FILE"
    else
        less +G "$LOG_FILE"
    fi
}

# ── Help ──────────────────────────────────────────────────────────────────────
usage() {
    cat <<EOF
${BLD}dlm${RST} — fzf download manager

Usage: dlm [command] [args]

Commands:
  ${CYN}ui${RST}          Open the interactive fzf TUI           (default)
  ${CYN}add${RST} [url]   Queue a URL (prompts if omitted)
  ${CYN}run${RST}         Download all queued URLs
  ${CYN}import${RST}      Import URLs from $URL_FILE
  ${CYN}watch${RST}       Watch clipboard and auto-queue URLs
  ${CYN}log${RST}         View download log
  ${CYN}help${RST}        Show this help

TUI keybindings:
  A  Add URL          D  Download all     R  Retry failed
  X  Remove entry     C  Clear completed  I  Import from file
  W  Clipboard watch  Q  Quit
  Enter  Download selected entry

Config (env vars):
  DLM_URL_FILE      Path to URL list   (default: ~/Documents/Notes/downloads.md)
  DLM_DOWNLOAD_DIR  Download target    (default: ~/Downloads)
EOF
}

# ── Entrypoint ────────────────────────────────────────────────────────────────
case "${1:-ui}" in
    ui|"")   cmd_ui ;;
    add)     cmd_add "${2:-}" ;;
    run)     cmd_run ;;
    import)  cmd_import ;;
    watch)   cmd_watch ;;
    log)     cmd_log ;;
    help|-h|--help) usage ;;
    *)
        # Treat bare URL as `dlm add <url>`
        if is_valid_url "$1"; then cmd_add "$1"
        else echo -e "${RED}Unknown command: $1${RST}"; usage; exit 1
        fi
        ;;
esac
