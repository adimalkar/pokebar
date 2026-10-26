# ⚡ PokeBar

<p align="center">
  <img src="assets/demo/pikachu-runner.gif" alt="Running Pikachu" width="90"/>
</p>

<p align="center">
  <strong>Animated Gen 1 Pokémon status bar module & desktop overlay for Waybar, Polybar, and any Linux Desktop Environment or Window Manager.</strong>
</p>

<p align="center">
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"/></a>
  <a href="https://www.kernel.org/"><img src="https://img.shields.io/badge/Platform-Linux-blue.svg" alt="Platform: Linux"/></a>
  <a href="#"><img src="https://img.shields.io/badge/Compatible-Waybar%20%7C%20Polybar%20%7C%20Any%20DE-brightgreen.svg" alt="Compatible"/></a>
  <a href="#"><img src="https://img.shields.io/badge/Pok%C3%A9mon-Gen%201%20(151)-red.svg" alt="Gen 1"/></a>
  <a href="#"><img src="https://img.shields.io/badge/CPU%20Overhead-%3C0.3ms%20per%20tick-orange.svg" alt="CPU"/></a>
</p>

---

## 🎬 Live Preview

### Waybar in Action (Hyprland)

<p align="center">
  <img src="assets/demo/waybar-demo.gif" alt="PokeBar Live Waybar Animation" width="680"/>
</p>

<p align="center">
  <em>Live capture of the running Pikachu animation in the leftmost section of Waybar on Hyprland.</em>
</p>

---

## 💡 Why PokeBar? (Trust & Performance)

Traditional GIF status bar implementations fork heavy shell scripts or parse image headers every 100 milliseconds, leading to:
- ❌ High continuous CPU wakeups (3–8% CPU usage).
- ❌ Constant SSD/NVMe disk I/O wearing down laptop storage.
- ❌ Clunky dependencies or unvetted binary daemons.

**PokeBar is built differently:**
- 🛡️ **Transparent & 100% Open-Source**: Pure readable POSIX C ([`pokecycle.c`](scripts/pokecycle.c)) and clean Python 3 ([`pokebar`](bin/pokebar)). Zero telemetry, no obfuscated binary blobs, no root/sudo privileges required.
- ⚡ **Near-Zero CPU Usage (~0.2 ms per tick)**: A tiny compiled C helper (`pokecycle`) cycles animation frames with virtually undetectable CPU footprint.
- 💾 **Zero Disk Wear**: Uses `/dev/shm` (Linux in-memory RAM `tmpfs`) for frame indices. Your physical drive takes zero continuous write wear.
- 🔄 **Hot-Swapping**: Switch Pokémon instantly (`pokebar set charizard`, `pokebar random`, `pokebar next`) without editing config files or reloading Waybar/Polybar.
- 🐧 **Universal Distro Adaptability**: Works across Arch, EndeavourOS, Debian, Ubuntu, Fedora, openSUSE, Void, NixOS, Gentoo, and Alpine.
- 🖥️ **Any DE or WM**: Native support for Waybar and Polybar, plus a standalone floating pet / tray overlay for GNOME, KDE Plasma, XFCE, Cinnamon, and MATE.

---

## ✨ Features

- 🎮 **All 151 Gen 1 Pokémon**: Bulbasaur (#001) to Mew (#151) included in transparent animated sprite format.
- ⚡ **Dedicated Running Pikachu**: The iconic 4-frame fast-running animation with transparent background.
- 🖱️ **Interactive Click Events**:
  - **Left-click**: Plays Pokémon cry/reaction dialogue via `notify-send`.
  - **Right-click**: Cycles to the next Pokémon in the Pokédex.
  - **Middle-click**: Picks a random Pokémon on the fly.
- 🎛️ **CLI Control**: Rich command-line tool `pokebar` to manage, preview, list, and switch Pokémon.

---

## 🚀 Quick Start (Automated Installation)

Clone the repository and run the installer:

```bash
git clone https://github.com/adimalkar/pokebar.git
cd pokebar
./install.sh
```

### What `install.sh` Does:
1. Copies all 151 Pokémon sprite assets to `~/.config/pokebar/assets/`.
2. Compiles the ultra-fast C frame cycler (`scripts/pokecycle.c`) using `gcc -O3` (or `clang`). Falls back to a POSIX shell script if no compiler is available.
3. Installs the `pokebar` CLI tool to `~/.local/bin/pokebar`.
4. Initializes the default running Pikachu animation.
5. Detects your bar (Waybar / Polybar) and displays the exact integration snippet.

---

## 📖 Detailed Setup Guide

### 1. Waybar (Hyprland, Sway, River, etc.)

#### Step 1: Define the Module
In your Waybar configuration file (typically `~/.config/waybar/config` or `~/.config/waybar/config.jsonc`, or your extra modules file like `UserModules`):

```jsonc
"image#pokemon": {
    "exec": "$HOME/.config/pokebar/scripts/pokecycle",
    "size": 24,
    "interval": 0.12,
    "tooltip": false,
    "on-click": "pokebar interact",
    "on-click-right": "pokebar next",
    "on-click-middle": "pokebar random"
}
```

*Note: You can adjust `"size"` (e.g. `20`, `24`, `28`, `32`) to match your bar height, and `"interval"` (`0.08` for faster, `0.12` for normal, `0.16` for relaxed pace).*

#### Step 2: Add to Your Bar Layout
Insert `"image#pokemon"` into your `"modules-left"`, `"modules-center"`, or `"modules-right"` array. For the leftmost edge of your bar:

```jsonc
"modules-left": [
    "image#pokemon",
    // ... your other modules
],
```

#### Step 3: Add CSS Spacing (Optional but Recommended)
In your `~/.config/waybar/style.css`:

```css
#image.pokemon {
    margin-left: 6px;
    margin-right: 6px;
    padding: 0 2px;
}
```

#### Step 4: Reload Waybar
```bash
killall -SIGUSR2 waybar
# or restart waybar:
killall waybar && waybar &
```

---

### 2. Polybar (i3, bspwm, AwesomeWM, XFCE, etc.)

#### Step 1: Define the Module
In your `~/.config/polybar/config.ini`:

```ini
[module/pokemon]
type = custom/script
exec = $HOME/.config/pokebar/scripts/pokecycle
interval = 0.12
format = <label>
click-left = pokebar interact
click-right = pokebar next
click-middle = pokebar random
```

#### Step 2: Add to Bar
Add `pokemon` to your modules list:
```ini
modules-left = pokemon ...
```

#### Step 3: Restart Polybar
```bash
polybar-msg cmd restart
```

---

### 3. Standalone Desktop Pet / System Tray (GNOME, KDE, XFCE, etc.)

If you use a desktop environment that doesn't use Waybar or Polybar, you can run the standalone companion:

```bash
# Launch a transparent floating Pokémon on your desktop
~/.config/pokebar/scripts/pokebar-tray.py --size 32 --speed 100 --x 20 --y 10 &
```

- **Options**:
  - `--size <px>`: Sprite size in pixels (default: `32`).
  - `--speed <ms>`: Frame delay in milliseconds (default: `100`).
  - `--x <px>`: Horizontal desktop position.
  - `--y <px>`: Vertical desktop position.

To make it start automatically on login, add it to your DE's Startup Applications or window manager autostart file (`~/.config/hypr/hyprland.conf`, `~/.config/i3/config`, `~/.xprofile`, etc.):
```bash
exec = ~/.config/pokebar/scripts/pokebar-tray.py &
```

---

## 🕹️ CLI Usage & Commands

Once installed, use the `pokebar` command in your terminal:

```bash
# Set any Pokémon by name
pokebar set charizard
pokebar set gengar
pokebar set bulbasaur
pokebar set mewtwo
pokebar set eevee
pokebar set snorlax

# Set by Pokédex number (1 to 151)
pokebar set 6     # Charizard
pokebar set 25    # Pikachu
pokebar set 94    # Gengar
pokebar set 150   # Mewtwo

# Switch back to the fast running Pikachu
pokebar set pikachu-run

# Pick a random Gen 1 Pokémon
pokebar random

# Cycle sequentially
pokebar next
pokebar prev

# List all 151 available Gen 1 Pokémon
pokebar list

# Check current active Pokémon & frame stats
pokebar status

# Trigger dialogue/reaction
pokebar interact
```

---

## 🔧 Manual Installation (Alternative)

If you prefer to configure everything manually without running `install.sh`:

1. Create target directories:
   ```bash
   mkdir -p ~/.config/pokebar/{scripts,current} ~/.local/bin
   ```
2. Copy assets:
   ```bash
   cp -r assets ~/.config/pokebar/
   ```
3. Compile the frame cycler:
   ```bash
   gcc -O3 scripts/pokecycle.c -o ~/.config/pokebar/scripts/pokecycle
   chmod +x ~/.config/pokebar/scripts/pokecycle
   ```
4. Link the CLI tool:
   ```bash
   install -m 755 bin/pokebar ~/.local/bin/pokebar
   ```
5. Set your starting Pokémon:
   ```bash
   ~/.local/bin/pokebar set pikachu-run
   ```

---

## 🛠️ Troubleshooting & FAQ

### 1. `pokebar: command not found`
Ensure `~/.local/bin` is in your `PATH`. Add this to your `~/.bashrc` or `~/.zshrc`:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

### 2. Waybar doesn't display the Pokémon
- Verify that `~/.config/pokebar/current/frame_0.png` exists by running `pokebar status`.
- Test the cycler script directly in your terminal:
  ```bash
  ~/.config/pokebar/scripts/pokecycle
  ```
  It should output the path to the current frame image.
- Ensure your Waybar configuration file includes the `"image#pokemon"` module in `"modules-left"`, `"modules-center"`, or `"modules-right"`.
- If using JaKooLit or modular Waybar configs, make sure the module is added inside your active layout file or `UserModules`.

### 3. Missing dependencies for custom frame extraction
`pokebar` automatically uses Python Pillow (`PIL`) if available, and gracefully falls back to `magick` / `convert` or `ffmpeg`. If you receive an extraction error, install any one of them:
- **Arch/EndeavourOS**: `sudo pacman -S python-pillow` or `imagemagick`
- **Debian/Ubuntu**: `sudo apt install python3-pil` or `imagemagick`
- **Fedora**: `sudo dnf install python3-pillow` or `ImageMagick`

---

## 🗑️ Uninstallation

To completely remove PokeBar:

```bash
cd pokebar
./uninstall.sh
```

Then remove `"image#pokemon"` from your bar config and reload your bar.

---

## 📄 License & Credits

- Code released under the [MIT License](LICENSE).
- Animated Pokémon sprite assets courtesy of [PokeAPI](https://github.com/PokeAPI/sprites) & The Pokémon Company.
- Built by [Aditya Malkar](https://github.com/adimalkar).
