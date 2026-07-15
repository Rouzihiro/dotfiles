#!/bin/bash
set -euo pipefail
pacman -Syyu --noconfirm
pacman -S --needed --noconfirm pacman-contrib
paccache -rk1
paccache -ruk0
pacman -Qtdq | xargs pacman -Rns --noconfirm
journalctl --vacuum-time=7d
