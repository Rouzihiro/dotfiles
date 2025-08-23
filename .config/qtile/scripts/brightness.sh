#!/usr/bin/env bash

brightnessctl | awk '/Current/{print substr($NF, 2, length($NF) -2)}'
