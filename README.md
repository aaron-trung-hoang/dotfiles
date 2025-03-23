# Dotfiles Repository

## Introduction

👋 Hi everyone, I'm Anthony Hoang Quoc Trung. Welcome to my dotfiles repository!

This repository contains my dotfiles that can be installed on various operating systems including Ubuntu 🐧, Windows WSL 🪟, and macOS 🍎. With this repo, I can configure my new local development environment with ease and in a declarative way.

If you are using Windows, please install WSL (with Ubuntu). Be adventurous!

### Supported Platforms

The dotfiles in this repository are designed to work on the following platforms:

- Ubuntu 🐧
- Windows WSL 🪟
- macOS 🍎

## How to use

### Prerequisites

Before you begin, ensure you have met the following requirements:

- You have a working internet connection 🌐.
- For macOS, install *HomeBrew* 🍺 - my preferred package manager for Mac.
- You have cloned this repository and opened a terminal in this repo.
- You have basic knowledge of the command line interface 💻.

### Installation

Run these commands (I tried to make the script as smooth as possible 😢 but the installation
of oh-my-zsh always interrupts the process, please re run the commands again))

```zsh
chmod +x ./main.sh
./main.sh # this requires you to enter your platform
```

And that's all.

## Governance

### For Ubuntu

- **Dotfiles**: Modify files like `wezterm`, `tmux`, `p10k`, `zshenv`, and `zshrc` directly in the dotfiles directory.
- **VSCode Settings**: Modify settings directly in the IDE, then copy the updated files to the `vscode` directory within the dotfiles.

```zsh
# TODO: add vscode copy command here
```

- **Packages**: Install packages via CLI using `apt` or `snap`, and update the corresponding files in the `ubuntu` directory.

### For macOS

- **Dotfiles**: Modify files like `wezterm`, `tmux`, `p10k`, `zshenv`, and `zshrc` directly in the dotfiles directory.
- **VSCode Settings**: Modify settings directly in the IDE, then copy the updated files to the `vscode` directory within the dotfiles.

```zsh
cp ~/Library/Application\ Support/Code/User/keybindings.json ./vscode/keybindings.json
cp ~/Library/Application\ Support/Code/User/settings.json ./vscode/settings.json
```

- **Packages**: Install packages using `brew`, then dump the Brewfile and copy it to the `macos` directory. Use the following command to update the Brewfile:

```zsh
# For brew
brew bundle dump --file=./macos/Brewfile --force
```

## Features

This repository includes the following features:

- Platform-specific packages and tools like git, curl, awscli...
- ZShell with auto suggestions, auto completion, powerlevel10k.
- Aliases for all utilities.
- Tmux configuration for terminal multiplexing.
- Wezterm configuration.
- And much more!

## Disclaimer

Please note that these configurations are tailored to my personal preferences. Feel free to modify them to suit your needs.

## Configuration

To configure this repository for your usage, here are some tips:

### Folder structure

```text
.
├── install_common.sh
├── LICENSE
├── macos-brew
├── main.sh
├── README.md
├── scripts
│   └── docker-install.sh
├── tmux
│   ├── .tmux.conf
├── ubuntu
│   ├── apt_packages
│   ├── install_packages.sh
│   ├── out_of_apt_packages.md
│   └── snap_apps
├── wezterm
│   ├── .wezterm.lua
├── zsh
│   ├── .zshrc
│   ├── .zshenv
└── └── .p10k.zsh
```

- Platform tools and packages:
  - Ubuntu directory:
    - `apt_packages`: packages installed using apt
    - `snap_apps`: apps installed using snap
    - `out_of_apt_packages.md`: readme file for tools and packages installed manually
  - macOS-Brew:
        - (Add details here)
- Configuration directories (wezterm, tmux, zsh):
  - Wezterm configuration folder: contains the dotfile to configure wezterm
  - Zsh configuration: contains the dotfile to configure zshrc file, p10k zsh file
  - Tmux: contains the dotfile for tmux - a terminal multiplexer that I use

## Contributing

Feel free to contribute to this repository by submitting pull requests or opening issues. Your feedback and contributions are highly appreciated!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

Thanks to all the open-source projects and contributors that make this possible.
