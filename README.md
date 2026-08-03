# Mac Hungarian keyboard layout for Hyprland / GNOME on Arch Linux

A custom `hu` xkb keyboard variant, `102_qwertz_comma_dead_mac_full`, that
replicates the macOS Hungarian (Apple Aluminium ISO) keyboard's native
Option-key symbol placement on Linux, with a few deliberate deviations
(see below) to remove duplicate symbol positions and fill
previously-empty Option slots with useful dev/typing characters.
Supports both **Hyprland** and **GNOME** (X11 or Wayland), selectable at
install time.

Built on top of the existing `hu(102_qwertz_comma_dead_mac)` xkb variant
(already shipped with X.Org's `xkeyboard-config` package), with `Alt`
(Option) acting as the Level3 (AltGr-like) modifier via the
`lv3:alt_switch` xkb option -- this makes **both** Alt keys behave like
macOS's Option key, instead of only the right one.

## What's included

- `xkb/hu-symbols-custom-block.txt` -- the `xkb_symbols
  "102_qwertz_comma_dead_mac_full"` block to append to
  `/usr/share/X11/xkb/symbols/hu`.
- `hypr/input.lua` -- example Hyprland Lua input config enabling the
  layout.
- `hypr/keybinds-snippet.lua` -- an extra Ctrl+Alt+E -> € keybind (via
  `wtype`), matching macOS's Alt+E shortcut for the Euro sign (in addition
  to the native Alt+U bonus mapping baked into the layout itself).
- `gnome/apply-gnome-settings.sh` -- GNOME counterpart: sets the input
  source via `gsettings`, enables `lv3:alt_switch`, swaps Ctrl<->Super
  (Cmd) so Mac shortcuts (Cmd+C/V/...) land on the key GNOME treats as
  Ctrl, and registers the Ctrl+Alt+E -> € custom keybinding.
- `gnome/apply-mac-finder-shortcuts.sh` -- adds the rest of the macOS
  Finder hotkey set (see [support.apple.com/en-us/102650](https://support.apple.com/en-us/102650))
  that doesn't already come for free from the Ctrl/Cmd swap: folder
  shortcuts, Empty Trash, and Mission-Control-ish window switching. See
  the mapping table below for what's automatic vs. custom vs. skipped.
- `gnome/lib-custom-keybinding.sh` -- shared helper used by the two
  scripts above to register GNOME custom keybindings.
- `install.sh` -- installs the xkb variant (with automatic backup of the
  original `hu` symbols file), asks whether you're on Hyprland or GNOME
  (or pass `--de=hyprland`/`--de=gnome`), and prints/applies the
  remaining steps.

## Installation

```sh
git clone <this-repo>
cd mac-hun-hyprland-keyboard
sudo ./install.sh            # prompts for Hyprland or GNOME
# or non-interactively:
sudo ./install.sh --de=gnome
sudo ./install.sh --de=hyprland
```

### Hyprland

Follow the printed instructions to update `hypr/input.lua` /
`hypr/keybinds-snippet.lua` in your own config and run `hyprctl reload`.

### GNOME

After `install.sh` finishes, run the following as your **normal desktop
user** (not root/sudo), then log out/in:

```sh
./gnome/apply-gnome-settings.sh
./gnome/apply-mac-finder-shortcuts.sh
```

This swaps Ctrl and Super (Cmd) system-wide, matching the Mac's physical
key layout muscle memory, in addition to enabling the Option-key symbol
layer, the € shortcut, and the macOS Finder hotkey set below.

## macOS Finder shortcut mapping (GNOME)

Reference: [support.apple.com/en-us/102650](https://support.apple.com/en-us/102650).
Legend: ✅ automatic (works once Ctrl/Cmd are swapped, because Nautilus
already uses the same Ctrl+letter as Finder uses Cmd+letter), 🔧 custom
keybinding added by `apply-mac-finder-shortcuts.sh`, ⚠️ no sane Linux
equivalent -- intentionally skipped.

| macOS shortcut | Meaning | Linux/GNOME |
|---|---|---|
| Cmd-D | Duplicate | ✅ Nautilus `Ctrl-D` |
| Cmd-F | Search | ✅ Nautilus `Ctrl-F` |
| Cmd-R | Refresh/original | ✅ `Ctrl-R` |
| Cmd-N | New window | ✅ Nautilus `Ctrl-N` |
| Cmd-T | New tab | ✅ Nautilus `Ctrl-T` |
| Cmd-1 / Cmd-2 | Icon / list view | ✅ Nautilus `Ctrl-1` / `Ctrl-2` |
| Cmd-3 / Cmd-4 | Columns / gallery view | ⚠️ not in modern GTK4 Nautilus |
| Cmd-[ / Cmd-] | Back / forward folder | ✅ Nautilus `Ctrl-[` / `Ctrl-]` |
| Cmd-Up | Open parent folder | ✅ Nautilus `Ctrl-Up` |
| Cmd-Down | Open selected item | ✅ Nautilus `Ctrl-Down`/`Ctrl-O` |
| Cmd-Delete | Move to Trash | ✅ plain `Delete` already trashes in Nautilus |
| Shift-Cmd-N | New folder | ✅ Nautilus `Ctrl-Shift-N` |
| Shift-Cmd-H | Home folder | 🔧 `Shift-Ctrl-H` opens `nautilus $HOME` |
| Shift-Cmd-D | Desktop folder | 🔧 `Shift-Ctrl-D` opens `~/Desktop` |
| Shift-Cmd-O | Documents folder | 🔧 `Shift-Ctrl-O` opens `~/Documents` |
| Option-Cmd-L | Downloads folder | 🔧 `Alt-Ctrl-L` opens `~/Downloads` |
| Shift-Cmd-C | Computer window | 🔧 `Shift-Ctrl-C` opens `computer:///` |
| Shift-Cmd-K | Network window | 🔧 `Shift-Ctrl-K` opens `network:///` |
| Shift-Cmd-F | Recents window | 🔧 `Shift-Ctrl-F` opens `recent:///` |
| Shift-Cmd-Delete | Empty Trash | 🔧 `Shift-Ctrl-Delete` runs `gio trash --empty` |
| Option-Shift-Cmd-Delete | Empty Trash, no confirm | 🔧 same binding (CLI has no confirm dialog) |
| Shift-Cmd-G | Go to Folder dialog | ✅ Nautilus `Ctrl-L` (location bar) covers this |
| Cmd-K | Connect to Server | ✅ Nautilus `Ctrl-L`, type `smb://`/`ssh://`/etc. |
| Cmd-Y / Option-Cmd-Y | Quick Look / slideshow | ✅ `Space` via the `gnome-sushi` package |
| Control-Space | Switch input source | ✅ becomes `Super-Space` after the swap, GNOME's default |
| Control-Up Arrow | Mission Control | 🔧 `Ctrl-Up` -> Activities overview |
| Control-Down Arrow | Show all windows of front app | 🔧 `Ctrl-Down` -> cycle windows of current app |
| Shift-Cmd-I, Shift-Cmd-R (AirDrop/iCloud), Shift-Cmd-U (Utilities), Shift-Cmd-P/T (preview/tab bar toggle), Control-Cmd-A (alias), Control-Cmd-T (sidebar), Option-Cmd-D (Dock toggle), Option-Cmd-P/S (path/sidebar toggle), Cmd-J (view options), Cmd-/ (status bar) | Finder-only UI toggles / macOS-only features | ⚠️ no equivalent GNOME/Nautilus feature |
| Fn-A/C/D/N, Fn-Shift-A (Dock, Control Center, Dictation, Notification Center, Launchpad) | Fn-row shortcuts | ⚠️ Fn behavior is Apple-firmware-specific, not portable via xkb |
| Option/Cmd-drag, Option-double-click | Mouse-modifier behaviors | ⚠️ different modifier convention on GNOME (`Ctrl`-drag = copy already, unrelated to this swap) |
| Brightness/Volume + Option/Control combos | Open related Settings panel / fine adjustment | ⚠️ hardware/media-key dependent, out of scope |

## Symbol reference (current layout)

Legend: Base / Shift / **Alt** / Alt+Shift. "–" = empty (`VoidSymbol`).

### Number row

| Key | Base | Shift | Alt | Alt+Shift |
|---|---|---|---|---|
| § (TLDE) | 0 | § | ¬ | ¬ |
| 1 | 1 | ' | & | ~(dead) |
| 2 | 2 | " | ˇ(dead) | ˇ |
| 3 | 3 | + | ^(dead) | # |
| 4 | 4 | ! | ˘(dead) | $ |
| 5 | 5 | % | ˚(dead) | ° |
| 6 | 6 | / | ˛(dead) | ˛ |
| 7 | 7 | = | { | `(dead) |
| 8 | 8 | ( | [ | ˙ |
| 9 | 9 | ) | ] | ´ |
| Ö | ö | Ö | } | ˝ |
| Ü | ü | Ü | \ | ¨ |
| Ó | ó | Ó | ¸(dead) | ¸ |

### Top letter row

| Key | Base | Shift | Alt | Alt+Shift |
|---|---|---|---|---|
| Q | q | Q | @ | ™ |
| W | w | W | \| | § |
| E | e | E | Ä | E |
| R | r | R | ¶ | ® |
| T | t | T | ŧ | Ŧ |
| Z | z | Z | – | ¥ |
| U | u | U | € | ↑ |
| I | i | I | Í | í |
| O | o | O | „ | Ø |
| P | p | P | " | Þ |
| Ő | ő | Ő | ÷ | ˝(dead) |
| Ú | ú | Ú | ~ | ¯(dead) |

### Home row

| Key | Base | Shift | Alt | Alt+Shift |
|---|---|---|---|---|
| A | a | A | ä | Ä |
| S | s | S | đ | ẞ |
| D | d | D | Đ | Ð |
| F | f | F | ƒ | ª |
| G | g | G | © | Ŋ |
| H | h | H | ħ | Ħ |
| J | j | J | í | Í |
| K | k | K | ł | – |
| L | l | L | Ł | Ł |
| É | é | É | – | ¢ |
| Á | á | Á | ß | ẞ |
| Ű | ű | Ű | ` | ˘(dead) |

### Bottom row

| Key | Base | Shift | Alt | Alt+Shift |
|---|---|---|---|---|
| Í (LSGT) | í | Í | < | > |
| Y | y | Y | « | – |
| X | x | X | » | – |
| C | c | C | © | Ç |
| V | v | V | √ | ‚ |
| B | b | B | ≈ | ' |
| N | n | N | ≠ | ' |
| M | m | M | – | º |
| , | , | ? | ; | * |
| . | . | : | … | ÷ |
| - | - | _ | — | ˙(dead) |

## Deliberate deviations from the stock macOS Hungarian layout

- `<` / `>` live exclusively on the ISO key next to left Shift (labelled
  Í), matching the physical Hungarian ISO keyboard convention, instead of
  being duplicated across M / Y / X as in the stock layout.
- `Alt+Y` / `Alt+X` produce « / » (guillemets) instead of duplicating </>.
- `Alt+.` produces … (ellipsis) instead of a duplicate `:`.
- Previously empty Option slots (F, C, V, B, N, -, Shift+Q) are filled with
  ƒ, ©/Ç, √, ≈, ≠, — (em dash), and ™ respectively.
- `Alt+ú` = `~` (tilde) and `Alt+ű` = `` ` `` (backtick), placed for
  Linux/programming muscle memory rather than the stock macOS positions.

## Background / sources

- Base symbol positions derived from the stock macOS Hungarian keyboard,
  cross-referenced with
  https://randomblog.hu/hungarian-macos-keyboard-guide-to-newbies/
- PC-style alternate layout philosophies considered (but not adopted, per
  user preference for a native Mac-style layout) from
  https://github.com/gaborbata/mac-hun-keyboard and
  https://github.com/zaki/mac-hun-keyboard
