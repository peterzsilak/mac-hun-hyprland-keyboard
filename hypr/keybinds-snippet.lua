-- Add this near the top of ~/.config/hypr/hyprland/keybinds.lua (or your
-- equivalent Hyprland Lua config), before other binds.
--
-- macOS-style € symbol (Ctrl+Alt+E), matching the Hungarian Mac keyboard
-- layout's Alt+E = € behaviour, mapped here as a system-wide shortcut since
-- the xkb layout already gives € on Alt+U as a bonus.
hl.bind("CTRL + ALT + E", hl.dsp.exec_cmd("wtype €"), { locked = true })
