# modules/fuzzy

A home-manager module for in-terminal code navigation — fuzzy file browsing, live code search, and syntax-highlighted git diffs, all auto-themed to your macOS appearance.

## Commands

### `ff [query]`

Fuzzy file finder. Opens empty — type to load and filter files, select to open in `bat`.
With a query, pre-checks for matches before opening; exits with a message if none found.

```sh
ff          # open empty, type to browse
ff file.txt # pre-filter — exits if no match, else opens with query pre-filled
```

<img width="700" alt="ff demo" src="./demos/ff.gif">

### `fs [query]`

Live string search. Opens empty — type to search via `ripgrep` interactively, select to open
the file at the matched line. With a query, pre-checks for matches before opening.

```sh
fs       # open empty, type to search
fs text  # pre-check — exits if no match, else opens with query pre-filled
```

<img width="700" alt="fs demo" src="./demos/fs.gif">

### `git diff` (and friends)

`delta` is wired as `git`'s pager automatically. All diff output gets syntax highlighting,
line numbers, and word-level diff markers — no extra commands needed.

```sh
git diff
git diff HEAD~1
git show
git log -p
```

<img width="700" alt="git show demo" src="./demos/git-show.gif">

## Install

Add this repo as a flake input:

```nix
inputs.env = {
  url = "github:dsalazar/env";
  inputs.nixpkgs.follows = "nixpkgs";
  inputs.home-manager.follows = "home-manager";
};
```

Wire the module:

```nix
{ home-manager.sharedModules = [ inputs.env.homeManagerModules.fuzzy ]; }
```

Then in your home-manager user config:

```nix
programs.fuzzy.enable = true;
```

## Options

| option | type | default | description |
|---|---|---|---|
| `enable` | bool | false | enable the module |
| `theme.bat.dark` | str | `"Catppuccin Mocha"` | bat theme in dark mode |
| `theme.bat.light` | str | `"Catppuccin Latte"` | bat theme in light mode |
| `theme.delta.dark` | str | `"Catppuccin Mocha"` | delta theme in dark mode |
| `theme.delta.light` | str | `"Catppuccin Latte"` | delta theme in light mode |
| `ff.enable` | bool | true | enable `ff` binary |
| `fs.enable` | bool | true | enable `fs` live search binary |

Any of the underlying tools can be tuned via native [HM options](https://nix-community.github.io/home-manager/options.xhtml) alongside `programs.fuzzy`:

```nix
programs.bat.config.style = "numbers,changes";
programs.delta.options = { line-numbers = true; };
programs.fzf.defaultOptions = [ "--height 50%" "--layout=reverse" ];
```

## Themes

macOS system appearance is detected automatically — set a dark and light variant for each tool:

```sh
bat --list-themes
delta --list-syntax-themes
```

## Tools

| tool | role |
|---|---|
| [bat](https://github.com/sharkdp/bat) | syntax-highlighted file viewer (`cat` replacement), used by `ff` and `fs` |
| [delta](https://github.com/dandavison/delta) | diff pager, auto-wired as `git`'s pager |
| [fzf](https://github.com/junegunn/fzf) | interactive finder, powers `ff` and `fs` |
| [fd](https://github.com/sharkdp/fd) | fast file traversal, drives `ff` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | fast code search, drives `fs` |
