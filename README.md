# my-hyprland-dotfiles

Hyprland rice for Arch Linux with a dual-theme system: **macchiato** (Catppuccin Mocha, daily use) and **matrix** (red-on-black, for when the mood calls for it). Theme switching is live with  one click in the bar or shortcut from keyboard and every component updates without restarting anything.

---

## Preview

![preview](screenshots/preview.gif)

---

## Components

| Role | Tool |
|---|---|
| Compositor | Hyprland 0.55+ (Lua config) |
| Bar | Waybar |
| Terminal | Kitty |
| Notification center | sway-notification-center |
| App launcher | Rofi (Wayland) |
| Fetch | Fastfetch |
| Logout screen | wlogout |
| System monitor | btop |
| Wallpaper daemon | awww |
| Lock / idle | hyprlock + hypridle |
| Clipboard | cliphist + wl-paste |

**Font:** JetBrainsMono Nerd Font  
**Icons:** Tela-circle-dracula (included as archive in `assets/`)  
**GTK theme:** Catppuccin Mocha (included as archive in `assets/`)

---

## Installation

> Arch Linux only. Assumes a base Arch install with internet access.

1. Clone the repo into your home directory:
   ```bash
   git clone https://github.com/Kernel236/my-hyprland-dotfiles ~/my-hyprland-dotfiles
   ```

2. Run the installer:
   ```bash
   cd ~/my-hyprland-dotfiles
   bash install.sh
   ```
   The installer checks for missing packages, creates symlinks from `~/.config/` into the repo,
   extracts the icon pack and GTK theme, and initializes the macchiato theme.

3. Log out and back in, then start Hyprland:
   ```bash
   uwsm start hyprland
   ```

Any future edit to the repo is reflected immediately — symlinks keep `~/.config/` in sync with the repo.

To add the BlackArch repository (optional), follow the official instructions at https://blackarch.org/downloads.html#install-repo

---

## Theme switching

Switch theme from the bar (click the theme indicator) or directly from a terminal:

```bash
~/.config/waybar/scripts/theme-switch.sh macchiato
~/.config/waybar/scripts/theme-switch.sh matrix
```

The script updates symlinks for Hyprland, Waybar, Kitty, swaync, Rofi and Fastfetch simultaneously. No restart needed.

---

## Wallpapers

Wallpapers are split by theme in `assets/backgrounds/`:

- `whitehat/` — used with macchiato (anime, landscapes, Studio Ghibli)
- `blackhat/` — used with matrix (dark Arch, Uchiha, BlackArch)

The wallpaper picker (`Super + SHIFT + W`) opens a Rofi gallery. You can also set a random wallpaper from the current theme's folder automatically on login.

---

## Keybinds

A cheatsheet overlay is available at any time with `Super + I`. All bindings are defined in `.config/hypr/conf/keybinds.lua`.

---

## Structure

```
my-hyprland-dotfiles/
├── .config/                mirrors ~/.config/ — each subdirectory is symlinked by install.sh
│   ├── hypr/               Hyprland config (Lua), hypridle, hyprlock, scripts, themes
│   ├── waybar/             bar config, per-module CSS, scripts, themes
│   ├── kitty/              terminal config and themes
│   ├── swaync/             notification center config and themes
│   ├── rofi/               launcher, wallpaper picker, themes
│   ├── fastfetch/          per-theme fetch configs
│   ├── wlogout/            logout screen layout and icons
│   └── btop/               system monitor config
├── .local/
│   └── bin/                rofi-launcher, rofi-wallpaper, rofi-clipboard
├── assets/                 wallpapers, icon pack archive, GTK theme archive
├── screenshots/            preview GIFs for the README
├── packages.txt            full package list (pacman/yay)
├── install.sh              automated installer
└── README.md
```
