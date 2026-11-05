#!/usr/bin/env bash
# Installs the custom documented macOS Hungarian XKB variant
# keyboard layout on Arch Linux, and points to the Hyprland or GNOME
# config needed to activate it (selectable at install time).
#
# Usage: sudo ./install.sh [--de=hyprland|gnome]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
XKB_HU_FILE="/usr/share/X11/xkb/symbols/hu"
XKB_RULES_FILES=(
    "/usr/share/X11/xkb/rules/evdev.xml"
    "/usr/share/X11/xkb/rules/base.xml"
)
BLOCK_FILE="$SCRIPT_DIR/xkb/hu-symbols-custom-block.txt"
MARKER='xkb_symbols "102_qwertz_comma_dead_mac_full"'
VARIANT="102_qwertz_comma_dead_mac_full"
RULE_DESCRIPTION="Hungarian (macOS, Apple ISO)"
RULE_ENTRY='        <variant>
          <configItem>
            <name>102_qwertz_comma_dead_mac_full</name>
            <description>Hungarian (macOS, Apple ISO)</description>
          </configItem>
        </variant>'

DE=""
for arg in "$@"; do
    case "$arg" in
        --de=*) DE="${arg#--de=}" ;;
    esac
done

if [[ $EUID -ne 0 ]]; then
    echo "Run this script with sudo." >&2
    exit 1
fi

tmp_file="$(mktemp "${XKB_HU_FILE}.tmp.XXXXXX")"
trap 'rm -f "$tmp_file"' EXIT

awk -v marker="$MARKER" '
    index($0, marker) && !inside { inside = 1; next }
    inside {
        if ($0 ~ /^[[:space:]]*};[[:space:]]*$/) inside = 0
        next
    }
    { lines[++count] = $0 }
    END {
        while (count > 0 && lines[count] ~ /^[[:space:]]*$/) count--
        for (i = 1; i <= count; i++) print lines[i]
    }
' "$XKB_HU_FILE" > "$tmp_file"
printf '\n' >> "$tmp_file"
cat "$BLOCK_FILE" >> "$tmp_file"

if cmp -s "$XKB_HU_FILE" "$tmp_file"; then
    echo "Custom variant is up to date in $XKB_HU_FILE."
else
    backup="${XKB_HU_FILE}.bak.$(date +%Y%m%d%H%M%S)"
    echo "Backing up $XKB_HU_FILE to $backup"
    cp "$XKB_HU_FILE" "$backup"
    cat "$tmp_file" > "$XKB_HU_FILE"
    echo "Installed/updated custom variant in $XKB_HU_FILE"
fi

for rules_file in "${XKB_RULES_FILES[@]}"; do
    rules_tmp="$(mktemp "${rules_file}.tmp.XXXXXX")"
    if ! awk -v variant="$VARIANT" -v description="$RULE_DESCRIPTION" -v entry="$RULE_ENTRY" '
        /<layout>/ { in_layout = 1; is_hu = 0 }
        in_layout && /<name>hu<\/name>/ { is_hu = 1 }
        is_hu && /<variant>/ { in_variant = 1; is_target = 0 }
        is_hu && in_variant && index($0, "<name>" variant "</name>") {
            found = 1
            is_target = 1
        }
        is_hu && in_variant && is_target && /<description>/ {
            sub(/<description>[^<]*<\/description>/, "<description>" description "</description>")
        }
        is_hu && /<\/variantList>/ && !found {
            print entry
            found = 1
        }
        { print }
        is_hu && /<\/variant>/ { in_variant = 0; is_target = 0 }
        /<\/layout>/ { in_layout = 0; is_hu = 0 }
        END { if (!found) exit 1 }
    ' "$rules_file" > "$rules_tmp"; then
        rm -f "$rules_tmp"
        echo "Could not register $VARIANT in $rules_file" >&2
        exit 1
    fi

    if cmp -s "$rules_file" "$rules_tmp"; then
        echo "Custom variant is registered in $rules_file."
        rm -f "$rules_tmp"
    else
        backup="${rules_file}.bak.$(date +%Y%m%d%H%M%S)"
        echo "Backing up $rules_file to $backup"
        cp "$rules_file" "$backup"
        chmod --reference="$rules_file" "$rules_tmp"
        chown --reference="$rules_file" "$rules_tmp"
        mv "$rules_tmp" "$rules_file"
        echo "Registered custom variant in $rules_file"
    fi
done

if [[ -z "$DE" ]]; then
    echo ""
    echo "Which desktop environment are you using?"
    echo "  1) Hyprland"
    echo "  2) GNOME"
    read -rp "Select [1/2]: " choice
    case "$choice" in
        2) DE="gnome" ;;
        *) DE="hyprland" ;;
    esac
fi

echo ""
if [[ "$DE" == "gnome" ]]; then
    echo "Next steps (GNOME):"
    echo "1. Log back into your normal desktop user (not root) and run:"
    echo "     ${SCRIPT_DIR}/gnome/apply-gnome-settings.sh"
    echo "   This sets the input source, enables Alt as the Option/Level3"
    echo "   modifier, swaps Ctrl<->Super (Cmd) for Mac muscle memory, and"
    echo "   registers the Ctrl+Alt+E -> € shortcut."
    echo ""
    echo "2. Log out/in (or Alt+F2, r on X11) so the new input source is"
    echo "   picked up by gnome-shell."
else
    echo "Next steps (Hyprland):"
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
fi
