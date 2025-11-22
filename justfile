build:
	@echo "[INFO] Rebuilding system..."
	sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#default

update:
  @echo "[INFO] Updating flake..."
  nix flake update

default: build

alias b := build
alias u := update
