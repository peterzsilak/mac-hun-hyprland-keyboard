# Magyar macOS-billentyűzet Arch Linuxon

[Magyar](README.md) | [English](README.en.md)

Ez a projekt a magyar, numerikus blokkos **Apple Aluminium ISO**
billentyűzet macOS-es karakterkiosztását teszi használhatóvá Arch Linuxon.
GNOME-hoz és Hyprlandhez tartalmaz beállításokat.

Az egyedi XKB-változat neve:
`hu+102_qwertz_comma_dead_mac_full`. A magyar alapkaraktereket megtartja,
az Option-réteg (`Alt`) macOS-es szimbólumait pedig az Apple-kiosztáshoz
igazítja. Az AltGr-szerű réteget **mindkét Alt billentyű** aktiválja.
A numerikus blokk magyar kiosztásának megfelelően vesszőt használ
tizedesjelként.

> **Fontos:** a billentyűzet fizikai kiosztásának ISO-nak kell lennie.
> A rendszer területi beállítása (például `hu_HU.UTF-8`) önmagában nem
> választ ki billentyűzetkiosztást.

## Telepítés nulláról – GNOME (Arch Linux)

Az alábbi lépéseket azon a gépen kell elvégezni, amelyiken a kiosztást
használni szeretnéd.

### 1. Előfeltételek

- Arch Linux, GNOME-munkamenet és `sudo` jogosultság.
- `xkeyboard-config`, amely az XKB magyar alapkiosztást tartalmazza.
- `libxkbcommon` az `xkbcli` ellenőrző parancsokhoz (a GNOME általában
  már telepíti).
- Git a projekt letöltéséhez.
- Az eurójelhez tartozó `Ctrl+Alt+E` gyorsbillentyűhöz:
  `wtype` Wayland-munkamenetben vagy `xdotool` X11-munkamenetben.
  Ez a dokumentált macOS-kombinációt valósítja meg GNOME-ban.

Friss Arch rendszeren:

```sh
sudo pacman -Syu --needed git xkeyboard-config libxkbcommon
```

Wayland alatt, ha használni szeretnéd a `Ctrl+Alt+E` gyorsbillentyűt:

```sh
sudo pacman -S --needed wtype
```

X11 alatt ehelyett:

```sh
sudo pacman -S --needed xdotool
```

### 2. A projekt letöltése

```sh
git clone https://github.com/peterzsilak/mac-hun-hyprland-keyboard.git
cd mac-hun-hyprland-keyboard
```

### 3. Az XKB-kiosztás rendszerszintű telepítése

```sh
sudo ./install.sh --de=gnome
```

A telepítő a kiosztást a `/usr/share/X11/xkb/symbols/hu` fájlba telepíti,
és bejegyzi az XKB `evdev.xml` és `base.xml` szabályfájljaiba, hogy a GNOME
fel tudja ismerni. Módosítás előtt mindhárom fájlról időbélyeges biztonsági
másolatot készít. A telepítő biztonságosan újrafuttatható.

### 4. A GNOME-felhasználói beállítások alkalmazása

Ezt a lépést a saját, bejelentkezett asztali felhasználóddal futtasd,
**ne `sudo`-val**:

```sh
./gnome/apply-gnome-settings.sh
```

A parancs beállítja az egyedi kiosztást, mindkét Alt billentyűt Optionként
használja, felcseréli a Ctrl és Super billentyűket a Mac-féle
Command/Ctrl-izommemóriához, és regisztrálja a `Ctrl+Alt+E` → `€`
gyorsbillentyűt. Ez a felhasználó GNOME-beállításait módosítja, nem a
rendszer többi felhasználójáét.

### 5. A GNOME újraindítása

Jelentkezz ki **teljesen** a GNOME-munkamenetből, majd jelentkezz vissza.
A képernyő zárolása vagy a terminál bezárása nem elég; a gép újraindítása
nem szükséges. A munkamenet újraindítása után teszteld a billentyűket.

### 6. Gyors ellenőrzés

Az `Alt+Q` kombinációnak `@` jelet, az `Alt+U` kombinációnak halott
diaerézist (`¨`), a `Ctrl+Alt+E` kombinációnak pedig `€` jelet kell adnia.
Az ékezetes magyar betűk a fizikai magyar Apple-billentyűzet
alapbillentyűin maradnak; például az `é`, `á`, `ű` és `ő` billentyűk
Alt nélkül működnek.

Ellenőrizheted a mentett GNOME-forrást és az XKB katalógusbejegyzését is:

```sh
gsettings get org.gnome.desktop.input-sources sources
gsettings get org.gnome.desktop.input-sources current
gsettings get org.gnome.desktop.input-sources xkb-options
xkbcli list | grep -A 5 '102_qwertz_comma_dead_mac_full'
```

A forrásnak ezt kell tartalmaznia:
`('xkb', 'hu+102_qwertz_comma_dead_mac_full')`; az `xkb-options` listában
pedig szerepelnie kell az `lv3:alt_switch` opciónak. Az `xkbcli list`
kimenetében a `Hungarian (macOS documented symbols, Apple ISO)` leírás
jelenjen meg. Az `xkbcli` a `libxkbcommon` csomag része.

## GNOME Finder-gyorsbillentyűk (opcionális)

A Finderhez hasonló extra mappaváltó, kukaürítő és ablakváltó
gyorsbillentyűket külön kapcsolhatod be, normál felhasználóként:

```sh
./gnome/apply-mac-finder-shortcuts.sh
```

Ehhez GNOME és a `gsettings` kell. A mappaparancsokhoz a Nautilus
(`nautilus`), a kukaürítéshez pedig a `gio` szükséges. A script figyelmeztet,
ha a Nautilus nem található. **A `Shift+Ctrl+Delete` azonnal kiüríti a
kukát, megerősítés nélkül.**

| macOS-billentyű | Funkció | GNOME-megfelelő |
|---|---|---|
| Cmd-D, Cmd-F, Cmd-R | Duplikálás, keresés, frissítés | Nautilusban Ctrl-D, Ctrl-F, Ctrl-R |
| Cmd-N, Cmd-T | Új ablak, új lap | Nautilusban Ctrl-N, Ctrl-T |
| Cmd-1 / Cmd-2 | Ikon-/listanézet | Nautilusban Ctrl-1 / Ctrl-2 |
| Cmd-3 / Cmd-4 | Oszlop-/galérianézet | Nincs megfelelő a modern GTK4 Nautilusban |
| Cmd-[ / Cmd-] | Vissza / előre | Nautilusban Ctrl-[ / Ctrl-] |
| Cmd-Fel / Cmd-Le | Szülőmappa / kijelölt elem megnyitása | Nautilusban Ctrl-Fel / Ctrl-Le vagy Ctrl-O |
| Cmd-Delete | Áthelyezés a kukába | Nautilusban Delete |
| Shift-Cmd-N | Új mappa | Nautilusban Ctrl-Shift-N |
| Shift-Cmd-H / D / O | Home / Asztal / Dokumentumok | Egyedi GNOME-gyorsbillentyű |
| Option-Cmd-L | Letöltések | Egyedi GNOME-gyorsbillentyű |
| Shift-Cmd-C / K / F | Számítógép / hálózat / legutóbbiak | Egyedi GNOME-gyorsbillentyű |
| Shift-Cmd-Delete | Kuka ürítése | Egyedi gyorsbillentyű, megerősítés nélkül |
| Cmd-Y / Option-Cmd-Y | Quick Look / diavetítés | Space a `gnome-sushi` telepítése után |
| Ctrl-Space | Bemeneti forrás váltása | Super-Space a Ctrl/Super csere után |
| Ctrl-Fel / Ctrl-Le | Mission Control / alkalmazás ablakai | GNOME Áttekintés / alkalmazás ablakainak váltása |
| AirDrop, iCloud, Dock, Fn-sor és Finder-specifikus kapcsolók | macOS-funkciók | Nincs közvetlen Linux-megfelelő |

A GNOME Finder-script a Nautilus navigációs gyorsbillentyűin kívül a
fenti egyedi mappaparancsokat, kukaürítést és ablakműveleteket állítja be.
Egyes Finder-funkciók operációsrendszer-specifikusak, ezért nem részei a
projektnek.

## Telepítés – Hyprland

Az első három GNOME-telepítési lépés ugyanúgy érvényes, de a telepítőt
Hyprland célmegjelöléssel futtasd:

```sh
sudo ./install.sh --de=hyprland
```

Ezután a Hyprland saját konfigurációjába illeszd be a következő
billentyűzet-beállításokat:

```ini
input {
    kb_layout = hu
    kb_variant = 102_qwertz_comma_dead_mac_full
    kb_model = applealu_iso
    kb_options = lv3:alt_switch
}
```

Ha már létezik `input` blokk, a sorokat abba illeszd be; ne hozz létre
ütköző, párhuzamos beállításokat. Ezután:

```sh
hyprctl reload
```

A `hypr/input.lua` egy Lua-alapú Hyprland konfigurációs keretrendszerhez
készült példa, nem másolható közvetlenül minden Hyprland-konfigurációba.
A projekt `hypr/keybinds-snippet.lua` fájlja opcionális `Ctrl+Alt+E` → `€`
gyorsbillentyűt mutat be ugyanahhoz a Lua keretrendszerhez. Ehhez a
gyorsbillentyűhöz Wayland alatt `wtype` szükséges.

## Frissítés és hibaelhárítás

### A GNOME még az előző kiosztást használja

Ellenőrizd a beállított forrást:

```sh
gsettings get org.gnome.desktop.input-sources sources
gsettings get org.gnome.desktop.input-sources current
```

Ezután ellenőrizd, hogy az XKB ismeri-e az egyedi változatot:

```sh
xkbcli list | grep -A 5 '102_qwertz_comma_dead_mac_full'
xkbcli compile-keymap \
    --layout hu \
    --variant 102_qwertz_comma_dead_mac_full \
    --model applealu_iso \
    --options lv3:alt_switch \
    --test
```

Ha a forrás helyes, de a betűk továbbra sem a kívántak, jelentkezz ki a
GNOME-ból, majd vissza. Ha az egyedi változat nincs az `xkbcli list`
kimenetében, futtasd újra rendszergazdaként a telepítőt, majd jelentkezz
ki és vissza:

```sh
sudo ./install.sh --de=gnome
```

Az `xkeyboard-config` frissítése felülírhatja a csomag által kezelt XKB
fájlokat. Ilyen frissítés után futtasd újra a telepítőt; az friss
biztonsági másolatot készít, és szükség esetén újra bejegyzi a változatot.
Ezután jelentkezz ki és vissza.

### A `Ctrl+Alt+E` nem ír eurójelet

A `Ctrl+Alt+E` gyorsbillentyű Wayland alatt `wtype`, X11 alatt `xdotool`
programot igényel. Telepítsd a munkamenetednek megfelelő csomagot, majd
normál felhasználóként futtasd újra:

```sh
./gnome/apply-gnome-settings.sh
```

## Mit telepít a projekt?

- `xkb/hu-symbols-custom-block.txt` – az egyedi magyar XKB-változat.
- `install.sh` – rendszerszinten telepíti a változatot, és bejegyzi az
  `evdev.xml` és `base.xml` XKB-szabályfájlokba. A módosított fájlokról
  időbélyeges biztonsági másolatot készít.
- `gnome/apply-gnome-settings.sh` – normál felhasználóként beállítja a
  GNOME-bemeneti forrást és a kapcsolódó billentyűopciókat.
- `gnome/apply-mac-finder-shortcuts.sh` – opcionális GNOME Finder-szerű
  gyorsbillentyűk.
- `gnome/lib-custom-keybinding.sh` – a GNOME-parancsok közös segédje.
- `hypr/input.lua` – példa Lua-alapú Hyprland-konfigurációhoz.
- `hypr/keybinds-snippet.lua` – opcionális eurójel-gyorsbillentyű ugyanahhoz
  a Lua-konfigurációhoz.

## Dokumentált macOS-kombinációk

Az alábbi táblázat a nyilvánosan dokumentált Apple magyar kiosztás
karaktereit sorolja fel. A fizikai billentyűnevek a numerikus blokkos
magyar ISO Apple billentyűzetet követik. Az Alt az Option billentyűnek
felel meg.

Az Apple `MQ052MG/A` cikkszám a régebbi magyar, numerikus blokkos Magic
Keyboard hardverváltozatát azonosítja; nem tartalmazza a macOS
karakterrétegeinek térképét.

| macOS-kombináció | Karakter |
|---|---|
| Alt+í | `|` |
| Alt+ü | `\` |
| Alt+Shift+3 | `#` |
| Alt+Shift+4 | `$` |
| Alt+q | `@` |
| Ctrl+Alt+E | `€` (GNOME-gyorsbillentyű) |
| Alt+g | `©` |
| Alt+1 | `&` |
| Alt+. | `;` |
| Alt+Shift+, | `*` |
| Alt+8 / Alt+9 | `[` / `]` |
| Alt+7 / Alt+ö | `{` / `}` |
| Alt+Shift+Y / Alt+Shift+X | `<` / `>` |
| Alt+ú / Alt+ű | `~` / `` ` `` |

Ez nem teljes, hiteles Apple-billentyűszintű térkép. A projekt
alapértelmezett XKB magyar kiosztásából származó, nem felsorolt
karakterek és módosítószintek eltérhetnek az Apple kiosztásától. A
teljes, 100%-os egyezéshez az Apple Keyboard Viewer minden módosítós
rétegének (alap, Shift, Option, Shift+Option) ellenőrzése szükséges.
Ezért a projekt nem állítja, hogy a teljes macOS-kiosztás bitpontos
másolata.

Az `Alt+u` jelenleg halott diaerézis billentyű (`¨`), az általános macOS
viselkedés alapján; ezt a magyar Apple-kiosztásban nem sikerült külön
forrással ellenőrizni.

### További négyrétegű magyar billentyűtérkép

[A Magic Utilities magyar kiosztásábrája](https://magicutilities.net/magic-keyboard/help/keyboard-layouts/layout-mu?layout=Hungarian)
ugyanazon magyar ISO billentyűfeliratokhoz mutat alap, Shift, jobb Alt
(AltGr) és Shift+jobb Alt karaktereket. Ez **Windows/AltGr-kiosztás**,
nem Apple macOS-kiosztás: például az eurójelet AltGr+U-val mutatja,
míg a fenti macOS gyorsbillentyű Ctrl+Alt+E. Referenciaként hasznos a
fizikai billentyűk és a Windows-réteg összevetéséhez, de nem használjuk
az Apple Option-réteg bizonyítékaként.

## Források

- A szimbólumok alapja a macOS magyar kiosztása, összevetve ezzel:
  https://randomblog.hu/hungarian-macos-keyboard-guide-to-newbies/
- További Mac HU karakterkombinációk:
  https://github.com/leventemo/lvnt/blob/main/src/data/blog/_2023/keyboard-layouts.md
- Négyrétegű magyar ISO Windows/AltGr-kiosztás (nem macOS):
  https://magicutilities.net/magic-keyboard/help/keyboard-layouts/layout-mu?layout=Hungarian
- További, PC-s kiosztásokról szóló projektek:
  https://github.com/gaborbata/mac-hun-keyboard és
  https://github.com/zaki/mac-hun-keyboard
