#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Terminal Setup Installer ==="
echo "Source: $DOTFILES_DIR"
echo ""

# ── Step 1: Install Homebrew ─────────────────────────────────
if ! command -v brew &> /dev/null; then
    echo "[1/6] Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "[1/6] Homebrew already installed, skipping."
fi

# ── Step 2: Install packages ────────────────────────────────
echo "[2/6] Installing Homebrew packages..."
brew install helix zellij yazi oh-my-posh bat fzf nvm pyenv graphite
brew install --cask ghostty font-meslo-lg-nerd-font

# ── Step 3: Install language tooling ────────────────────────
echo "[3/6] Installing language tooling..."

# Rust
if ! command -v rustup &> /dev/null; then
    echo "  Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "  Rust already installed, skipping."
fi

# Node via nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
if ! command -v node &> /dev/null; then
    echo "  Installing Node 22 via nvm..."
    nvm install 22
else
    echo "  Node already installed ($(node -v)), skipping."
fi

# Bun
if ! command -v bun &> /dev/null; then
    echo "  Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
    export PATH="$HOME/.bun/bin:$PATH"
else
    echo "  Bun already installed, skipping."
fi

# Python via pyenv
if ! pyenv versions --bare | grep -q "3.13"; then
    echo "  Installing Python 3.13 via pyenv..."
    pyenv install 3.13
    pyenv global 3.13
else
    echo "  Python 3.13 already installed, skipping."
fi

# ── Step 4: Install language servers ────────────────────────
echo "[4/6] Installing language servers..."
bun install -g typescript-language-server typescript \
    @tailwindcss/language-server \
    vscode-langservers-extracted \
    bash-language-server \
    yaml-language-server

pip install basedpyright ruff
brew install postgres-language-server terraform-ls 2>/dev/null || true

# ── Step 5: Symlink config files ────────────────────────────
echo "[5/6] Symlinking config files..."

link_file() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        local backup="${dest}.backup.$(date +%s)"
        echo "  Backing up existing $dest -> $backup"
        mv "$dest" "$backup"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
    echo "  Linked $dest -> $src"
}

# Ghostty
link_file "$DOTFILES_DIR/ghostty/config"         "$HOME/.config/ghostty/config"

# Helix
link_file "$DOTFILES_DIR/helix/config.toml"     "$HOME/.config/helix/config.toml"
link_file "$DOTFILES_DIR/helix/languages.toml"   "$HOME/.config/helix/languages.toml"

# Zellij
link_file "$DOTFILES_DIR/zellij/config.kdl"      "$HOME/.config/zellij/config.kdl"
link_file "$DOTFILES_DIR/zellij/layouts/dev.kdl"  "$HOME/.config/zellij/layouts/dev.kdl"

# Yazi
link_file "$DOTFILES_DIR/yazi/yazi.toml"         "$HOME/.config/yazi/yazi.toml"
link_file "$DOTFILES_DIR/yazi/keymap.toml"       "$HOME/.config/yazi/keymap.toml"
link_file "$DOTFILES_DIR/yazi/theme.toml"        "$HOME/.config/yazi/theme.toml"
link_file "$DOTFILES_DIR/yazi/package.toml"      "$HOME/.config/yazi/package.toml"

# Zsh
link_file "$DOTFILES_DIR/zsh/zshrc"              "$HOME/.zshrc"
link_file "$DOTFILES_DIR/zsh/zshenv"             "$HOME/.zshenv"
link_file "$DOTFILES_DIR/zsh/zprofile"           "$HOME/.zprofile"

# Git
link_file "$DOTFILES_DIR/git/gitconfig"          "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/git/ignore"             "$HOME/.config/git/ignore"

# ── Step 6: Install Yazi flavor ─────────────────────────────
echo "[6/6] Installing Yazi catppuccin-mocha flavor..."
if command -v ya &> /dev/null; then
    ya pack -i
else
    echo "  'ya' not found, install Yazi flavor manually with: ya pack -i"
fi

echo ""
echo "=== Done! ==="
echo ""
echo "Next steps:"
echo "  1. Open a new terminal (or run: source ~/.zshrc)"
echo "  2. Set your terminal font to 'MesloLGS Nerd Font'"
echo "  3. Start Zellij with: zellij"
echo "  4. Use the dev layout with: zellij --layout dev"
echo "  5. Update git signing key in ~/.gitconfig for the new machine"
echo "  6. Update the yazi 'gp' shortcut in yazi/keymap.toml to your project path"
