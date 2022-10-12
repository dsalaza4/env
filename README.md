# My NixOS machine as code

This repository aims to provide 
full declarative configurations
for my machine.

:warning: This is a work in progress. 
Significant architectural changes are likely to happen.

## Requirements

1. An `ext4` root partition with label `root` and mountpoint on `/`.
1. A `vfat` boot partition with label `ESP` and mountpoint on `/boot/efi`.

Additional information can be found in the 
[storage module](/modules/storage/default.nix)

## How to run

You can install the environment with

```
$ nix-shell
$ sudo nixos-rebuild switch --flake .#
```

## Inspiration

Special thanks to the following people
for being awesome:

1. [kamadorueda/machine](https://github.com/kamadorueda/machine)
1. [wiltaylor/dotfiles](https://github.com/wiltaylor/dotfiles)
1. [Wil T NixOS tutorials](https://www.youtube.com/playlist?list=PL-saUBvIJzOkjAw_vOac75v-x6EzNzZq-)