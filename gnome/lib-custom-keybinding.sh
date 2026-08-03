#!/usr/bin/env bash
# Shared helper for registering GNOME custom keybindings (spawn-a-command
# shortcuts) via gsettings. Sourced by the other gnome/*.sh scripts.

KB_BASE="org.gnome.settings-daemon.plugins.media-keys"

# register_custom_keybinding <slug> <name> <command> <binding>
#   slug:    unique dconf path segment, e.g. "mac-euro"
#   name:    human-readable label shown in GNOME Settings
#   command: shell command to run when the binding is pressed
#   binding: accelerator string, e.g. "<Shift><Ctrl>d"
register_custom_keybinding() {
    local slug="$1" name="$2" command="$3" binding="$4"
    local kb_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${slug}/"

    local existing
    existing=$(gsettings get "$KB_BASE" custom-keybindings)
    if [[ "$existing" != *"$slug"* ]]; then
        if [[ "$existing" == "@as []" || "$existing" == "[]" ]]; then
            gsettings set "$KB_BASE" custom-keybindings "['$kb_path']"
        else
            gsettings set "$KB_BASE" custom-keybindings "${existing%]}, '$kb_path']"
        fi
    fi

    gsettings set "${KB_BASE}.custom-keybinding:${kb_path}" name "$name"
    gsettings set "${KB_BASE}.custom-keybinding:${kb_path}" command "$command"
    gsettings set "${KB_BASE}.custom-keybinding:${kb_path}" binding "$binding"
}
