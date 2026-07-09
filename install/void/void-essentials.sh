#!/bin/bash
# Void Linux post-install: network + seat + graphics bootstrap

set -e

echo "==> GPU driver selection"
echo "Detected GPU info (for reference):"
lspci -k | grep -A 3 -i vga || echo "  (lspci not available or no VGA device found)"
echo ""
echo "Select GPU type:"
echo "  1) Intel"
echo "  2) AMD"
echo "  3) Nvidia (nouveau/open-source)"
echo "  4) Skip GPU driver install (already configured / other)"
read -rp "Enter choice [1-4]: " gpu_choice

case "$gpu_choice" in
  1)
    GPU_PKGS="mesa-dri libglvnd mesa-vulkan-intel linux-firmware-intel"
    ;;
  2)
    GPU_PKGS="mesa-dri libglvnd mesa-vulkan-radeon linux-firmware-amd"
    ;;
  3)
    GPU_PKGS="mesa-dri libglvnd mesa-vulkan-nouveau"
    ;;
  4)
    GPU_PKGS=""
    ;;
  *)
    echo "Invalid choice, skipping GPU package install."
    GPU_PKGS=""
    ;;
esac

echo "==> Installing packages"
sudo xbps-install -Sy \
  NetworkManager dbus elogind polkitd \
  $GPU_PKGS

echo "==> Linking runit services (skip if already linked)"
for svc in dbus elogind polkitd NetworkManager; do
  if [ ! -e /var/service/$svc ]; then
    sudo ln -s /etc/sv/$svc /var/service/$svc
  else
    echo "  $svc already linked"
  fi
done

echo "==> Forcing runsvdir to pick up new services"
sudo pkill -HUP runsvdir
sleep 2

echo "==> Service status"
sv status dbus elogind polkitd NetworkManager

echo "==> Wheel group check (needed for polkit + NM permissions)"
if ! groups | grep -q wheel; then
  echo "  Adding $USER to wheel group — log out/in required after this"
  sudo usermod -aG wheel $USER
fi

echo "==> Fallback DNS (only kicks in if NM doesn't push its own)"
if [ ! -s /etc/resolv.conf ]; then
  echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf
fi

echo "==> Done. Reboot recommended for GPU driver changes to take effect fully."
