# ~/.bashrc — minimal bootstrap

# -------------------------------
# Source global definitions
# -------------------------------
[ -f /etc/bashrc ] && source /etc/bashrc

# -------------------------------
# Source centralized Bash config
# -------------------------------
SHARED_BASHRC="$HOME/.config/zsh/.bashrc"
if [ -f "$SHARED_BASHRC" ]; then
    source "$SHARED_BASHRC"
fi

# -------------------------------
# Optional: User-specific overrides
# -------------------------------

# Ensure PATH includes local bin directories
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User-specific aliases/functions in ~/.bashrc.d
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        [ -f "$rc" ] && source "$rc"
    done
fi
unset rc

# Optional: disable systemctl pager
# export SYSTEMD_PAGER=
