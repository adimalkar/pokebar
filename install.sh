#!/usr/bin/env bash
#
# PokeBar - Universal Distro-Agnostic Installer
# Author: Aditya Malkar (https://github.com/adimalkar)
# License: MIT
#

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}   ⚡ Welcome to the PokeBar Installer ⚡  ${NC}"
echo -e "${BLUE}========================================${NC}"

# Directories
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}/.config/pokebar"
BIN_DIR="${HOME}/.local/bin"

mkdir -p "${TARGET_DIR}/scripts"
mkdir -p "${TARGET_DIR}/current"
mkdir -p "${BIN_DIR}"

echo -e "\n${BLUE}[1/5] Copying Pokémon sprite assets (all 151 Gen 1 Pokémon)...${NC}"
cp -r "${REPO_DIR}/assets" "${TARGET_DIR}/"

echo -e "${BLUE}[2/5] Setting up ultra-fast C frame cycler...${NC}"
cp "${REPO_DIR}/scripts/pokecycle.c" "${TARGET_DIR}/scripts/"
cp "${REPO_DIR}/scripts/pokecycle.sh" "${TARGET_DIR}/scripts/"
cp "${REPO_DIR}/scripts/pokebar-tray.py" "${TARGET_DIR}/scripts/"

if command -v gcc >/dev/null 2>&1; then
    echo "  -> Compiling pokecycle with gcc (-O3)..."
    gcc -O3 "${TARGET_DIR}/scripts/pokecycle.c" -o "${TARGET_DIR}/scripts/pokecycle"
elif command -v clang >/dev/null 2>&1; then
    echo "  -> Compiling pokecycle with clang (-O3)..."
    clang -O3 "${TARGET_DIR}/scripts/pokecycle.c" -o "${TARGET_DIR}/scripts/pokecycle"
else
    echo -e "  ${YELLOW}Notice: gcc/clang not found; falling back to POSIX shell cycler.${NC}"
    ln -sf "${TARGET_DIR}/scripts/pokecycle.sh" "${TARGET_DIR}/scripts/pokecycle"
fi
chmod +x "${TARGET_DIR}/scripts/pokecycle"*
chmod +x "${TARGET_DIR}/scripts/pokebar-tray.py"

echo -e "${BLUE}[3/5] Installing 'pokebar' CLI tool to ${BIN_DIR}/pokebar...${NC}"
install -m 755 "${REPO_DIR}/bin/pokebar" "${BIN_DIR}/pokebar"

echo -e "${BLUE}[4/5] Initializing default Pokémon (Pikachu Running)...${NC}"
"${BIN_DIR}/pokebar" set pikachu-run

echo -e "${BLUE}[5/5] Environment Integration Detection...${NC}"
if command -v waybar >/dev/null 2>&1; then
    echo -e "  ${GREEN}✓ Waybar detected!${NC}"
    echo -e "    Add the following module to your ~/.config/waybar/config (or UserModules):"
    echo -e "${YELLOW}
    \"image#pokemon\": {
        \"exec\": \"\$HOME/.config/pokebar/scripts/pokecycle\",
        \"size\": 24,
        \"interval\": 0.12,
        \"tooltip\": false,
        \"on-click\": \"pokebar interact\",
        \"on-click-right\": \"pokebar next\",
        \"on-click-middle\": \"pokebar random\"
    }
    ${NC}"
    echo -e "    And insert ${GREEN}\"image#pokemon\"${NC} in your ${GREEN}\"modules-left\"${NC} array."
fi

if command -v polybar >/dev/null 2>&1; then
    echo -e "  ${GREEN}✓ Polybar detected!${NC}"
    echo -e "    Add module snippet from ${TARGET_DIR}/configs/polybar/polybar.ini into your polybar config."
fi

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo -e "\n${YELLOW}Warning: ${BIN_DIR} is not in your current PATH.${NC}"
    echo "Add the following line to your ~/.bashrc or ~/.zshrc:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

echo -e "\n${GREEN}================================================${NC}"
echo -e "${GREEN}   🎉 PokeBar successfully installed!           ${NC}"
echo -e "${GREEN}================================================${NC}"
echo -e "Try these commands in your terminal:"
echo -e "  ${BLUE}pokebar set charizard${NC}    -> Activate Charizard"
echo -e "  ${BLUE}pokebar set gengar${NC}       -> Activate Gengar"
echo -e "  ${BLUE}pokebar random${NC}           -> Pick a random Gen 1 Pokémon"
echo -e "  ${BLUE}pokebar list${NC}             -> See all 151 Gen 1 Pokémon"
echo -e "  ${BLUE}pokebar set pikachu-run${NC}  -> Switch back to Running Pikachu"
echo -e "  ${BLUE}pokebar status${NC}           -> Check current active Pokémon"
