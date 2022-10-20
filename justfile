alias b := build

build:
	@echo "[INFO] Rebuilding NixOS..."
	sudo nixos-rebuild switch --flake .#
