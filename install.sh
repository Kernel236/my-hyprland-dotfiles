#!/usr/bin/env bash
set -euo pipefail

# ── Banner ───────────────────────────────────────────────────────────────────
figlet -f slant "Kernel_x23_6" 2>/dev/null || true
echo "   my-hyprland-dotfiles installer"
echo

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Colors & helpers ─────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "  ${GREEN}✓${NC}  $*"; }
warn()  { echo -e "  ${YELLOW}!${NC}  $*"; }
die()   { echo -e "  ${RED}✗  $*${NC}" >&2; exit 1; }
step()  { echo -e "\n${CYAN}▶ $*${NC}"; }

# ── Pre-flight checks ─────────────────────────────────────────────────────────
[[ "$EUID" -eq 0 ]]         && die "Do not run as root."
command -v pacman &>/dev/null || die "pacman not found — this installer is Arch Linux only."
[[ -f "$DOTFILES/packages.txt" ]] || die "packages.txt not found in $DOTFILES"
[[ -f "$DOTFILES/assets/icons/Tela-circle-dracula.tar.xz" ]] \
    || die "Missing asset: assets/icons/Tela-circle-dracula.tar.xz"
[[ -f "$DOTFILES/assets/themes/Catppuccin-Mocha.tar.xz" ]] \
    || die "Missing asset: assets/themes/Catppuccin-Mocha.tar.xz"

# ── What this installs ────────────────────────────────────────────────────────
echo -e "  Dotfiles from: ${CYAN}$DOTFILES${NC}"
echo
echo "  Components that will be configured:"
echo "    Hyprland 0.55+    Wayland compositor (Lua config)"
echo "    Waybar            status bar"
echo "    Rofi              app launcher, clipboard picker, emoji"
echo "    Kitty             terminal"
echo "    swaync            notification center"
echo "    wlogout           session logout screen"
echo "    Fastfetch         system fetch"
echo "    btop              system monitor"
echo "    hyprlock          lock screen"
echo "    hypridle          idle / power management daemon"
echo "    yazi              terminal file manager (via kitty)"
echo "    awww              wallpaper daemon"
echo "    cliphist          clipboard history (wl-paste)"
echo
echo "  Assets (copy manually — not tracked in git):"
echo "    Wallpapers            → ~/.config/assets/backgrounds/{whitehat,blackhat}/"
echo "    Icon theme            → yay -S tela-circle-icon-theme-dracula-git"
echo "    GTK theme             → yay -S catppuccin-gtk-theme-mocha"
echo
read -rp "  Proceed? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

# ── Step 1: Package check ─────────────────────────────────────────────────────
step "1/5  Checking packages"

total=0
missing=()
while IFS= read -r line; do
    [[ "$line" =~ ^[[:space:]]*# || -z "${line// }" ]] && continue
    pkg="${line%%#*}"
    pkg="${pkg//[[:space:]]}"
    [[ -z "$pkg" ]] && continue
    (( total++ )) || true
    pacman -Q "$pkg" &>/dev/null || missing+=("$pkg")
done < "$DOTFILES/packages.txt"

installed=$(( total - ${#missing[@]} ))
echo "  $installed / $total packages already installed"

if [[ ${#missing[@]} -gt 0 ]]; then
    warn "${#missing[@]} missing packages:"
    printf '      %s\n' "${missing[@]}"
    echo
    # yay handles both official repos and AUR — must be installed first
    # (bootstrap: git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si)
    if ! command -v yay &>/dev/null; then
        warn "yay not found — install it first: https://github.com/Jguer/yay"
        warn "Skipping package install."
    else
        read -rp "  Install missing packages with yay? [y/N] " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            yay -S --needed "${missing[@]}"
        else
            warn "Skipping. Some features may not work."
        fi
    fi
else
    info "All $total packages present."
fi

# ── Symlink helper ────────────────────────────────────────────────────────────
link() {
    local src="$1" dst="$2"
    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        info "already linked  $dst"
        return
    fi
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        warn "backing up  $dst → ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi
    [[ -L "$dst" ]] && rm "$dst"
    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    info "linked  $src  →  $dst"
}

# ── Step 2: Config symlinks ───────────────────────────────────────────────────
step "2/5  Symlinking ~/.config dirs"
link "$DOTFILES/.config/hypr"       "$HOME/.config/hypr"
link "$DOTFILES/.config/waybar"     "$HOME/.config/waybar"
link "$DOTFILES/.config/kitty"      "$HOME/.config/kitty"
link "$DOTFILES/.config/swaync"     "$HOME/.config/swaync"
link "$DOTFILES/.config/rofi"       "$HOME/.config/rofi"
link "$DOTFILES/.config/fastfetch"  "$HOME/.config/fastfetch"
link "$DOTFILES/.config/wlogout"    "$HOME/.config/wlogout"
link "$DOTFILES/.config/btop"       "$HOME/.config/btop"

# ── Step 3: Local bin scripts ─────────────────────────────────────────────────
step "3/5  Symlinking ~/.local/bin scripts"
mkdir -p "$HOME/.local/bin"
for script in "$DOTFILES/.local/bin/"*; do
    [[ -f "$script" ]] || continue
    chmod +x "$script"
    link "$script" "$HOME/.local/bin/$(basename "$script")"
done

# ── Step 4: Assets ────────────────────────────────────────────────────────────
step "4/5  Assets (manual setup)"
echo "  Assets are not tracked in the repo (too large for git)."
echo "  Copy your assets folder manually:"
echo
echo "    cp -r /path/to/assets ~/.config/assets"
echo
echo "  Expected layout:"
echo "    ~/.config/assets/backgrounds/whitehat/   ← wallpapers macchiato"
echo "    ~/.config/assets/backgrounds/blackhat/   ← wallpapers matrix"
echo "    ~/.config/assets/backgrounds/my-avatar*.png"
echo
echo "  Icon theme and GTK theme — install via AUR or manually:"
echo "    yay -S tela-circle-icon-theme-dracula-git"
echo "    yay -S catppuccin-gtk-theme-mocha"
echo
if [[ -d "$HOME/.config/assets/backgrounds" ]]; then
    info "~/.config/assets/backgrounds already present — nothing to do"
else
    warn "~/.config/assets/ not found — theme switcher wallpapers won't work until you copy it"
fi

# ── Step 5: Initialize theme ──────────────────────────────────────────────────
step "5/5  Initializing macchiato theme"
echo "  Running theme-switch.sh macchiato (safe outside Hyprland)..."
bash "$DOTFILES/.config/waybar/scripts/theme-switch.sh" macchiato 2>/dev/null || true
info "theme initialized"

echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Done! Log out and back in, then:  uwsm start hyprland${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
