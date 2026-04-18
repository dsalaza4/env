# env

Declarative macOS configuration using [nix-darwin](https://github.com/nix-darwin/nix-darwin) and [Home Manager](https://github.com/nix-community/home-manager).

## Machines

| Name | Description |
|------|-------------|
| `personal` | Personal machine (default) |
| `work` | Work machine |
| `test` | CI test configuration |

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/dsalaza4/env/main/install.sh | zsh -s -- <machine>
```

Omit `<machine>` to default to `personal`. The script installs [Determinate Nix](https://determinate.systems/nix/) if needed, clones this repo, and applies the configuration.

## Usage

```sh
just build          # Rebuild personal (default)
just build work     # Rebuild work machine
just update         # Update all flake inputs
```

## What's configured

- **Shell**: zsh with Oh My Zsh, autosuggestions, syntax highlighting, and Starship prompt
- **Terminal**: Ghostty with FiraCode Nerd Font, GitHub Dark theme, and custom keybindings
- **Editor**: Zed set as default for plain text and source code
- **System**: macOS defaults (Dock, Finder, key repeat), Cloudflare DNS, Touch ID for sudo
- **Security**: 1Password GUI
- **Dev tools**: direnv + nix-direnv, git with per-machine identity

## Structure

```
machines/
  personal/
    system/        # macOS system defaults
    users/         # Home Manager user config
    package-managers/
  work/            # Same layout, work identity
  test/            # Minimal CI config
flake.nix          # Flake inputs and darwinConfigurations
justfile           # Build commands
install.sh         # Bootstrap script
```

## Known gaps

- **Docker Desktop**: not managed as code
