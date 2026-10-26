# ⚡ PokeBar

> **Animated Gen 1 Pokémon status bar module & desktop overlay for Waybar, Polybar, and any Linux Desktop Environment or Window Manager.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-blue.svg)](https://www.kernel.org/)
[![Compatible with: Waybar & Polybar](https://img.shields.io/badge/Compatible-Waybar%20%7C%20Polybar%20%7C%20Any%20DE-brightgreen.svg)]()
[![Pokémon: Gen 1 (151)](https://img.shields.io/badge/Pok%C3%A9mon-Gen%201%20(151)-red.svg)]()

Bring your status bar or desktop to life with an ultra-lightweight, animated Pokémon companion. Switch between any of the **original 151 Gen 1 Pokémon** on the fly, or enjoy the iconic **fast-running Pikachu** animation.

---

## ✨ Features

- 🎮 **All 151 Gen 1 Pokémon**: Bulbasaur to Mew included out-of-the-box in transparent animated sprite form.
- ⚡ **Special Running Pikachu**: Includes the smooth, high-framerate 4-frame running Pikachu sprite cycle.
- 🏎️ **Near-Zero CPU Overhead**: Powered by a compiled C frame cycler (`pokecycle.c`) executing in **~0.2 ms** using `/dev/shm` (in-memory shared RAM, **zero disk I/O**).
- 🔄 **Hot-Swapping Without Bar Restarts**: Switch your active Pokémon dynamically via CLI (`pokebar set gengar`, `pokebar random`) without editing configs or restarting Waybar/Polybar.
- 🖱️ **Interactive**: Left-click for Pokémon dialogue/cries via `notify-send`, right-click to cycle to the next Pokémon, middle-click for a random Pokémon.
- 🐧 **Universal Distro & DE/WM Compatibility**: Works on Arch, EndeavourOS, Debian, Ubuntu, Fedora, openSUSE, Void, NixOS, etc.
  - Native support for **Waybar** (Hyprland, Sway, river).
  - Native support for **Polybar** (i3, bspwm, AwesomeWM, openbox).
  - Standalone floating desktop pet & tray mode for **GNOME, KDE Plasma, XFCE, Cinnamon, and MATE**.

---

## 🚀 Quick Start

### 1. Clone & Install
```bash
git clone https://github.com/adimalkar/pokebar.git
cd pokebar
./install.sh
```

The installer will:
1. Copy all 151 Pokémon sprite assets to `~/.config/pokebar/assets/`.
2. Compile the high-performance in-memory C cycler with `gcc -O3` (with a POSIX shell fallback).
3. Symlink the `pokebar` CLI into `~/.local/bin/pokebar`.
4. Initialize the default running Pikachu animation.

---

## ⚙️ Bar Integration

### 1. Waybar (Hyprland / Sway / wlroots)

In your `~/.config/waybar/config` (or module config):

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

Add `"image#pokemon"` to your `modules-left` (or `modules-center` / `modules-right`):

```jsonc
"modules-left": [
    "image#pokemon",
    // ... other modules
]
```

In your `~/.config/waybar/style.css`:
```css
#image.pokemon {
    margin-left: 6px;
    margin-right: 6px;
}
```

Reload Waybar (`killall -SIGUSR2 waybar` or restart).

---

### 2. Polybar (i3 / bspwm / X11)

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

---

### 3. Standalone Desktop Pet (GNOME, KDE Plasma, XFCE, etc.)

If you don't use Waybar or Polybar, run the standalone floating companion window:

```bash
# Launch a transparent floating pet on your desktop
~/.config/pokebar/scripts/pokebar-tray.py --size 32 --speed 100 --x 20 --y 10 &
```

---

## 🕹️ CLI Usage

```bash
# Set any Pokémon by name
pokebar set charizard
pokebar set gengar
pokebar set mewtwo
pokebar set eevee

# Set by Pokédex number (1 - 151)
pokebar set 6     # Charizard
pokebar set 25    # Pikachu
pokebar set 94    # Gengar
pokebar set 150   # Mewtwo

# Switch back to the fast running Pikachu
pokebar set pikachu-run

# Pick a random Gen 1 Pokémon
pokebar random

# Cycle through Pokémon
pokebar next
pokebar prev

# List all 151 Gen 1 Pokémon
pokebar list

# Check current active Pokémon
pokebar status

# Trigger dialogue interaction
pokebar interact
```

---

## 🏗️ Architecture: How It Works

Traditional GIF status bar implementations fork heavy shell scripts or parse images on every tick, causing 3–8% sustained CPU load and constant disk writes.

**PokeBar takes a different approach:**
1. When you select a Pokémon (`pokebar set <name>`), its frames are decoded once into `~/.config/pokebar/current/`.
2. The compiled binary `pokecycle` runs in user memory and stores the current frame state in `/dev/shm` (Linux tmpfs shared RAM).
3. Each animation tick executes in **under 0.3 ms** with zero disk I/O, keeping your CPU cool and battery intact.

```
[ User CLI / Click ] ──> pokebar set <name> ──> Decodes frames to ~/.config/pokebar/current/
                                                            │
[ Waybar / Polybar ] ──> calls pokecycle (~0.2ms) <─────────┘
                                   │
                           Reads frame index from /dev/shm/pokebar_idx
                           Returns path to stdout: frame_X.png
```

---

## 🗑️ Uninstallation

```bash
cd pokebar
./uninstall.sh
```

---

## 📄 License & Credits

- Code released under the [MIT License](LICENSE).
- Animated sprite data courtesy of [PokeAPI](https://github.com/PokeAPI/sprites) & The Pokémon Company.
