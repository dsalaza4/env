#!/usr/bin/env zsh
set -euo pipefail

echo "Running installation via curl (installing test config)..."
curl -fsSL https://raw.githubusercontent.com/${GITHUB_REPOSITORY}/${GITHUB_REF_NAME}/install.sh | zsh -s -- test

# Source nix configuration for the current script execution
if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
  . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi

echo "Verifying Nix installation..."
if ! command -v nix &> /dev/null; then
  echo "❌ Nix not found"
  exit 1
fi
echo "✓ Nix is installed"
nix --version

echo "Verifying just is available..."
if ! command -v just &> /dev/null; then
  echo "❌ just not found"
  exit 1
fi
echo "✓ just is installed"
just --version

echo "Checking nix-darwin configuration..."
if [ ! -d "/run/current-system" ]; then
  echo "❌ nix-darwin system not found"
  exit 1
fi
echo "✓ nix-darwin system is configured"
