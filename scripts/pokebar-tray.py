#!/usr/bin/env python3
"""
pokebar-tray.py - Standalone Desktop Pet & System Tray companion for any DE/WM
Author: Aditya Malkar (https://github.com/adimalkar)
License: MIT

Works on GNOME, KDE, XFCE, i3, Sway, Hyprland, Cinnamon, MATE, etc.
Can run as a floating desktop pet or in the system tray.
"""

import os
import sys
import glob
import subprocess
import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, Gdk, GLib, GdkPixbuf

HOME = os.path.expanduser("~")
POKEBAR_DIR = os.environ.get("POKEBAR_DIR", os.path.join(HOME, ".config", "pokebar"))
CURRENT_DIR = os.path.join(POKEBAR_DIR, "current")

class PokeBuddyWindow(Gtk.Window):
    def __init__(self, size=32, speed=100, x_pos=10, y_pos=10):
        super().__init__(Gtk.WindowType.TOPLEVEL)
        self.size = size
        self.speed = speed
        self.idx = 0
        self.frames = []

        self.set_title("PokeBar Desktop Pet")
        self.set_decorated(False)
        self.set_keep_above(True)
        self.set_skip_taskbar_hint(True)
        self.set_skip_pager_hint(True)
        self.set_app_paintable(True)

        # Make background transparent
        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual and screen.is_composited():
            self.set_visual(visual)

        self.connect("draw", self.on_draw)
        self.connect("button-press-event", self.on_click)

        # Image widget
        self.image = Gtk.Image()
        self.add(self.image)

        self.load_frames()
        self.move(x_pos, y_pos)
        self.show_all()

        GLib.timeout_add(self.speed, self.tick)

    def load_frames(self):
        pattern = os.path.join(CURRENT_DIR, "frame_*.png")
        files = sorted(glob.glob(pattern))
        self.frames = []
        for f in files:
            try:
                pb = GdkPixbuf.Pixbuf.new_from_file_at_scale(f, self.size, self.size, True)
                self.frames.append(pb)
            except Exception:
                pass
        if not self.frames:
            # Fallback
            self.frames = [GdkPixbuf.Pixbuf.new(GdkPixbuf.Colorspace.RGB, True, 8, self.size, self.size)]

    def tick(self):
        if self.frames:
            self.idx = (self.idx + 1) % len(self.frames)
            self.image.set_from_pixbuf(self.frames[self.idx])
        return True

    def on_draw(self, widget, cr):
        cr.set_source_rgba(0, 0, 0, 0)
        cr.set_operator(0) # CAIRO_OPERATOR_CLEAR
        cr.paint()
        cr.set_operator(2) # CAIRO_OPERATOR_OVER
        return False

    def on_click(self, widget, event):
        # Trigger interaction
        pokebar_bin = shutil.which("pokebar") or os.path.join(HOME, ".local", "bin", "pokebar")
        if os.path.exists(pokebar_bin):
            subprocess.run([pokebar_bin, "interact"])
        return True

def main():
    import argparse
    import shutil
    parser = argparse.ArgumentParser(description="PokeBar Standalone Desktop Companion")
    parser.add_argument("--size", type=int, default=32, help="Icon size in pixels (default: 32)")
    parser.add_argument("--speed", type=int, default=100, help="Animation tick in ms (default: 100)")
    parser.add_argument("--x", type=int, default=12, help="Initial X position")
    parser.add_argument("--y", type=int, default=6, help="Initial Y position")
    args = parser.parse_args()

    app = PokeBuddyWindow(size=args.size, speed=args.speed, x_pos=args.x, y_pos=args.y)
    Gtk.main()

if __name__ == "__main__":
    main()
