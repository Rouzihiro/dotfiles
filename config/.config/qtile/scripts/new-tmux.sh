#!/bin/sh

SESSION="tmux-$(date +%H%M)"

tmux new-session -s "$SESSION"
