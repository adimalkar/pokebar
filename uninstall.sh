#!/usr/bin/env bash
#
# PokeBar - Uninstaller
# Author: Aditya Malkar (https://github.com/adimalkar)
# License: MIT
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${RED}Uninstalling PokeBar...${NC}"

rm -rf "${HOME}/.config/pokebar"
rm -f "${HOME}/.local/bin/pokebar"
rm -f "/dev/shm/pokebar_idx" "/tmp/pokebar_idx"

echo -e "${GREEN}PokeBar has been completely removed from your system.${NC}"
echo "Remember to remove 'image#pokemon' from your Waybar/Polybar config if you added it."
