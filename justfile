build:
	@echo "[INFO] Rebuilding NixOS..."
	sudo nixos-rebuild switch --flake .#

update:
  @echo "[INFO] Updating flake..."
  nix flake update

default: build

alias b := build
alias u := update
