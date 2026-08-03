#!/usr/bin/env bash
# Fills in the macOS Finder keyboard shortcuts (see
# https://support.apple.com/en-us/102650) that don't already come for
# free from the Ctrl<->Super (Cmd) swap applied by apply-gnome-settings.sh.
#
# Many Finder shortcuts (Cmd-D, Cmd-N, Cmd-T, Cmd-F, Cmd-R, Cmd-1/2,
# Cmd-[ / Cmd-], Cmd-Up/Down, Shift-Cmd-N...) already work automatically
# once Ctrl/Cmd are swapped, because GNOME Files (Nautilus) uses the same
# Ctrl+letter mnemonics that Finder uses with Cmd. This script adds
# custom global keybindings for the folder-navigation and
# trash/Mission-Control-style shortcuts that have no built-in GNOME
# equivalent. See ../README.md for the full mapping table, including
# shortcuts that have no Linux equivalent (AirDrop, Fn-row shortcuts,
# Mac "alias" files, etc.) and are intentionally skipped.
#
# Must be run as the *regular desktop user* (not root/sudo), after
# apply-gnome-settings.sh.
#
# Usage: ./apply-mac-finder-shortcuts.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=./lib-custom-keybinding.sh
source "$SCRIPT_DIR/lib-custom-keybinding.sh"

if [[ $EUID -eq 0 ]]; then
    echo "Run this as your normal desktop user, not root/sudo." >&2
    exit 1
fi

if ! command -v gsettings >/dev/null 2>&1; then
    echo "gsettings not found -- is this a GNOME session?" >&2
    exit 1
fi

if ! command -v nautilus >/dev/null 2>&1; then
    echo "Warning: nautilus not found -- folder-shortcut bindings will" >&2
    echo "still be registered, but won't do anything until it's installed." >&2
fi

echo "Registering Finder-style folder shortcuts (Shift+Ctrl+<key>," \
     "i.e. physical Shift+Cmd+<key> after the swap)..."

register_custom_keybinding "mac-finder-home" "Mac: Home folder" \
    "nautilus \$HOME" "<Shift><Ctrl>h"
register_custom_keybinding "mac-finder-desktop" "Mac: Desktop folder" \
    "nautilus \$HOME/Desktop" "<Shift><Ctrl>d"
register_custom_keybinding "mac-finder-documents" "Mac: Documents folder" \
    "nautilus \$HOME/Documents" "<Shift><Ctrl>o"
register_custom_keybinding "mac-finder-downloads" "Mac: Downloads folder" \
    "nautilus \$HOME/Downloads" "<Alt><Ctrl>l"
register_custom_keybinding "mac-finder-computer" "Mac: Computer window" \
    "nautilus computer:///" "<Shift><Ctrl>c"
register_custom_keybinding "mac-finder-network" "Mac: Network window" \
    "nautilus network:///" "<Shift><Ctrl>k"
register_custom_keybinding "mac-finder-recent" "Mac: Recents window" \
    "nautilus recent:///" "<Shift><Ctrl>f"

echo "Registering Empty Trash (Shift+Ctrl+Delete, no confirmation, like" \
     "Option-Shift-Cmd-Delete)..."
register_custom_keybinding "mac-empty-trash" "Mac: Empty Trash" \
    "gio trash --empty" "<Shift><Ctrl>Delete"

echo "Binding Ctrl+Up -> Activities overview (closest GNOME equivalent" \
     "of Mission Control)..."
gsettings set org.gnome.shell.keybindings toggle-overview "['<Ctrl>Up']"

echo "Binding Ctrl+Down -> cycle windows of the current app (closest" \
     "equivalent of 'show all windows of front app')..."
gsettings set org.gnome.desktop.wm.keybindings switch-group "['<Ctrl>Down']"

echo ""
echo "Done. Shortcuts with no sane Linux equivalent were intentionally"
echo "skipped -- see the 'macOS Finder shortcut mapping' table in"
echo "../README.md for the full list and rationale."
