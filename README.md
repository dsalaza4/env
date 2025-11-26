# My MacOS machines as code

This repository aims to provide
full declarative configurations
for my MacOS machines.

## Base Features

- **System**: [Nix-darwin](https://github.com/LnL7/nix-darwin) for declarative MacOS configuration.
- **User Management**: [Home Manager](https://github.com/nix-community/home-manager) integration for user-specific packages and dotfiles.
- **Homebrew**: [nix-homebrew](https://github.com/zhaofengli/nix-homebrew) for declarative management of Casks and formulae.

## Prerequisites

- **macOS only**: This configuration is designed specifically for macOS (Darwin)
- **sudo access**: The installation requires administrator privileges
- **Fresh install recommended**: While this can be run on an existing system, it will modify system-level configurations

## Installation

Run this one-liner to automatically install everything:

```sh
curl -fsSL https://raw.githubusercontent.com/dsalaza4/env/main/install.sh | zsh -- <machine>
```

Where `<machine>` is the name of the machine you want to install. `personal` will be used by default.

This script will:
1. Install Determinate Nix (if not already installed)
2. Clone this repository to a temporary directory
3. Run the nix-darwin configuration to set up your system

## Usage

After installation, you can manage your system configuration using the included `justfile` commands:

### Available Commands

- **`just build [MACHINE]`** (or `just b [MACHINE]`): Rebuild the system configuration
  ```sh
  just build           # Rebuilds the personal machine (default)
  just build work      # Rebuilds the work machine
  ```
  Use this after making changes to your configuration files.

- **`just update`** (or `just u`): Update flake dependencies
  ```sh
  just update
  ```
  This updates all Nix flake inputs to their latest versions.

### Managing Multiple Machines

This repository supports multiple machine configurations under `machines/`:
- `machines/personal/` - Your personal machine (default)
- `machines/test/` - CI test configuration

To add a new machine:
1. Copy `machines/personal/` to `machines/<name>/`
2. Customize the configuration in `machines/<name>/`
3. Add a new `darwinConfigurations.<name>` entry in `flake.nix`
4. Build with `just build <name>`

### Making Changes

1. Edit configuration files in this repository
2. Run `just build` to apply changes (or `just build <machine>` for a specific machine)
3. Commit and push your changes to keep them synchronized

## Missing features

1. **Docker Desktop**: Not available via nixpkgs or homebrew.
