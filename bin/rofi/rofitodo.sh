#!/bin/bash

TODO_FILE=~/Documents/notes

if [[ ! -a "${TODO_FILE}" ]]; then
    touch "${TODO_FILE}"
fi

function add_todo() {
    echo -e "$*" >> "${TODO_FILE}"
}

function remove_todo() {
    if [[ ! -z "$DONE_FILE" ]]; then
        echo "${*}" >> "${DONE_FILE}"
    fi
    sed -i "/^${*}$/d" "${TODO_FILE}"
}

function get_todos() {
    cat "${TODO_FILE}"
}

if [ -z "$@" ]; then
    get_todos
else
    LINE_UNESCAPED="${@}"
    # If line starts with "-", remove it
    if [[ $LINE_UNESCAPED == -* ]]; then
        ITEM_TO_REMOVE=$(echo "$LINE_UNESCAPED" | sed 's/^-//')
        remove_todo "$ITEM_TO_REMOVE"
    # If line starts with "+", add it
    elif [[ $LINE_UNESCAPED == +* ]]; then
        ITEM_TO_ADD=$(echo "$LINE_UNESCAPED" | sed 's/^+//')
        add_todo "$ITEM_TO_ADD"
    fi
    get_todos
fi
