# Terminal Setup

A portable macOS terminal development environment built around Ghostty, Zellij, Helix, and Yazi with a unified Catppuccin Mocha theme.

## What's Included

| Tool | Role | Config File(s) |
|------|------|-----------------|
| **Ghostty** | Terminal emulator | `ghostty/config` |
| **Zellij** | Terminal multiplexer (like tmux) | `zellij/config.kdl`, `zellij/layouts/dev.kdl` |
| **Helix** | Modal text editor (like vim) | `helix/config.toml`, `helix/languages.toml` |
| **Yazi** | Terminal file manager | `yazi/yazi.toml`, `yazi/keymap.toml`, `yazi/theme.toml`, `yazi/package.toml` |
| **Zsh** | Shell | `zsh/zshrc`, `zsh/zshenv`, `zsh/zprofile` |
| **Git** | Version control | `git/gitconfig`, `git/ignore` |
| **Oh My Posh** | Shell prompt (Cobalt2 theme) | Installed via Homebrew, configured in `zsh/zshrc` |
| **bat** | `cat` replacement with syntax highlighting | Installed via Homebrew, aliased in `zsh/zshrc` |

## Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/<your-username>/terminalSetup.git ~/Documents/terminalSetup

# 2. Run the installer
cd ~/Documents/terminalSetup
./install.sh

# 3. Open Ghostty and set the font to "MesloLGS Nerd Font" if not applied automatically

# 4. Start your dev environment
zellij --layout dev
```

## What the Install Script Does

The installer (`install.sh`) runs through 6 steps:

1. **Installs Homebrew** (if not already installed)
2. **Installs packages** via Homebrew:
   - CLI tools: `helix`, `zellij`, `yazi`, `oh-my-posh`, `bat`, `fzf`, `nvm`, `pyenv`, `graphite`
   - Casks: `ghostty`, `font-meslo-lg-nerd-font`
3. **Installs language tooling**:
   - Rust (via rustup)
   - Node.js v22 (via nvm)
   - Bun
   - Python 3.13 (via pyenv)
4. **Installs language servers** for Helix:
   - TypeScript, Tailwind CSS, ESLint, JSON, HTML, CSS, Bash, YAML (via Bun)
   - basedpyright, ruff (via pip)
   - postgres-language-server, terraform-ls (via Homebrew)
5. **Symlinks all config files** to their expected locations (backs up any existing configs)
6. **Installs the Yazi Catppuccin Mocha flavor**

## How Symlinks Work

The repo contains the real config files. The install script creates symlinks from where each app expects its config to the file in this repo:

```
This repo (real files)                  System (symlinks)
──────────────────────                  ─────────────────
terminalSetup/ghostty/config       -->  ~/.config/ghostty/config
terminalSetup/helix/config.toml    -->  ~/.config/helix/config.toml
terminalSetup/helix/languages.toml -->  ~/.config/helix/languages.toml
terminalSetup/zellij/config.kdl    -->  ~/.config/zellij/config.kdl
terminalSetup/zellij/layouts/dev.kdl -> ~/.config/zellij/layouts/dev.kdl
terminalSetup/yazi/yazi.toml       -->  ~/.config/yazi/yazi.toml
terminalSetup/yazi/keymap.toml     -->  ~/.config/yazi/keymap.toml
terminalSetup/yazi/theme.toml      -->  ~/.config/yazi/theme.toml
terminalSetup/yazi/package.toml    -->  ~/.config/yazi/package.toml
terminalSetup/zsh/zshrc            -->  ~/.zshrc
terminalSetup/zsh/zshenv           -->  ~/.zshenv
terminalSetup/zsh/zprofile         -->  ~/.zprofile
terminalSetup/git/gitconfig        -->  ~/.gitconfig
terminalSetup/git/ignore           -->  ~/.config/git/ignore
```

This means you edit configs in one place (this repo), changes are tracked by git, and the apps read them through the symlinks. If an existing config file is found, it gets renamed with a `.backup.<timestamp>` suffix before the symlink is created.

## Key Bindings

### Zellij

| Shortcut | Action |
|----------|--------|
| `Ctrl-t` | Tab mode (then `n` new, `x` close, `r` rename, `1-9` switch) |
| `Ctrl-p` | Pane mode (then `n` new, `d` down, `r` right, `x` close, `f` fullscreen) |
| `Ctrl-n` | Resize mode (then `h/j/k/l` to resize) |
| `Ctrl-h` | Move mode (then `h/j/k/l` to move panes) |
| `Ctrl-s` | Scroll mode |
| `Ctrl-o` | Session mode (then `w` session manager, `d` detach) |
| `Ctrl-b` | Tmux mode (familiar tmux-style bindings) |
| `Ctrl-g` | Lock/unlock mode |
| `Ctrl-q` | Quit |
| `Alt-h/j/k/l` | Move focus between panes (works in any mode) |
| `Alt-n` | New pane (works in any mode) |
| `Alt-f` | Toggle floating panes |

### Helix

| Shortcut | Action |
|----------|--------|
| `Space w` | Save file (replaces `Ctrl-s` taken by Zellij) |
| `Space q` | Quit |
| `Space x` | Save and quit |
| `Space Q` | Force quit |
| `Alt-o` | Jump backward (replaces `Ctrl-o`) |
| `Alt-b` | Page up (replaces `Ctrl-b`) |
| `Alt-s` | Save selection (replaces `Ctrl-s`) |

### Yazi

| Shortcut | Action |
|----------|--------|
| `f` | Search files by name (fd) |
| `F` | Search file contents (rg) |
| `.` | Toggle hidden files |
| `g p` | Go to project directory |
| `g h` | Go to home directory |
| `Enter` | Open file in Helix via Zellij pane |

## Dev Layout

Start with `zellij --layout dev` to get:

```
┌──────────────────────────────────────────────┐
│                   tab-bar                    │
├─────────────┬────────────────────────────────┤
│             │                                │
│   Yazi      │         Terminal (focused)     │
│   (35%)     │                                │
│             ├────────────────────────────────┤
│             │                                │
│             │         Terminal               │
│             │                                │
├─────────────┴────────────────────────────────┤
│                  status-bar                  │
└──────────────────────────────────────────────┘
```

A file manager on the left, and two stacked terminal panes on the right. Open files from Yazi and they appear as new Helix panes in Zellij.

## Post-Install Customization

After installing on a new machine, you may want to:

1. **Git signing key** -- Generate an SSH key and update `git/gitconfig` with your signing key path
2. **Yazi project shortcut** -- Update the `g p` shortcut in `yazi/keymap.toml` to point to your project directory
3. **Zellij dev layout** -- Update the Yazi `args` path in `zellij/layouts/dev.kdl` to your project directory
4. **Ghostty font size** -- Adjust `font-size` in `ghostty/config` to your preference
5. **Node version** -- The `.zshrc` loads nvm; install your preferred Node version with `nvm install <version>`

## Language Server Support

Helix is configured with LSP support for:

- **Rust** -- rust-analyzer (with Clippy integration)
- **TypeScript/JavaScript/TSX/JSX** -- typescript-language-server + ESLint + Tailwind CSS
- **Python** -- basedpyright + ruff (formatting & linting)
- **HTML/CSS** -- vscode language servers + Tailwind CSS
- **JSON/YAML** -- vscode-json + yaml-language-server
- **Bash** -- bash-language-server
- **SQL** -- postgres-language-server
- **Terraform/HCL** -- terraform-ls

All language server paths in `helix/languages.toml` use bare command names (e.g., `"rust-analyzer"` not `"/Users/jeffrey/.cargo/bin/rust-analyzer"`) so they resolve via `$PATH` on any machine.
