#!/bin/bash
# theme-switch.sh <macchiato|matrix>
theme="${1:-macchiato}"

export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

# Cartella wallpaper e avatar per il tema
case "$theme" in
    matrix)
        wall_dir="$HOME/.config/assets/backgrounds/blackhat"
        ;;
    *)
        wall_dir="$HOME/.config/assets/backgrounds/whitehat"
        ;;
esac

# ── Symlinks e file (tutti prima di qualsiasi segnale) ──────────────────────
ln -sf "$HOME/.config/waybar/themes/${theme}.css"     "$HOME/.config/waybar/theme.css"
ln -sf "$HOME/.config/fastfetch/config-${theme}.jsonc" "$HOME/.config/fastfetch/config.jsonc"
ln -sf "$HOME/.config/rofi/colors-${theme}.rasi"      "$HOME/.config/rofi/colors.rasi"
ln -sf "$HOME/.config/kitty/themes/${theme}.conf"     "$HOME/.config/kitty/theme.conf"
ln -sf "$HOME/.config/swaync/themes/${theme}.css"     "$HOME/.config/swaync/theme.css"
rm -f "$HOME/.config/swaync/style.css"
cp "$HOME/.config/swaync/themes/${theme}.css"         "$HOME/.config/swaync/style.css"
ln -sf "$HOME/.config/hypr/themes/${theme}.lua"  "$HOME/.config/hypr/theme.lua"
ln -sf "$HOME/.config/hypr/themes/hyprlock-${theme}.conf" "$HOME/.config/hypr/hyprlock.conf"
printf '%s' "$wall_dir" > "$HOME/.config/rofi/.wall_dir"

# Wallpaper random dalla cartella del tema
wall=$(find "$wall_dir" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
    | shuf -n1)

if [[ -n "$wall" ]]; then
    ln -sf "$wall" "$HOME/.config/rofi/.current_wallpaper"
    setsid awww img "$wall" \
        --transition-type random --transition-fps 255 --transition-duration 0.8 \
        >/tmp/theme-switch.log 2>&1 &
fi

# ── Reload/restart processes ────────────────────────────────────────────────
hyprctl reload >/tmp/hypr-theme-switch.log 2>&1 || true
pkill -SIGUSR1 -x kitty 2>/dev/null || true
setsid "$HOME/.config/swaync/restart" >/tmp/swaync-theme-switch.log 2>&1 &

# Waybar reload stays last because this script is launched by Waybar itself.
killall -SIGUSR2 waybar
