#!/bin/bash
set -euo pipefail
yay -Syu --needed --noconfirm
yay -Scc --noconfirm
rm -rf $HOME/.cache/yay
rm -rf $HOME/.local/share/Trash/*
