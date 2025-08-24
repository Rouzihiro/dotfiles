#!/bin/bash

playing=$(playerctl metadata --format "{{ title }}" 2>&1)

if [[ "$playing" != No* ]]; then
  echo "$playing"
fi

