#!/usr/bin/env bash
#
# setup-surface-book2.sh
# Post-install setup for Arch Linux on Surface Book 2 (Intel-only, no dGPU)
#
# What it does:
#   1. Installs linux-surface kernel + Surface-specific tooling
#   2. Enables relevant services (tlp, thermald, iptsd)
#   3. Sets CPU governor
#   4. Locates your default/working boot entry, copies its root-mount
#      options (root=, rootflags=, rootfstype=) into the surface entry,
#      creating the entry from a template if it doesn't exist yet
#   5. Appends i915.enable_psr=0 i915.fastboot=1 to the surface entry
#   6. Sets the surface entry as the default systemd-boot entry
#
# Assumes: systemd-boot (bootctl), btrfs-or-whatever-your-default-uses root,
# and that you run this AFTER a working base Arch install with systemd-boot
# already configured (i.e. `bootctl list` shows at least one working entry).
#
# Usage: sudo ./setup-surface-book2.sh

set -euo pipefail

BOOT_DIR="/boot/loader/entries"
SURFACE_ENTRY_ID="arch-surface.conf"
SURFACE_OPTS_EXTRA="i915.enable_psr=0 i915.fastboot=1"

log()  { printf '\033[1;32m[+] %s\033[0m\n' "$1"; }
warn() { printf '\033[1;33m[!] %s\033[0m\n' "$1"; }
err()  { printf '\033[1;31m[x] %s\033[0m\n' "$1" >&2; }

require_root() {
    if [[ $EUID -ne 0 ]]; then
        err "Run this as root (sudo)."
        exit 1
    fi
}

detect_aur_helper() {
    if command -v paru &>/dev/null; then echo "paru";
    elif command -v yay &>/dev/null; then echo "yay";
    else echo ""; fi
}

install_packages() {
    log "Installing official repo packages..."
    pacman -Sy --needed --noconfirm \
        linux-surface linux-surface-headers \
        iptsd libwacom-surface \
        tlp thermald cpupower fwupd powertop \
        jq

    local aur_helper
    aur_helper=$(detect_aur_helper)
    if [[ -n "$aur_helper" ]]; then
        log "Installing surface-control via $aur_helper..."
        sudo -u "${SUDO_USER:-$USER}" "$aur_helper" -S --needed --noconfirm surface-control
    else
        warn "No AUR helper (paru/yay) found. Install surface-control manually later:"
        warn "  git clone https://aur.archlinux.org/surface-control.git && cd surface-control && makepkg -si"
    fi
}

setup_services() {
    log "Enabling services..."
    systemctl enable --now tlp.service
    systemctl enable --now thermald.service
    systemctl enable --now iptsd.service || warn "iptsd.service not found/failed to start (check after reboot into surface kernel)"
    systemctl mask systemd-rfkill.service systemd-rfkill.socket 2>/dev/null || true
}

setup_governor() {
    log "Setting CPU governor to schedutil..."
    if [[ -f /etc/default/cpupower ]]; then
        sed -i 's/^#\?governor=.*/governor="schedutil"/' /etc/default/cpupower
        if ! grep -q '^governor=' /etc/default/cpupower; then
            echo 'governor="schedutil"' >> /etc/default/cpupower
        fi
    else
        echo 'governor="schedutil"' > /etc/default/cpupower
    fi
    systemctl enable --now cpupower.service || warn "cpupower.service unavailable, set governor manually if needed"
}

# Find the id of the current default/working (non-surface) boot entry via bootctl JSON
find_default_entry_id() {
    bootctl list --json=short 2>/dev/null | jq -r '
        [.[] | select(.id != null and (.id | contains("surface") | not) and (.type // "" | test("auto"; "i") | not))]
        | (map(select(.isDefault == true)) + map(select(.isSelected == true)) + .)
        | .[0].id // empty
    '
}

get_entry_field() {
    # $1 = entry id, $2 = jq field
    bootctl list --json=short 2>/dev/null | jq -r --arg id "$1" --arg field "$2" \
        '.[] | select(.id == $id) | .[$field] // empty'
}

configure_boot_entry() {
    log "Looking up default boot entry to copy root-mount options from..."
    local default_id
    default_id=$(find_default_entry_id)

    if [[ -z "$default_id" ]]; then
        err "Couldn't determine a default boot entry via bootctl. Configure the surface entry's root= options manually."
        return 1
    fi
    log "Using '$default_id' as the reference entry."

    local default_opts
    default_opts=$(get_entry_field "$default_id" "options")
    if [[ -z "$default_opts" ]]; then
        err "Couldn't read options for '$default_id'."
        return 1
    fi

    # Pull out root=, rootflags=, rootfstype= (only the ones present)
    local root_part rootflags_part rootfstype_part
    root_part=$(grep -oE 'root=[^ ]+' <<<"$default_opts" || true)
    rootflags_part=$(grep -oE 'rootflags=[^ ]+' <<<"$default_opts" || true)
    rootfstype_part=$(grep -oE 'rootfstype=[^ ]+' <<<"$default_opts" || true)

    if [[ -z "$root_part" ]]; then
        err "Reference entry has no root= option; refusing to guess. Edit ${SURFACE_ENTRY_ID} manually."
        return 1
    fi

    local new_opts="${root_part} rw ${rootflags_part} ${rootfstype_part} ${SURFACE_OPTS_EXTRA}"
    new_opts=$(tr -s ' ' <<<"$new_opts" | sed 's/^ *//;s/ *$//')

    local surface_conf="${BOOT_DIR}/${SURFACE_ENTRY_ID}"

    if [[ -f "$surface_conf" ]]; then
        log "Updating existing ${SURFACE_ENTRY_ID}..."
        cp "$surface_conf" "${surface_conf}.bak.$(date +%s)"
        # Replace the options line, preserving everything else
        sed -i "s|^options .*|options ${new_opts}|" "$surface_conf"
    else
        log "Creating ${SURFACE_ENTRY_ID} (no existing entry found)..."
        cat > "$surface_conf" << EOF
title   Arch Linux (linux-surface)
linux   /vmlinuz-linux-surface
initrd  /intel-ucode.img
initrd  /initramfs-linux-surface.img
options ${new_opts}
EOF
    fi

    log "Surface entry options set to:"
    echo "    options ${new_opts}"
}

set_default_boot_entry() {
    log "Setting ${SURFACE_ENTRY_ID} as the default boot entry..."
    bootctl set-default "${SURFACE_ENTRY_ID}"
}

set_surface_performance_mode() {
    if command -v surface-control &>/dev/null; then
        log "Setting Surface performance mode to 'performance'..."
        surface-control performance set performance || warn "surface-control failed — needs the surface-aggregator module loaded (i.e. booted into linux-surface kernel already)"
    else
        warn "surface-control not installed — set performance mode manually after reboot:"
        warn "  surface-control performance set performance"
    fi
}

main() {
    require_root
    install_packages
    setup_services
    setup_governor
    configure_boot_entry
    set_default_boot_entry
    set_surface_performance_mode

    echo
    log "Done. Reboot to boot into the linux-surface kernel by default."
    log "After reboot, verify with: cat /proc/cmdline"
}

main "$@"
