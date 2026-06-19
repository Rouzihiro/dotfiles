#!/usr/bin/env bash
# install-voxtype-arch.sh — Voxtype setup for Arch Linux x86_64 + Sway
# Usage: bash install-voxtype-arch.sh

set -euo pipefail

CONFIG_DIR="$HOME/.config/voxtype"
CONFIG_FILE="$CONFIG_DIR/config.toml"

# ── colours ────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
ok()   { echo -e "${GREEN}  ✓${NC} $*"; }
warn() { echo -e "${YELLOW}  ⚠${NC} $*"; }
die()  { echo -e "${RED}  ✗ $*${NC}" >&2; exit 1; }

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Voxtype — Arch Linux x86_64 setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── 0. detect AUR helper ───────────────────────────────────────────────────
if command -v paru &>/dev/null; then
  AUR="paru"
elif command -v yay &>/dev/null; then
  AUR="yay"
else
  die "No AUR helper found. Install paru or yay first."
fi
ok "AUR helper: $AUR"

# ── 1. dependencies ────────────────────────────────────────────────────────
echo ""
echo "▸ Installing dependencies..."
sudo pacman -S --needed --noconfirm wtype wl-clipboard libnotify pipewire-alsa \
  playerctl gtk4-layer-shell \
  || warn "Some optional deps may have failed — continuing"
ok "Dependencies installed"

# ── 2. install voxtype from AUR ────────────────────────────────────────────
echo ""
echo "▸ Installing voxtype-bin from AUR..."
$AUR -S --needed --noconfirm voxtype-bin
ok "voxtype installed"
voxtype --version

# ── 3. first-run setup (downloads whisper model) ───────────────────────────
echo ""
echo "▸ Running voxtype setup (downloads Whisper model — may take a moment)..."
voxtype setup --download
ok "Model downloaded"

# ── 4. write config ────────────────────────────────────────────────────────
echo ""
echo "▸ Configuring for Sway..."
mkdir -p "$CONFIG_DIR"

if [[ -f "$CONFIG_FILE" ]]; then
  warn "Config already exists — skipping write ($CONFIG_FILE)"
else
  cat > "$CONFIG_FILE" << 'EOF'
# Voxtype configuration
# Keybinds are handled by Sway — see ~/.config/sway/config

[whisper]
model = "base"
language = ["en", "de"]

[hotkey]
enabled = false

EOF
  ok "Config written ($CONFIG_FILE)"
fi

grep -q 'state_file' "$CONFIG_FILE" \
  || { echo 'state_file = "auto"' >> "$CONFIG_FILE"; ok "state_file set"; }

# ── 5. systemd user service ────────────────────────────────────────────────
echo ""
echo "▸ Installing systemd user service..."
voxtype setup systemd
ok "Service installed and started"

# ── 6. sway compositor integration ────────────────────────────────────────
echo ""
echo "▸ Installing Sway compositor integration..."
voxtype setup compositor sway || warn "Sway integration step had warnings (see above)"
ok "Sway integration done"

# ── 7. restart daemon ─────────────────────────────────────────────────────
echo ""
echo "▸ Restarting voxtype daemon..."
systemctl --user restart voxtype
ok "Daemon running"

# ── done ───────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}  ✓ Voxtype is ready!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Next:"
echo "  1. Add keybinds to ~/.config/sway/config:"
echo "       bindsym \$mod+x exec voxtype record start"
echo "       bindsym --release \$mod+x exec voxtype record stop"
echo ""
echo "  2. Add this line if not already present:"
echo "       include ~/.config/sway/conf.d/*.conf"
echo ""
echo "  3. Reload Sway: swaymsg reload"
echo ""
echo "  Config:  $CONFIG_FILE"
echo "  Logs:    journalctl --user -u voxtype -f"
echo ""
