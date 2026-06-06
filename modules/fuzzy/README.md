# modules/fuzzy

A Nix home-manager module for in-terminal code review. Wraps [bat](https://github.com/sharkdp/bat), [delta](https://github.com/dandavison/delta), [fzf](https://github.com/junegunn/fzf), [fd](https://github.com/sharkdp/fd), and [ripgrep](https://github.com/BurntSushi/ripgrep) into a cohesive setup that lets you read diffs, navigate files, and search code without leaving the terminal — reducing context switching and keeping you focused on one terminal per workspace.

## Tools

| tool | what it does |
|---|---|
| [bat](https://github.com/sharkdp/bat) | syntax-highlighted file viewer, replaces `cat` |
| [delta](https://github.com/dandavison/delta) | syntax-highlighted diff viewer, wired as `git` pager |
| [fzf](https://github.com/junegunn/fzf) | interactive fuzzy finder, powers `ff` and `fs` |
| [fd](https://github.com/sharkdp/fd) | fast file finder, used as fzf's default source |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | fast code search, used by `fs` |

## Wire up

### Internal (same repo)

In `flake.nix`, add to each `darwinSystem` that needs it:

```nix
{ home-manager.sharedModules = [ ./modules/fuzzy ]; }
```

### External (separate flake)

Add this repo as a flake input:

```nix
inputs.env = {
  url = "github:dsalazar/env";
  inputs.nixpkgs.follows = "nixpkgs";
  inputs.home-manager.follows = "home-manager";
};
```

Then wire the module:

```nix
{ home-manager.sharedModules = [ inputs.env.homeManagerModules.fuzzy ]; }
```

## Enable

In your home-manager user config:

```nix
programs.fuzzy.enable = true;
```

## Options

| option | type | default | description |
|---|---|---|---|
| `enable` | bool | false | enable the module |
| `theme.bat.dark` | str | `"Monokai Extended"` | bat theme in dark mode |
| `theme.bat.light` | str | `"Monokai Extended Light"` | bat theme in light mode |
| `theme.delta.dark` | str | `"Monokai Extended"` | delta theme in dark mode |
| `theme.delta.light` | str | `"Monokai Extended Light"` | delta theme in light mode |
| `ff.enable` | bool | true | enable `ff` shell function |
| `fs.enable` | bool | true | enable `fs` shell function |

## Themes

`bat` and `delta` can each use any theme available in their respective theme sets. macOS system appearance is detected automatically — set a dark and light variant for each.

```sh
bat --list-themes
delta --list-syntax-themes
```

## What gets installed

- `bat` and `delta` — wrapped with macOS dark/light theme detection via `BAT_THEME`
- `fd` and `ripgrep` — used by `ff` and `fs`
- `fzf` — wired with zsh integration, `fd` as default command

Configure these tools directly via native [HM options](https://nix-community.github.io/home-manager/options.xhtml) alongside `programs.fuzzy`:

```nix
programs.fuzzy.enable = true;

programs.bat.config = {
  color = "always";
  style = "numbers,changes";
};
programs.delta.enableGitIntegration = true;
programs.delta.options = { line-numbers = true; };
programs.fzf.defaultOptions = [ "--height 50%" "--layout=reverse" ];
programs.ripgrep.arguments = [ "--ignore-case" ];
```

## Commands

### `git diff` (and friends)

When `programs.delta.enableGitIntegration = true`, `delta` is wired as `git`'s pager automatically. All diff output gets syntax highlighting, line numbers, and word-level diff markers — no extra commands needed.

```sh
git diff
git diff HEAD~1
git show
git log -p
```

### `ff [query]`

Fuzzy file finder. Searches files in the current directory, opens the selected file in `bat`.

```sh
ff                    # browse all files
ff primary.nix        # pre-filter by name
```

### `fs <pattern>`

Fuzzy string search. Runs `ripgrep`, lets you pick a match, opens the file at the matched line.

```sh
fs fn main
fs TODO
```
