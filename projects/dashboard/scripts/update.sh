#!/bin/sh

cd "$HOME/dashboard" || exit 1


while true; do

    ./scripts/system.sh
    ./scripts/network.sh
    ./scripts/git.sh
    ./scripts/hardware.sh
    ./scripts/services.sh
 		./scripts/git-tree.sh

    sleep 5

done
