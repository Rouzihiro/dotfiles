#!/usr/bin/env zsh

# ============================================
# Trash Manager - Interactive trash management
# ============================================

# Check if trash-cli is installed
if ! command -v trash-put &>/dev/null; then
    echo "❌ trash-cli not installed. Install with:"
    echo "  sudo apt install trash-cli  # Debian/Ubuntu"
    echo "  sudo pacman -S trash-cli    # Arch"
    echo "  brew install trash-cli      # macOS"
    return 1 2>/dev/null || exit 1
fi

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Icons
readonly ICON_LIST="📋"
readonly ICON_RESTORE="♻️"
readonly ICON_EMPTY="🗑️"
readonly ICON_INFO="📊"
readonly ICON_EXIT="❌"
readonly ICON_FILE="📄"
readonly ICON_FOLDER="📁"
readonly ICON_TRASH="🗑️"
readonly ICON_SUCCESS="✅"
readonly ICON_ERROR="❌"
readonly ICON_WARNING="⚠️"
# ============================================
# Helper Functions - CLEAN
# ============================================

_get_fzf_cmd() {
    if command -v fancy-select &>/dev/null; then
        echo "fancy-select"
    else
        echo "fzf"
    fi
}

_get_trash_size() {
    du -sh ~/.local/share/Trash 2>/dev/null | cut -f1 | tr -d ' \n' || echo "0B"
}

_get_trash_count() {
    trash-list 2>/dev/null | wc -l | tr -d ' \n' || echo 0
}

# ============================================
# Core Functions - CLEAN
# ============================================

trash_list() {
    local fzf_cmd="$(_get_fzf_cmd)"
    local selection

    local trash_data=$(trash-list 2>/dev/null)

    if [ -z "$trash_data" ]; then
        echo "${ICON_INFO} Trash is empty"
        return
    fi

    selection=$(echo "$trash_data" | \
        "$fzf_cmd" \
            --multi \
            --height=80% \
            --border=rounded \
            --prompt="${ICON_LIST} Select files (Tab: multi, Enter: view): " \
            --preview='ls -lh {} 2>/dev/null || echo "File info not available"' \
            --bind="enter:execute(ls -lh {} | less)" \
            --bind="ctrl-r:reload(trash-list 2>/dev/null)" \
            --header="Press Ctrl-R to refresh | Enter to view details")

    [ -z "$selection" ] && return
}

trash_restore() {
    echo "${ICON_RESTORE} Opening interactive restore menu..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Enter the number(s) of files to restore"
    echo "Example: 0 or 0 1 2 or 0-2"
    echo ""
    echo "Press Enter without a number to cancel"
    echo ""

    trash-restore

    echo ""
    echo "${ICON_SUCCESS} Restore operation complete"
}

trash_empty() {
    local count=$(_get_trash_count)

    if [ "$count" -eq 0 ] 2>/dev/null; then
        echo "${ICON_INFO} Trash is already empty"
        return
    fi

    echo "${ICON_WARNING} You are about to empty the trash"
    echo "  ${ICON_FILE} Items: $count"
    echo "  ${ICON_FOLDER} Size: $(_get_trash_size)"
    echo ""
    echo -n "Are you sure? (y/N): "
    read -r confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo ""
        echo "${ICON_EMPTY} Emptying trash..."
        trash-empty
        echo ""
        echo "${ICON_SUCCESS} Trash emptied successfully"
    else
        echo "${ICON_EXIT} Cancelled"
    fi
}

trash_info() {
    local count=$(_get_trash_count)
    local size=$(_get_trash_size)

    echo "${ICON_TRASH} Trash Information"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  ${ICON_FILE} Items: $count"
    echo "  ${ICON_FOLDER} Size:  $size"

    if [ "$count" -gt 0 ] 2>/dev/null; then
        echo ""
        echo "${ICON_LIST} Recent items:"
        trash-list 2>/dev/null | head -5 | while IFS= read -r line; do
            if [ -n "$line" ]; then
                echo "    ${ICON_FILE} $(basename "$line" 2>/dev/null)"
            fi
        done

        if [ "$count" -gt 5 ]; then
            echo "    ... and $((count - 5)) more"
        fi
    else
        echo ""
        echo "${ICON_INFO} Trash is empty"
    fi
}
# ============================================
# Main Menu
# ============================================

trash_manager() {
    local fzf_cmd="$(_get_fzf_cmd)"
    local action

    local menu=$(cat <<EOF
${ICON_LIST} List trash contents
${ICON_RESTORE} Restore files from trash
${ICON_EMPTY} Empty trash
${ICON_INFO} Show trash info
${ICON_EXIT} Exit
EOF
)

    action=$(echo "$menu" | \
        "$fzf_cmd" \
            --height=10 \
            --border=rounded \
            --prompt="${ICON_TRASH} Trash Manager > " \
            --header="Select an action" \
            --layout=reverse)

    case "$action" in
        *"List trash contents"*)
            clear
            trash_list
            ;;
        *"Restore files from trash"*)
            clear
            trash_restore
            ;;
        *"Empty trash"*)
            clear
            trash_empty
            ;;
        *"Show trash info"*)
            clear
            trash_info
            ;;
        *"Exit"*|"")
            return
            ;;
        *)
            echo "${ICON_ERROR} Unknown action"
            ;;
    esac

    if [ -n "$action" ] && [[ "$action" != *"Exit"* ]]; then
        echo ""
        echo "Press Enter to return to menu..."
        read -r
        clear
        trash_manager
    fi
}

# ============================================
# Aliases
# ============================================

alias trash='trash_manager'
alias tl='trash_list'
alias tr='trash_restore'
alias te='trash_empty'
alias ti='trash_info'

# ============================================
# Auto-run if script is executed directly
# ============================================

if [[ "${(%):-%x}" == "$0" ]]; then
    trash_manager
fi
