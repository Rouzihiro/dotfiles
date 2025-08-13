#!/bin/bash
# fzf_selector.sh — reusable fzf selection functions

# Generic single-select
select_with_fzf() {
    local prompt="$1"
    shift
    local options=("$@")
    printf '%s\n' "${options[@]}" | fzf --height=15 --border --prompt="$prompt > "
}

# Generic multi-select
select_multiple_with_fzf() {
    local prompt="$1"
    shift
    local options=("$@")
    local selected
    selected=$(printf '%s\n' "${options[@]}" | fzf --multi --height=15 --border --prompt="$prompt > ")
    mapfile -t result <<<"$selected"
    echo "${result[@]}"
}

