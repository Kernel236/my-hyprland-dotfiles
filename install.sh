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
ask_yn() { local _a; read -rp "  $1 [Y/n] " _a; [[ -z "$_a" || "$_a" =~ ^[Yy]$ ]]; }

# ── Pre-flight checks ─────────────────────────────────────────────────────────
[[ "$EUID" -eq 0 ]]         && die "Do not run as root."
command -v pacman &>/dev/null || die "pacman not found — this installer is Arch Linux only."
[[ -f "$DOTFILES/packages.txt" ]] || die "packages.txt not found in $DOTFILES"

# ── What this installs ────────────────────────────────────────────────────────
echo -e "  Dotfiles from: ${CYAN}$DOTFILES${NC}"
echo
echo "  Components that will be configured:"
echo "    Hyprland 0.55+    Wayland compositor (Lua config)"
echo "    Waybar            status bar"
echo "    Rofi              app launcher, clipboard picker, emoji"
echo "    Kitty             terminal (optional)"
echo "    swaync            notification center"
echo "    wlogout           session logout screen"
echo "    Fastfetch         system fetch"
echo "    btop              system monitor"
echo "    Neovim            text editor (lazy.nvim, LSP, Treesitter) (optional)"
echo "    Zsh + Oh My Zsh   shell (powerlevel10k, autosuggestions, syntax highlight) (optional)"
echo "    hyprlock          lock screen"
echo "    hypridle          idle / power management daemon"
echo "    yazi              terminal file manager (via kitty)"
echo "    awww              wallpaper daemon"
echo "    cliphist          clipboard history (wl-paste)"
echo
echo "  Assets (copied to ~/.config/assets):"
echo "    Wallpapers            whitehat/ + blackhat/ backgrounds"
echo "    wlogout icons         lock, logout, power, sleep, restart"
echo "    Icon + GTK theme      install via yay (not bundled in repo)"
echo
read -rp "  Proceed? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

# ── Optional components ───────────────────────────────────────────────────────
echo
if ask_yn "Install Kitty terminal?";  then INSTALL_KITTY=true; else INSTALL_KITTY=false; fi
if ask_yn "Install Zsh + Oh My Zsh?"; then INSTALL_ZSH=true;   else INSTALL_ZSH=false;   fi
if ask_yn "Install Neovim?";          then INSTALL_NVIM=true;   else INSTALL_NVIM=false;  fi
echo

SKIP_PKGS=()
$INSTALL_KITTY || SKIP_PKGS+=(kitty yazi)
$INSTALL_ZSH   || SKIP_PKGS+=(zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting zsh-theme-powerlevel10k-git)
$INSTALL_NVIM  || SKIP_PKGS+=(neovim lazygit gcc make nodejs npm r python-pip)

# ── Step 1: Package check ─────────────────────────────────────────────────────
step "1/6  Checking packages"

total=0
missing=()
while IFS= read -r line; do
    [[ "$line" =~ ^[[:space:]]*# || -z "${line// }" ]] && continue
    pkg="${line%%#*}"
    pkg="${pkg//[[:space:]]}"
    [[ -z "$pkg" ]] && continue
    [[ " ${SKIP_PKGS[*]} " == *" $pkg "* ]] && continue
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
step "2/6  Symlinking ~/.config dirs"
link "$DOTFILES/.config/hypr"       "$HOME/.config/hypr"
link "$DOTFILES/.config/waybar"     "$HOME/.config/waybar"
if $INSTALL_KITTY; then link "$DOTFILES/.config/kitty" "$HOME/.config/kitty"; fi
link "$DOTFILES/.config/swaync"     "$HOME/.config/swaync"
link "$DOTFILES/.config/rofi"       "$HOME/.config/rofi"
link "$DOTFILES/.config/fastfetch"  "$HOME/.config/fastfetch"
link "$DOTFILES/.config/wlogout"    "$HOME/.config/wlogout"
link "$DOTFILES/.config/btop"       "$HOME/.config/btop"
if $INSTALL_NVIM;  then link "$DOTFILES/.config/nvim"  "$HOME/.config/nvim";  fi

# ── Step 3: Zsh + Oh My Zsh ──────────────────────────────────────────────────
if $INSTALL_ZSH; then
    step "3/6  Setting up Zsh"

    # Install Oh My Zsh FIRST so it can't overwrite our symlink afterwards.
    # The installer backs up any existing .zshrc to .zshrc.pre-oh-my-zsh —
    # we let it do that on its own template, then we replace with our symlink.
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        info "Installing Oh My Zsh..."
        RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        info "Oh My Zsh installed"
    else
        info "Oh My Zsh already present"
    fi

    # Symlink .zshrc AFTER Oh My Zsh — our link() helper backs up whatever
    # .zshrc exists at this point (Oh My Zsh's template) to .zshrc.bak.
    link "$DOTFILES/.zshrc" "$HOME/.zshrc"

    # Change default shell to zsh if not already set
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        chsh -s "$(which zsh)"
        info "Default shell changed to zsh (takes effect on next login)"
    else
        info "Default shell already zsh"
    fi

    echo
    warn "First zsh launch will run 'p10k configure' to set up the prompt."
    warn "zsh-autosuggestions and zsh-syntax-highlighting must be available"
    warn "as oh-my-zsh plugins — see README if they are missing."

else
    info "Skipping Zsh setup."
fi

# ── Step 4: Local bin scripts ─────────────────────────────────────────────────
step "4/6  Symlinking ~/.local/bin scripts"

mkdir -p "$HOME/.local/bin"
for script in "$DOTFILES/.local/bin/"*; do
    [[ -f "$script" ]] || continue
    chmod +x "$script"
    link "$script" "$HOME/.local/bin/$(basename "$script")"
done

# ── Step 5: Assets ────────────────────────────────────────────────────────────
step "5/6  Copying assets to ~/.config/assets"
if [[ ! -d "$HOME/.config/assets" ]]; then
    echo "  Copying assets (backgrounds, wlogout icons)..."
    cp -r "$DOTFILES/assets" "$HOME/.config/assets"
    info "assets copied → ~/.config/assets"
else
    echo "  Syncing new files into ~/.config/assets (existing files untouched)..."
    cp -rn "$DOTFILES/assets/." "$HOME/.config/assets/"
    info "assets synced"
fi
echo
echo "  Icon theme and GTK theme — install separately if needed:"
echo "    yay -S tela-circle-icon-theme-dracula-git"
echo "    yay -S catppuccin-gtk-theme-mocha"

# ── Step 5: Initialize theme ──────────────────────────────────────────────────
step "6/6  Initializing macchiato theme"
echo "  Running theme-switch.sh macchiato (safe outside Hyprland)..."
bash "$DOTFILES/.config/waybar/scripts/theme-switch.sh" macchiato 2>/dev/null || true
info "theme initialized"

echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Done! Log out and back in, then:  uwsm start hyprland${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
