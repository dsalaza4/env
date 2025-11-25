# My MacOS machine as code

This repository aims to provide
full declarative configurations
for my MacOS machine.

## Base Features

- **System**: [Nix-darwin](https://github.com/LnL7/nix-darwin) for declarative MacOS configuration.
- **User Management**: [Home Manager](https://github.com/nix-community/home-manager) integration for user-specific packages and dotfiles.
- **Homebrew**: [nix-homebrew](https://github.com/zhaofengli/nix-homebrew) for declarative management of Casks and formulae.
- **Security**: Touch ID enabled for `sudo` commands.
- **DNS**: Cloudflare is set as the system DNS.
- **Timezone**: Bogota, Colombia.

## Prerequisites

- **macOS only**: This configuration is designed specifically for macOS (Darwin)
- **sudo access**: The installation requires administrator privileges
- **Fresh install recommended**: While this can be run on an existing system, it will modify system-level configurations

## Installation

### Automated Installation (Recommended)

Run this one-liner to automatically install everything:

```sh
curl -fsSL https://raw.githubusercontent.com/dsalaza4/env/main/install.sh | zsh
```

This script will:
1. Install Determinate Nix (if not already installed)
2. Clone this repository to a temporary directory
3. Run the nix-darwin configuration to set up your system

### Manual Installation

If you prefer to install manually:

1. Install Determinate Nix:
   ```sh
   curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
   ```

2. Clone this repository:
   ```sh
   git clone https://github.com/dsalaza4/env.git
   cd env
   ```

3. Run the installation:
   ```sh
   sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#default
   ```

## Usage

After installation, you can manage your system configuration using the included `justfile` commands:

### Available Commands

- **`just build`** (or `just b`): Rebuild the system configuration
  ```sh
  just build
  ```
  Use this after making changes to your configuration files.

- **`just update`** (or `just u`): Update flake dependencies
  ```sh
  just update
  ```
  This updates all Nix flake inputs to their latest versions.

### Making Changes

1. Edit configuration files in this repository
2. Run `just build` to apply changes
3. Commit and push your changes to keep them synchronized

## Missing features

1. **Docker Desktop**: Not available via nixpkgs or homebrew.
