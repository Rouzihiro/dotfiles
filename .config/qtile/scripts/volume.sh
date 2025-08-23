#!/usr/bin/env bash

volume=`wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{v = $2; print (v*100)"%"}'`

echo $volume
