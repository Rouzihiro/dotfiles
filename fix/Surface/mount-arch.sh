#!/bin/bash

# Adjust these if your devices or subvol names differ
ROOT_DEV="/dev/nvme0n1p2"
EFI_DEV="/dev/nvme0n1p1"
MOUNTPOINT="/mnt"

echo "📦 Mounting Btrfs root subvolume (@)..."
mount -o subvol=@ "$ROOT_DEV" "$MOUNTPOINT" || exit 1

echo "🗂 Mounting EFI partition..."
mount "$EFI_DEV" "$MOUNTPOINT/boot" || exit 1

echo "🏠 Mounting Btrfs home subvolume (@home)..."
mount -o subvol=@home "$ROOT_DEV" "$MOUNTPOINT/home" || exit 1

echo "🔗 Binding system directories..."
for d in dev proc sys run; do
  mount --bind /$d "$MOUNTPOINT/$d" || exit 1
done

echo "✅ All mounts complete. Ready to chroot:"
echo "👉 arch-chroot $MOUNTPOINT"

