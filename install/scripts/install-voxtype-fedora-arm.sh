#!/usr/bin/env bash
# install-voxtype.sh — Voxtype v0.7.5 aarch64 setup for Fedora + Sway
# Usage: bash install-voxtype.sh

set -euo pipefail

VOXTYPE_URL="https://github.com/peteonrails/voxtype/releases/download/v0.7.5/voxtype-0.7.5-linux-aarch64-cpu"
VOXTYPE_BIN="/usr/local/bin/voxtype"
CONFIG_DIR="$HOME/.config/voxtype"
CONFIG_FILE="$CONFIG_DIR/config.toml"

# ── colours ────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
ok()   { echo -e "${GREEN}  ✓${NC} $*"; }
warn() { echo -e "${YELLOW}  ⚠${NC} $*"; }
die()  { echo -e "${RED}  ✗ $*${NC}" >&2; exit 1; }

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Voxtype v0.7.5 — Fedora aarch64 setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── 1. dependencies ────────────────────────────────────────────────────────
echo "▸ Installing dependencies..."
sudo dnf install -y wtype wl-clipboard libnotify pipewire-alsa playerctl \
  || warn "Some optional deps may have failed — continuing"
ok "Dependencies installed"

# ── 2. download binary ─────────────────────────────────────────────────────
echo ""
echo "▸ Downloading voxtype binary..."
curl -L --progress-bar "$VOXTYPE_URL" -o /tmp/voxtype
chmod 755 /tmp/voxtype
sudo mv /tmp/voxtype "$VOXTYPE_BIN"
ok "Binary installed to $VOXTYPE_BIN"
voxtype --version

# ── 3. first-run setup (downloads whisper model) ───────────────────────────
echo ""
echo "▸ Running voxtype setup (downloads Whisper model — may take a moment)..."
voxtype setup --download
ok "Model downloaded"

# ── 4. disable built-in hotkey (Sway handles keybinds) ────────────────────
echo ""
echo "▸ Configuring for Sway..."
mkdir -p "$CONFIG_DIR"

# Patch or create config.toml
if [[ -f "$CONFIG_FILE" ]]; then
  # Remove any existing [hotkey] block so we can write a clean one
  # (simple approach: append — voxtype uses last-wins for duplicate keys)
  grep -q '\[hotkey\]' "$CONFIG_FILE" \
    && warn "[hotkey] block already exists in config — skipping patch" \
    || {
      cat >> "$CONFIG_FILE" << 'EOF'

[hotkey]
enabled = false

EOF
      ok "Hotkey disabled in config"
    }
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

# state_file needed for toggle mode
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
