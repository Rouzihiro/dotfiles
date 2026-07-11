#!/bin/sh

DATA="$HOME/dashboard/data/git.json"

REPO="$HOME/dotfiles"


if [ -d "$REPO/.git" ]; then

    cd "$REPO" || exit


    BRANCH=$(git branch --show-current)


    CHANGES=$(git status --porcelain)


    if [ -z "$CHANGES" ]; then
        STATUS="clean"
    else
        STATUS="modified"
    fi


else

    BRANCH="none"
    STATUS="missing"

fi



cat > "$DATA" <<EOF
{
    "branch": "$BRANCH",
    "status": "$STATUS"
}
EOF
