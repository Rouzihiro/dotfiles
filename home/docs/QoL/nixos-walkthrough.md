# NixOS Installation Walkthrough

## Overview
We'll setup NixOS on /dev/sda with:
- 500MB boot partition (FAT32)
- 16GB swap partition
- Remaining space as Btrfs root

## 1. Wipe Disk
Run:
fdisk /dev/sda
Then:
- Press 'd' to delete partitions (repeat for all)
- Press 'w' to write changes

## 2. Create Partition Table
Run:
fdisk /dev/sda
Then:
- Press 'g' for new GPT table

## 3. Create Boot Partition
In fdisk:
- Press 'n' (new partition)
- Press Enter (default number 1)
- Press Enter (default first sector)
- Type '+500M' for size
- Press 't' then '1' for EFI type

## 4. Create Swap Partition
In fdisk:
- Press 'n'
- Press Enter (default number 2)
- Press Enter (default first sector)
- Type '+16G' for size
- Press 't', '2', then '19' for swap type

## 5. Create Root Partition
In fdisk:
- Press 'n'
- Press Enter 3 times (use defaults)
- Press 'w' to write

## 6. Format Partitions
Run these commands:
mkfs.fat -F 32 -n boot /dev/sda1
mkswap -L swap /dev/sda2
swapon /dev/sda2
mkfs.btrfs -L root /dev/sda3

## 7. Mount Partitions
Run these commands:
mount /dev/sda3 /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
umount /mnt
mount -o subvol=root /dev/sda3 /mnt
mkdir -p /mnt/{boot,home,nix}
mount /dev/sda1 /mnt/boot
mount -o subvol=home /dev/sda3 /mnt/home
mount -o subvol=nix /dev/sda3 /mnt/nix

## 8. Generate Config
Run:
nixos-generate-config --root /mnt

## 9. Edit Configuration
Edit the config:
nano /mnt/etc/nixos/configuration.nix

## 10. Install System
Run:
nixos-install
Set root password when prompted

## 11. Reboot
exit
reboot

## Post-Install Setup
After reboot:

1. Clone your dotfiles:
nix-shell -p git
git clone https://github.com/Rouzihiro/dotfiles.git ~/dotfiles

2. Apply flake configuration:
sudo nixos-rebuild switch --flake ~/dotfiles#HOSTNAME
