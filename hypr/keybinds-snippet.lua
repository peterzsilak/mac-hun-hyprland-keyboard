-- Add this near the top of ~/.config/hypr/hyprland/keybinds.lua (or your
-- equivalent Hyprland Lua config), before other binds.
--
-- macOS Hungarian € shortcut (Control+Option+E), implemented here as a
-- system-wide shortcut. XKB does not produce the symbol from a modifier layer.
hl.bind("CTRL + ALT + E", hl.dsp.exec_cmd("wtype €"), { locked = true })
