#!/usr/bin/env bash

set -e

# =========================================
# Void Linux vdirsyncer + OAuth Setup
# =========================================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

VENV_DIR="$HOME/.venvs/vdirsyncer"
BIN_DIR="$HOME/.local/bin"

echo "========================================="
echo "  vdirsyncer Void Linux Installer"
echo "========================================="
echo ""

# -----------------------------------------
# Install pip
# -----------------------------------------

echo -e "${YELLOW}Installing python3-pip...${NC}"

sudo xbps-install -S python3-pip

echo -e "${GREEN}✓ python3-pip installed${NC}"


# -----------------------------------------
# Create venv
# -----------------------------------------

if [ -d "$VENV_DIR" ]; then
    echo -e "${YELLOW}Existing venv found:${NC}"
    echo "$VENV_DIR"
else
    echo -e "${YELLOW}Creating Python virtual environment...${NC}"

    mkdir -p "$(dirname "$VENV_DIR")"

    python3 -m venv "$VENV_DIR"

    echo -e "${GREEN}✓ venv created${NC}"
fi


# -----------------------------------------
# Install packages
# -----------------------------------------

echo -e "${YELLOW}Installing OAuth support...${NC}"

"$VENV_DIR/bin/pip" install --upgrade pip

"$VENV_DIR/bin/pip" install \
    aiohttp-oauthlib


echo -e "${GREEN}✓ Python packages installed${NC}"


# -----------------------------------------
# Create wrapper
# -----------------------------------------

mkdir -p "$BIN_DIR"

cat > "$BIN_DIR/vdirsyncer" <<EOF
#!/usr/bin/env bash
exec "$VENV_DIR/bin/vdirsyncer" "\$@"
EOF

chmod +x "$BIN_DIR/vdirsyncer"


echo -e "${GREEN}✓ vdirsyncer wrapper created${NC}"


# -----------------------------------------
# Create config folders
# -----------------------------------------

mkdir -p \
    "$HOME/.vdirsyncer" \
    "$HOME/.vdirsyncer/status" \
    "$HOME/.cache/vdirsyncer"


echo -e "${GREEN}✓ Configuration directories created${NC}"


# -----------------------------------------
# Verify
# -----------------------------------------

echo ""
echo "Checking installation..."
echo ""

"$VENV_DIR/bin/vdirsyncer" --version

"$VENV_DIR/bin/python" - <<EOF
import aiohttp_oauthlib
print("OAuth module OK")
EOF


echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}✓ vdirsyncer installation completed${NC}"
echo -e "${GREEN}=========================================${NC}"

echo ""
echo "Next steps:"
echo ""
echo "1) Configure:"
echo "   ~/.config/vdirsyncer/config"
echo ""
echo "2) Discover Google calendars:"
echo "   vdirsyncer discover"
echo ""
echo "3) Sync:"
echo "   vdirsyncer sync"
echo ""
echo "Make sure ~/.local/bin is in your PATH."
