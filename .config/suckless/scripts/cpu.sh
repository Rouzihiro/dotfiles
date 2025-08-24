#!/bin/bash

free -h | awk '/^Mem/ { printf "%.1f%%\n", ($3/$2)*100 }' | sed s/i//g
