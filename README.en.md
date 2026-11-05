# macOS Hungarian keyboard layout on Arch Linux

[Magyar](README.md) | [English](README.en.md)

This project brings the macOS Hungarian character layout for the
numeric-keypad **Apple Aluminium ISO** keyboard to Arch Linux. It includes
configuration for GNOME and Hyprland.

The custom XKB variant is named
`hu+102_qwertz_comma_dead_mac_full`. It preserves the Hungarian base
characters and maps the macOS Option-layer symbols to match the Apple
layout. **Both Alt keys** activate the AltGr-like symbol layer. The
numeric keypad uses a decimal comma, as in the Hungarian layout.

> **Important:** your keyboard must have a physical ISO layout. A system
> locale (such as `hu_HU.UTF-8`) does not select a keyboard layout.

## Fresh installation — GNOME (Arch Linux)

Run these steps on the machine where you want to use the layout.

### 1. Prerequisites

- Arch Linux, a GNOME desktop session, and `sudo` access.
- `xkeyboard-config`, which provides the base Hungarian XKB layout.
- `libxkbcommon` for the `xkbcli` verification commands (GNOME usually
  already installs it).
- Git to download this project.
- For the `Ctrl+Alt+E` euro shortcut: `wtype` on a Wayland session or
  `xdotool` on an X11 session. This implements the documented macOS
  combination in GNOME.

On a fresh Arch installation:

```sh
sudo pacman -Syu --needed git xkeyboard-config libxkbcommon
```

On Wayland, if you want the `Ctrl+Alt+E` shortcut:

```sh
sudo pacman -S --needed wtype
```

On X11, install this instead:

```sh
sudo pacman -S --needed xdotool
```

### 2. Clone the project

```sh
git clone https://github.com/peterzsilak/mac-hun-hyprland-keyboard.git
cd mac-hun-hyprland-keyboard
```

### 3. Install the XKB layout system-wide

```sh
sudo ./install.sh --de=gnome
```

The installer installs the layout in
`/usr/share/X11/xkb/symbols/hu` and registers it in the XKB `evdev.xml`
and `base.xml` rules so GNOME can discover it. It makes timestamped
backups of all three files before changing them. The installer is safe to
run again.

### 4. Apply your GNOME user settings

Run this as your regular, logged-in desktop user, **without `sudo`**:

```sh
./gnome/apply-gnome-settings.sh
```

This selects the custom layout, makes both Alt keys act as Option, swaps
Ctrl and Super for Mac Command/Ctrl muscle memory, and registers the
`Ctrl+Alt+E` → `€` shortcut. It changes the GNOME settings for this user,
not for other users on the system.

### 5. Restart your GNOME session

Log **all the way out** of GNOME, then log back in. Locking the screen or
closing the terminal is not enough; you do not need to reboot the
computer. Test the keys after logging in again.

### 6. Quick check

`Alt+Q` should type `@`, `Alt+U` should produce a dead diaeresis (`¨`),
and `Ctrl+Alt+E` should type `€`. Hungarian accented letters remain on
the base keys of the physical Hungarian Apple keyboard; for example,
`é`, `á`, `ű`, and `ő` work without Alt.

You can also check the saved GNOME source and the XKB catalog entry:

```sh
gsettings get org.gnome.desktop.input-sources sources
gsettings get org.gnome.desktop.input-sources current
gsettings get org.gnome.desktop.input-sources xkb-options
xkbcli list | grep -A 5 '102_qwertz_comma_dead_mac_full'
```

The source should contain
`('xkb', 'hu+102_qwertz_comma_dead_mac_full')`; the `xkb-options` list
should include `lv3:alt_switch`. The `xkbcli list` output should show
`Hungarian (macOS documented symbols, Apple ISO)`. `xkbcli` is included in
the `libxkbcommon` package.

## GNOME Finder shortcuts (optional)

You can optionally enable Finder-like folder navigation, empty-trash, and
window-switching shortcuts. Run this as your regular user:

```sh
./gnome/apply-mac-finder-shortcuts.sh
```

This requires GNOME and `gsettings`. Folder shortcuts use Nautilus
(`nautilus`), and emptying the trash requires `gio`. The script warns if
Nautilus is missing. **`Shift+Ctrl+Delete` empties the trash immediately,
without confirmation.**

| macOS shortcut | Action | GNOME equivalent |
|---|---|---|
| Cmd-D, Cmd-F, Cmd-R | Duplicate, search, refresh | Ctrl-D, Ctrl-F, Ctrl-R in Nautilus |
| Cmd-N, Cmd-T | New window, new tab | Ctrl-N, Ctrl-T in Nautilus |
| Cmd-1 / Cmd-2 | Icon/list view | Ctrl-1 / Ctrl-2 in Nautilus |
| Cmd-3 / Cmd-4 | Column/gallery view | No equivalent in modern GTK4 Nautilus |
| Cmd-[ / Cmd-] | Back / forward | Ctrl-[ / Ctrl-] in Nautilus |
| Cmd-Up / Cmd-Down | Parent folder / open selected item | Ctrl-Up / Ctrl-Down or Ctrl-O in Nautilus |
| Cmd-Delete | Move to Trash | Delete in Nautilus |
| Shift-Cmd-N | New folder | Ctrl-Shift-N in Nautilus |
| Shift-Cmd-H / D / O | Home / Desktop / Documents | Custom GNOME shortcuts |
| Option-Cmd-L | Downloads | Custom GNOME shortcut |
| Shift-Cmd-C / K / F | Computer / network / recent items | Custom GNOME shortcuts |
| Shift-Cmd-Delete | Empty Trash | Custom shortcut, without confirmation |
| Cmd-Y / Option-Cmd-Y | Quick Look / slideshow | Space after installing `gnome-sushi` |
| Ctrl-Space | Switch input source | Super-Space after the Ctrl/Super swap |
| Ctrl-Up / Ctrl-Down | Mission Control / windows of current app | GNOME overview / switch app windows |
| AirDrop, iCloud, Dock, Fn-row, and Finder-specific toggles | macOS features | No direct Linux equivalent |

The GNOME Finder script adds the custom folder, empty-trash, and
window-management shortcuts listed above. Some Finder features are
specific to macOS and are not included.

## Installation — Hyprland

The first three GNOME installation steps apply here as well, but run the
installer with Hyprland selected:

```sh
sudo ./install.sh --de=hyprland
```

Then add the following keyboard settings to your Hyprland configuration:

```ini
input {
    kb_layout = hu
    kb_variant = 102_qwertz_comma_dead_mac_full
    kb_model = applealu_iso
    kb_options = lv3:alt_switch
}
```

If you already have an `input` block, add these settings to it; do not
create a conflicting second configuration. Then reload Hyprland:

```sh
hyprctl reload
```

`hypr/input.lua` is an example for a Lua-based Hyprland configuration
framework; it cannot be copied directly into every Hyprland setup. The
project's `hypr/keybinds-snippet.lua` shows an optional
`Ctrl+Alt+E` → `€` shortcut for that same Lua framework. The shortcut requires `wtype` on
Wayland.

## Updating and troubleshooting

### GNOME still uses the previous layout

Check the selected source:

```sh
gsettings get org.gnome.desktop.input-sources sources
gsettings get org.gnome.desktop.input-sources current
```

Then check whether XKB recognizes the custom variant:

```sh
xkbcli list | grep -A 5 '102_qwertz_comma_dead_mac_full'
xkbcli compile-keymap \
    --layout hu \
    --variant 102_qwertz_comma_dead_mac_full \
    --model applealu_iso \
    --options lv3:alt_switch \
    --test
```

If the source is correct but the keys still produce the wrong characters,
log out of GNOME completely and log back in. If the custom variant does
not appear in `xkbcli list`, rerun the installer as root, then log out
and back in:

```sh
sudo ./install.sh --de=gnome
```

An `xkeyboard-config` update may overwrite the XKB files managed by that
package. Rerun the installer after such an update; it makes a fresh
backup and registers the variant again if needed. Then log out and back
in.

### `Ctrl+Alt+E` does not type the euro sign

The `Ctrl+Alt+E` shortcut requires `wtype` on Wayland or `xdotool` on
X11. Install the package for your session, then rerun this as your regular
user:

```sh
./gnome/apply-gnome-settings.sh
```

## What the project installs

- `xkb/hu-symbols-custom-block.txt` — the custom Hungarian XKB variant.
- `install.sh` — installs the variant system-wide and registers it in the
  XKB `evdev.xml` and `base.xml` rules. It makes timestamped backups of
  changed files.
- `gnome/apply-gnome-settings.sh` — configures the GNOME input source and
  related keyboard options for the current user.
- `gnome/apply-mac-finder-shortcuts.sh` — optional GNOME Finder-like
  shortcuts.
- `gnome/lib-custom-keybinding.sh` — shared GNOME shortcut helper.
- `hypr/input.lua` — example for a Lua-based Hyprland configuration.
- `hypr/keybinds-snippet.lua` — optional euro shortcut for the same Lua
  configuration.

## Documented macOS combinations

The table below lists characters documented for the Apple Hungarian
layout. Physical key names match the Hungarian ISO Apple keyboard with a
numeric keypad. Alt corresponds to the macOS Option key.

Apple part number `MQ052MG/A` identifies the older Hungarian Magic
Keyboard hardware variant with a numeric keypad; it does not contain the
macOS character-layer map.

| macOS combination | Character |
|---|---|
| Alt+í | `|` |
| Alt+ü | `\` |
| Alt+Shift+3 | `#` |
| Alt+Shift+4 | `$` |
| Alt+q | `@` |
| Ctrl+Alt+E | `€` (GNOME shortcut) |
| Alt+g | `©` |
| Alt+1 | `&` |
| Alt+. | `;` |
| Alt+Shift+, | `*` |
| Alt+8 / Alt+9 | `[` / `]` |
| Alt+7 / Alt+ö | `{` / `}` |
| Alt+Shift+Y / Alt+Shift+X | `<` / `>` |
| Alt+ú / Alt+ű | `~` / `` ` `` |

This is not a complete, authoritative Apple key-by-key map. Characters
and modifier levels not listed here come from the default XKB Hungarian
layout and may differ from Apple's layout. A full, 100% match requires
checking every modifier layer (base, Shift, Option, Shift+Option) in
Apple's Keyboard Viewer. This project therefore does not claim to be a
bit-for-bit copy of the complete macOS layout.

`Alt+u` is currently set to a dead diaeresis (`¨`) based on general macOS
behavior; this mapping could not be independently verified for Apple's
Hungarian layout.

### Additional four-level Hungarian keyboard chart

The [Magic Utilities Hungarian layout chart](https://magicutilities.net/magic-keyboard/help/keyboard-layouts/layout-mu?layout=Hungarian)
shows base, Shift, right Alt (AltGr), and Shift+right Alt characters for
the same Hungarian ISO key legends. This is a **Windows/AltGr layout**,
not the Apple macOS layout: for example, it shows the euro sign on
AltGr+U, while the macOS shortcut listed above is Ctrl+Alt+E. It is
useful as a reference for the physical keys and Windows modifier layer,
but is not treated as evidence for Apple's Option layer.

## Sources

- The symbol positions are based on the macOS Hungarian layout and
  cross-referenced with:
  https://randomblog.hu/hungarian-macos-keyboard-guide-to-newbies/
- Additional Mac HU symbol combinations:
  https://github.com/leventemo/lvnt/blob/main/src/data/blog/_2023/keyboard-layouts.md
- Four-level Hungarian ISO Windows/AltGr layout (not macOS):
  https://magicutilities.net/magic-keyboard/help/keyboard-layouts/layout-mu?layout=Hungarian
- Additional PC-style layout projects:
  https://github.com/gaborbata/mac-hun-keyboard and
  https://github.com/zaki/mac-hun-keyboard
