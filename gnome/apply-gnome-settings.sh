#!/usr/bin/env bash
# Applies the GNOME-side counterpart of the Hyprland input.lua config:
#   - selects the custom hu(102_qwertz_comma_dead_mac_full) xkb variant
#   - sets lv3:alt_switch so both Alt keys act as Option
#   - swaps Ctrl <-> Super (Cmd) so Mac muscle memory (Cmd+C/V/...) lands
#     on the physical key GNOME treats as Ctrl
#   - registers the Ctrl+Alt+E -> € custom shortcut (X11: xdotool,
#     Wayland: wtype)
#
# Must be run as the *regular desktop user* (not root/sudo), since it
# writes to that user's dconf/GSettings session.
#
# Usage: ./apply-gnome-settings.sh

set -euo pipefail

if [[ $EUID -eq 0 ]]; then
    echo "Run this as your normal desktop user, not root/sudo." >&2
    exit 1
fi

if ! command -v gsettings >/dev/null 2>&1; then
    echo "gsettings not found -- is this a GNOME session?" >&2
    exit 1
fi

echo "Setting input source to hu+102_qwertz_comma_dead_mac_full..."
gsettings set org.gnome.desktop.input-sources sources \
    "[('xkb', 'hu+102_qwertz_comma_dead_mac_full')]"

echo "Setting xkb-options (lv3:alt_switch + Ctrl/Super swap)..."
gsettings set org.gnome.desktop.input-sources xkb-options \
    "['lv3:alt_switch', 'ctrl:swap_lwin_lctl', 'ctrl:swap_rwin_rctl']"

echo "Registering Ctrl+Alt+E -> € custom keybinding..."
KB_BASE="org.gnome.settings-daemon.plugins.media-keys"
KB_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-mac-euro/"

existing=$(gsettings get "$KB_BASE" custom-keybindings)
if [[ "$existing" != *"custom-mac-euro"* ]]; then
    if [[ "$existing" == "@as []" || "$existing" == "[]" ]]; then
        new_list="['$KB_PATH']"
    else
        new_list="${existing%]}, '$KB_PATH']"
    fi
    gsettings set "$KB_BASE" custom-keybindings "$new_list"
fi

if [[ "${XDG_SESSION_TYPE:-}" == "wayland" ]]; then
    TYPE_CMD="wtype €"
else
    TYPE_CMD="xdotool key U20AC"
fi

gsettings set "${KB_BASE}.custom-keybinding:${KB_PATH}" name "Mac euro sign"
gsettings set "${KB_BASE}.custom-keybinding:${KB_PATH}" command "$TYPE_CMD"
gsettings set "${KB_BASE}.custom-keybinding:${KB_PATH}" binding "<Ctrl><Alt>e"

echo ""
echo "Done. You may need to log out/in (or restart gnome-shell with"
echo "Alt+F2, r on X11) for the input source change to fully apply."
