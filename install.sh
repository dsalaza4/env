#!/usr/bin/env zsh
set -euo pipefail

echo "Starting installation..."

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo "Error: This script only works on macOS (Darwin)"
  exit 1
fi

echo "✓ Running on macOS"

# 1. Install Determinate Nix
if ! command -v nix &>/dev/null; then
  echo "Installing Determinate Nix..."
  if ! curl -fsSL https://install.determinate.systems/nix | sh -s -- install --no-confirm --determinate; then
    echo "Error: Failed to install Nix"
    exit 1
  fi

  # Source nix configuration for the current script execution
  if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
    . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
  fi

  # Verify Nix installation
  if ! command -v nix &>/dev/null; then
    echo "Error: Nix installation completed but nix command not found"
    echo "You may need to restart your shell and run this script again"
    exit 1
  fi

  echo "✓ Nix installed successfully"
else
  echo "✓ Nix is already installed"
fi

# 2. Download the repo zip from GitHub to a temporary dir
TEMP_DIR=$(mktemp -d)
# Trap to clean up temp dir on exit
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "Downloading repository from GitHub..."
if ! curl -fsSL https://github.com/dsalaza4/env/archive/refs/heads/main.zip -o "$TEMP_DIR/repo.zip"; then
  echo "Error: Failed to download repository"
  exit 1
fi

echo "Extracting repository..."
if ! unzip -q "$TEMP_DIR/repo.zip" -d "$TEMP_DIR"; then
  echo "Error: Failed to extract repository"
  exit 1
fi

echo "✓ Repository downloaded successfully"

# 3. cd's to it and runs installation
cd "$TEMP_DIR/env-main"

echo "Running nix-darwin installation..."
echo "Note: This will require sudo access and may take several minutes"
SYSTEM=${1:-personal}
if ! sudo --preserve-env=NIX_CONFIG nix run nix-darwin/master#darwin-rebuild -- switch --flake ".#${SYSTEM}"; then
  echo "Error: Installation failed"
  exit 1
fi

echo ""
echo "✓ Installation complete!"
echo ""
echo "Your macOS system has been configured. You may need to restart your terminal."
