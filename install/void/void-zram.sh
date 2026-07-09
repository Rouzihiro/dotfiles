#!/bin/bash
# Void Linux zram bootstrap
# Enables compressed RAM swap using zramen

set -e

echo "==> Installing zramen"

sudo xbps-install -Sy zramen

echo "==> Configuring zram"

sudo tee /etc/sv/zramen/conf > /dev/null <<'EOF'
export ZRAM_COMP_ALGORITHM=zstd
export ZRAM_PRIORITY=100
export ZRAM_SIZE=4096
export ZRAM_MAX_SIZE=4096
export ZRAM_STREAMS=0
export ZRAMEN_SWAPON_DISCARD=both
export ZRAMEN_QUIET=0
EOF

echo "==> Enabling zramen service"

if [ ! -e /var/service/zramen ]; then
    sudo ln -s /etc/sv/zramen /var/service/zramen
else
    echo "  zramen already linked"
fi

echo "==> Restarting zramen"

sudo sv restart zramen || sudo sv start zramen

echo "==> Setting swappiness"

sudo mkdir -p /etc/sysctl.d

echo "vm.swappiness=100" | sudo tee /etc/sysctl.d/99-swappiness.conf > /dev/null

sudo sysctl --system > /dev/null

echo "==> Verifying zram"

echo ""
swapon --show
echo ""

zramctl || true

echo ""
echo "==> Done. zram is active."
