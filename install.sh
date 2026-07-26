#!/usr/bin/env bash
# Installs the custom "Hungarian (macOS-compatible, Apple Aluminium)" xkb
# keyboard layout on Arch Linux, and points to the Hyprland config needed
# to activate it.
#
# Usage: sudo ./install.sh

set -euo pipefail

XKB_HU_FILE="/usr/share/X11/xkb/symbols/hu"
BLOCK_FILE="$(dirname "$0")/xkb/hu-symbols-custom-block.txt"
MARKER='xkb_symbols "102_qwertz_comma_dead_mac_full"'

if [[ $EUID -ne 0 ]]; then
    echo "Run this script with sudo." >&2
    exit 1
fi

if grep -q "$MARKER" "$XKB_HU_FILE"; then
    echo "Custom variant already present in $XKB_HU_FILE -- skipping append."
else
    echo "Backing up $XKB_HU_FILE to ${XKB_HU_FILE}.bak.$(date +%s)"
    cp "$XKB_HU_FILE" "${XKB_HU_FILE}.bak.$(date +%s)"
    echo "" >> "$XKB_HU_FILE"
    cat "$BLOCK_FILE" >> "$XKB_HU_FILE"
    echo "Appended custom variant to $XKB_HU_FILE"
fi

echo ""
echo "Next steps:"
echo "1. In your Hyprland Lua input config, set:"
echo '     kb_layout  = "hu"'
echo '     kb_variant = "102_qwertz_comma_dead_mac_full"'
echo '     kb_model   = "applealu_iso"'
echo '     kb_options = "lv3:alt_switch"'
echo "   (see hypr/input.lua in this repo for a full example)"
echo ""
echo "2. Add the € (Ctrl+Alt+E) keybind from hypr/keybinds-snippet.lua"
echo "   to your Hyprland keybinds config."
echo ""
echo "3. Reload Hyprland: hyprctl reload"
echo "   (if the layout doesn't seem to update, toggle kb_options to a"
echo "   different value and back, then reload again, to force xkb to"
echo "   recompile the cached keymap)"
