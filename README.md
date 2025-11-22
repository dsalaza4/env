# My MacOS machine as code

This repository aims to provide
full declarative configurations
for my MacOS machine.

:warning: This is a work in progress.
Significant architectural changes are likely to happen.

## Base Features

- **System**: [Nix-darwin](https://github.com/LnL7/nix-darwin) for declarative MacOS configuration.
- **User Management**: [Home Manager](https://github.com/nix-community/home-manager) integration for user-specific packages and dotfiles.
- **Security**: Touch ID enabled for `sudo` commands.
- **DNS**: Cloudflare is set as the system DNS.
- **Timezone**: Bogota, Colombia.

## Requirements

Install Determinate Nix:

   ```sh
   curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
   ```

## Installation

Run the following command while standing in repo:

   ```sh
   sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#default
   ```