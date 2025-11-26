machine := "personal"

build MACHINE=machine:
	@echo "[INFO] Rebuilding system for {{MACHINE}}..."
	sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#{{MACHINE}}

update:
  @echo "[INFO] Updating flake..."
  nix flake update

default: build

alias b := build
alias u := update
