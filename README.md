# Dotfiles

Personal dotfiles for macOS, Ubuntu, and WSL.

## Supported platforms

- macOS
- Ubuntu
- WSL (Ubuntu)

## What this repo manages

- Shell: `zsh/.zshrc`, `zsh/.zshenv`, `zsh/.p10k.zsh`, `zsh/.zshrc.codex`
- Terminal: `tmux/.tmux.conf`, `wezterm/.wezterm.lua`, `wezterm/README.md`
- Git: `git/.gitconfig`
- VS Code: `vscode/settings.json`, `vscode/keybindings.json`
- Package sets:
  - macOS: `macos/Brewfile`
  - Ubuntu/WSL: `ubuntu/apt_packages`, `ubuntu/snap_apps`

## Installation

Run from the repository root:

```bash
chmod +x ./main.sh
./main.sh
```

`main.sh` auto-detects platform and runs:

- platform package installer (`macos/install_packages.sh` or `ubuntu/install_packages.sh`)
- common setup (`install_common.sh`)

`install_common.sh` will:

- install Oh My Zsh and zsh plugins if missing
- stow dotfiles from `zsh`, `tmux`, `wezterm`, `git`
- set up VS Code config symlinks
- copy `background/terminal.jpg` for WezTerm

## Update workflows

### VS Code settings

Pull current local VS Code user settings into this repo:

```bash
./scripts/update_vscode.sh
```

Note: if VS Code files are already symlinked to this repo, the script skips copying (no-op).

### macOS Brewfile

Regenerate the tracked Brewfile from currently installed packages:

```bash
./scripts/update_macos.sh
```

### Ubuntu package lists

Update these files manually when you add/remove packages:

- `ubuntu/apt_packages`
- `ubuntu/snap_apps`
- `ubuntu/out_of_apt_packages.md`

## Directory layout

```text
.
├── aerospace/
├── background/
├── claude/
├── git/
├── install_common.sh
├── lib/
├── macos/
├── main.sh
├── scripts/
├── tmux/
├── ubuntu/
├── vscode/
├── wezterm/
└── zsh/
```

## Notes

These are personal preferences. Adjust as needed before using on another machine.
