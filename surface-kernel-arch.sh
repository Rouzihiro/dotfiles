# Optional: remove default firmware
pacman -R linux-firmware

# Add surface repo if not already
pacman-key --recv-key 56C464BAAC421453 --keyserver hkps://keyserver.ubuntu.com
pacman-key --lsign-key 56C464BAAC421453
echo -e "\n[linux-surface]\nServer = https://pkg.surfacelinux.com/arch/" >> /etc/pacman.conf

# Install Marvell-specific firmware and Surface kernel
pacman -Syu linux-firmware-marvell linux-surface linux-surface-headers iptsd
systemctl enable iptsd iwd

