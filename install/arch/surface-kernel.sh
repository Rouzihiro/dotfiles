
#
# install-surface-arch.sh
# Installs the linux-surface kernel + Surface Book 2 specific deps on Arch Linux.
#
# Source: https://github.com/linux-surface/linux-surface/wiki/Installation-and-Setup
#         https://github.com/linux-surface/linux-surface/wiki/Surface-Book-2
#
# Safe to re-run: repo/key steps are idempotent.

set -euo pipefail

SURFACE_KEY_ID="56C464BAAC421453"
PACMAN_CONF="/etc/pacman.conf"

log()  { printf '\033[1;32m==>\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$1"; }
die()  { printf '\033[1;31mERROR:\033[0m %s\n' "$1" >&2; exit 1; }

[[ $EUID -eq 0 ]] || die "Run this as root (sudo $0)"

# --- 1. Import & locally sign the linux-surface signing key -----------------
log "Importing linux-surface signing key"
if ! pacman-key --list-keys "$SURFACE_KEY_ID" &>/dev/null; then
    curl -s https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
        | pacman-key --add -
    pacman-key --lsign-key "$SURFACE_KEY_ID"
else
    log "Key already imported, skipping"
fi

# --- 2. Add the [linux-surface] repo to pacman.conf --------------------------
if ! grep -q '^\[linux-surface\]' "$PACMAN_CONF"; then
    log "Adding [linux-surface] repo to $PACMAN_CONF"
    cat >> "$PACMAN_CONF" <<'EOF'

[linux-surface]
Server = https://pkg.surfacelinux.com/arch/
EOF
else
    log "[linux-surface] repo already present, skipping"
fi

log "Refreshing package databases"
pacman -Syu --noconfirm

# --- 3. Install the surface kernel + core deps -------------------------------
# linux-surface / linux-surface-headers: the patched kernel + headers
# iptsd: touchscreen/pen daemon (IPTS)
# linux-firmware-marvell: required for wifi on SB1/2, Pro 4-6, Laptop 1-2
# linux-firmware-intel: camera firmware on newer packaging split
# intel-ucode: CPU microcode (SB2 is Intel)
log "Installing linux-surface kernel and dependencies"
pacman -S --needed --noconfirm \
    linux-surface \
    linux-surface-headers \
    iptsd \
    linux-firmware-marvell \
    linux-firmware-intel \
    intel-ucode

# --- 4. Regenerate bootloader config so the new kernel is picked up ----------
log "Detecting bootloader"
if command -v grub-mkconfig &>/dev/null && [[ -d /boot/grub ]]; then
    log "GRUB detected, regenerating grub.cfg"
    grub-mkconfig -o /boot/grub/grub.cfg
elif bootctl is-installed &>/dev/null 2>&1 || [[ -d /boot/loader/entries ]]; then
    log "systemd-boot detected, creating a boot entry manually"
    ENTRIES_DIR="/boot/loader/entries"
    mkdir -p "$ENTRIES_DIR"

    ROOT_PART=$(findmnt -no SOURCE /)
    ROOT_UUID=$(findmnt -no UUID /)
    [[ -n "$ROOT_UUID" ]] || die "Could not determine root UUID from findmnt"

    KERNEL_VER=$(pacman -Qi linux-surface | awk -F': ' '/^Version/{print $2; exit}')
    ENTRY_FILE="$ENTRIES_DIR/arch-surface.conf"

    cat > "$ENTRY_FILE" <<EOF
title   Arch Linux (linux-surface)
linux   /vmlinuz-linux-surface
initrd  /intel-ucode.img
initrd  /initramfs-linux-surface.img
options root=UUID=${ROOT_UUID} rw
EOF
    log "Wrote boot entry to $ENTRY_FILE (kernel version: ${KERNEL_VER})"
    warn "Review $ENTRY_FILE — adjust 'options' if you use LUKS, btrfs subvolumes, etc."

    # Point default entry at the surface kernel if a loader.conf exists
    LOADER_CONF="/boot/loader/loader.conf"
    if [[ -f "$LOADER_CONF" ]]; then
        if grep -q '^default' "$LOADER_CONF"; then
            sed -i 's/^default.*/default  arch-surface.conf/' "$LOADER_CONF"
        else
            echo "default  arch-surface.conf" >> "$LOADER_CONF"
        fi
        log "Set arch-surface.conf as default in $LOADER_CONF"
    fi
else
    warn "Could not detect GRUB or systemd-boot automatically."
    warn "You'll need to add a boot entry for vmlinuz-linux-surface / initramfs-linux-surface.img yourself."
fi

# --- 5. AUR packages (manual, since no AUR helper is assumed) ---------------
cat <<'EOF'

==> Kernel install done. Next steps:

1. Reboot and confirm you're on the surface kernel:
     uname -a   # should contain "surface"

2. Surface Book 2 specific AUR packages (install with yay/paru or makepkg):
     surface-control       # control the dGPU
     surface-dtx-daemon    # faster/cleaner clipboard (keyboard) detach handling
     libwacom-surface      # better stylus/touch support in GTK apps

3. Known SB2 quirk: wifi (mwifiex) is unreliable when Bluetooth is active.
   Workaround: disable Bluetooth, or use 5GHz wifi with WPA2 (WPA3 unsupported
   on this card).

4. Consider thermald to avoid hard throttling under load — a minimal SB2
   config lives at:
     https://github.com/linux-surface/linux-surface/tree/master/contrib/thermald

5. If you want secure boot with the surface kernel, see:
     https://github.com/linux-surface/linux-surface/wiki/Secure-Boot
   (only relevant if you already set up shim/secureboot for the stock kernel)

EOF
