# My NixOS machine as code

This repository aims to provide
full declarative configurations
for my machine.

:warning: This is a work in progress.
Significant architectural changes are likely to happen.

## How it looks

### Background

![background](/static/background.png)

### Browser

![browser](/static/browser.png)

### Workspace

![workspace](/static/workspace.png)

## Requirements

1. An `ext4` root partition with label `root` and mountpoint on `/`.
1. A `vfat` boot partition with label `ESP` and mountpoint on `/boot/efi`.

Additional information can be found in the
[storage module](/modules/storage/default.nix)

## How to run

You can install the environment with

```
$ nix-shell
$ just b
```

## Inspiration

Special thanks to the following people
for being awesome:

1. [adi1090x/rofi](https://github.com/adi1090x/rofi)
1. [alternateved/nixos-config](https://github.com/alternateved/nixos-config)
1. [jralvarezc/conf](https://github.com/jralvarezc/conf/tree/master/hosts/profiles)
1. [kamadorueda/machine](https://github.com/kamadorueda/machine)
1. [lokesh-krishna/dotfiles](https://github.com/lokesh-krishna/dotfiles)
1. [theCode-Breaker/riverwm](https://github.com/theCode-Breaker/riverwm)
1. [wiltaylor/dotfiles](https://github.com/wiltaylor/dotfiles)
1. [Wil T NixOS tutorials](https://www.youtube.com/playlist?list=PL-saUBvIJzOkjAw_vOac75v-x6EzNzZq-)
