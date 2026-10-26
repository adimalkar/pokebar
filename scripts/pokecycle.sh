#!/usr/bin/env bash
# pokecycle.sh - POSIX shell fallback frame cycler for PokeBar
# Author: Aditya Malkar (https://github.com/adimalkar)
# License: MIT

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$SCRIPT_DIR/pokecycle"

# Use compiled C binary if present for peak performance (~0.2ms)
if [ -x "$BIN" ]; then
    exec "$BIN"
fi

CURRENT_DIR="${POKEBAR_CURRENT_DIR:-$HOME/.config/pokebar/current}"
STATE_FILE="/dev/shm/pokebar_idx"
[ ! -d "/dev/shm" ] && STATE_FILE="/tmp/pokebar_idx"

TOTAL=4
if [ -f "$CURRENT_DIR/meta.txt" ]; then
    TOTAL=$(cat "$CURRENT_DIR/meta.txt" 2>/dev/null)
    [ -z "$TOTAL" ] && TOTAL=4
fi

IDX=0
[ -f "$STATE_FILE" ] && IDX=$(cat "$STATE_FILE" 2>/dev/null)
[ -z "$IDX" ] && IDX=0

echo "$CURRENT_DIR/frame_${IDX}.png"

NEXT=$(( (IDX + 1) % TOTAL ))
echo "$NEXT" > "$STATE_FILE"
