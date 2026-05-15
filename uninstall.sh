#!/usr/bin/env bash
set -euo pipefail

# ── Banner ───────────────────────────────────────────────────────────────────
figlet -f slant "Uninstall" 2>/dev/null || true
echo "   my-hyprland-dotfiles uninstaller"
echo

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Colors & helpers ─────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "  ${GREEN}✓${NC}  $*"; }
warn()  { echo -e "  ${YELLOW}!${NC}  $*"; }
die()   { echo -e "  ${RED}✗  $*${NC}" >&2; exit 1; }
step()  { echo -e "\n${CYAN}▶ $*${NC}"; }

# ── Pre-flight checks ─────────────────────────────────────────────────────────
[[ "$EUID" -eq 0 ]]               && die "Do not run as root."
command -v pacman &>/dev/null     || die "pacman not found — Arch Linux only."
[[ -f "$DOTFILES/packages.txt" ]] || die "packages.txt not found in $DOTFILES"

# ── What this removes ─────────────────────────────────────────────────────────
echo -e "  Dotfiles from: ${CYAN}$DOTFILES${NC}"
echo
echo "  The following will be removed:"
echo "    Config symlinks   ~/.config/{hypr,waybar,kitty,swaync,rofi,fastfetch,wlogout,btop,nvim}"
echo "    Local bin scripts ~/.local/bin/{rofi-launcher,rofi-clipboard,rofi-wallpaper}"
echo "    Assets            ~/.config/assets"
echo "    Zsh setup         ~/.zshrc (symlink), ~/.oh-my-zsh, default shell → bash"
echo "    Packages          all from packages.txt except preserved packages"
echo
echo "  Preserved (not touched):"
echo "    sddm  hyprland  uwsm  kitty  yay  pacman-contrib"
echo
read -rp "  Proceed? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

# ── Symlink removal helper ────────────────────────────────────────────────────
unlink_if_ours() {
    local dst="$1"
    local target
    if [[ -L "$dst" ]]; then
        target="$(readlink "$dst")"
        if [[ "$target" == "$DOTFILES" || "$target" == "$DOTFILES"/* ]]; then
            rm "$dst"
            info "removed  $dst"
        fi
    elif [[ -e "$dst" ]]; then
        warn "skipping  $dst  (not a repo symlink)"
    fi
}

# ── Step 1: Config symlinks ───────────────────────────────────────────────────
step "1/5  Removing ~/.config symlinks"
for dir in hypr waybar kitty swaync rofi fastfetch wlogout btop nvim; do
    unlink_if_ours "$HOME/.config/$dir"
done

# ── Step 2: Local bin scripts ─────────────────────────────────────────────────
step "2/5  Removing ~/.local/bin scripts"
for script in "$DOTFILES/.local/bin/"*; do
    [[ -f "$script" ]] || continue
    unlink_if_ours "$HOME/.local/bin/$(basename "$script")"
done

# ── Step 3: Assets ────────────────────────────────────────────────────────────
step "3/5  Removing ~/.config/assets"
if [[ -d "$HOME/.config/assets" ]]; then
    rm -rf "$HOME/.config/assets"
    info "removed ~/.config/assets"
else
    info "~/.config/assets not found, skipping"
fi

# ── Step 4: Zsh / Oh My Zsh ──────────────────────────────────────────────────
step "4/5  Removing Zsh setup"

if [[ -L "$HOME/.zshrc" && "$(readlink "$HOME/.zshrc")" == "$DOTFILES"* ]]; then
    rm "$HOME/.zshrc"
    info "removed ~/.zshrc symlink"
elif [[ -e "$HOME/.zshrc" ]]; then
    warn "~/.zshrc exists but is not a repo symlink — leaving it in place"
fi

if [[ -d "$HOME/.oh-my-zsh" ]]; then
    rm -rf "$HOME/.oh-my-zsh"
    info "removed ~/.oh-my-zsh"
else
    info "~/.oh-my-zsh not found, skipping"
fi

if [[ "$SHELL" != "$(command -v bash)" ]]; then
    chsh -s "$(command -v bash)"
    info "default shell restored to bash (takes effect on next login)"
else
    info "shell already bash"
fi

# ── Step 5: Packages ─────────────────────────────────────────────────────────
step "5/5  Uninstalling packages"

KEEP_PKGS=(sddm hyprland uwsm kitty yay pacman-contrib)

to_remove=()
while IFS= read -r line; do
    [[ "$line" =~ ^[[:space:]]*# || -z "${line// }" ]] && continue
    pkg="${line%%#*}"
    pkg="${pkg//[[:space:]]}"
    [[ -z "$pkg" ]] && continue
    [[ " ${KEEP_PKGS[*]} " == *" $pkg "* ]] && continue
    pacman -Q "$pkg" &>/dev/null || continue
    to_remove+=("$pkg")
done < "$DOTFILES/packages.txt"

if [[ ${#to_remove[@]} -eq 0 ]]; then
    info "No packages to remove."
else
    echo "  Packages to remove (${#to_remove[@]}):"
    printf '      %s\n' "${to_remove[@]}"
    echo
    if command -v yay &>/dev/null; then
        read -rp "  Remove these packages? [y/N] " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            yay -Rns --noconfirm "${to_remove[@]}"
        else
            warn "Skipping package removal."
        fi
    else
        warn "yay not found — remove packages manually:"
        printf '      %s\n' "${to_remove[@]}"
    fi
fi

# ── Done ─────────────────────────────────────────────────────────────────────
echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Done! System cleaned.${NC}"
echo -e "  Still installed: ${CYAN}sddm  hyprland  uwsm  kitty  yay  pacman-contrib${NC}"
echo
echo "  Install another DE, then remove Hyprland with:"
echo -e "    ${CYAN}yay -Rns hyprland uwsm xdg-desktop-portal-hyprland${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
