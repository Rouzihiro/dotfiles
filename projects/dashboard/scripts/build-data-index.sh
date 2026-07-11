#!/bin/sh

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DASHBOARD_DIR="$(dirname "$SCRIPT_DIR")"


cd "$DASHBOARD_DIR" || exit 1


printf "[\n" > data/index.json


first=true


for file in data/*.json; do

    name=$(basename "$file")


    [ "$name" = "index.json" ] && continue


    if $first; then
        first=false
    else
        printf ",\n" >> data/index.json
    fi


    printf "    \"%s\"" "$name" >> data/index.json


done


printf "\n]\n" >> data/index.json
