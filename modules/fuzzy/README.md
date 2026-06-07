# modules/fuzzy

In-terminal code navigation built around short-lived pickers —
run a command, select, return to the shell.
Covers fuzzy file browsing, live code search, and syntax-highlighted git diffs,
all auto-themed to your macOS appearance.

## Commands

### `ff [query]`

Fuzzy file finder.
Opens empty — type to load and filter files, select to open in `bat`.
With a query, pre-checks for matches before opening;
exits with a message if none found.

```sh
ff          # open empty, type to browse
ff file.txt # pre-filter — exits if no match, else opens with query pre-filled
```

<img width="700" alt="ff demo" src="./demos/ff.gif">

### `fs [query]`

Live string search.
Opens empty — type to search via `ripgrep` interactively,
select to open the file at the matched line.
With a query, pre-checks for matches before opening.

```sh
fs       # open empty, type to search
fs text  # pre-check — exits if no match, else opens with query pre-filled
```

<img width="700" alt="fs demo" src="./demos/fs.gif">

### `git diff` (and friends)

`delta` is wired as `git`'s pager automatically.
All diff output gets syntax highlighting, line numbers, and word-level diff markers —
no extra commands needed.

```sh
git diff
git diff HEAD~1
git show
git log -p
```

<img width="700" alt="git show demo" src="./demos/git-show.gif">

## Install

### Standalone

```sh
nix profile install github:dsalazar/env#fuzzy
```

Two integrations need a one-time manual setup:

```sh
# wire delta as git's pager
git config --global core.pager delta

# wire fzf shell key bindings (adjust path for your shell / package manager)
echo 'source "$(fzf-share)/key-bindings.zsh"' >> ~/.zshrc
```

Themes default to `Catppuccin Mocha` (dark) and `Catppuccin Latte` (light).
Override per-tool via env vars in your shell profile:

```sh
export FUZZY_BAT_DARK_THEME="Dracula"
export FUZZY_BAT_LIGHT_THEME="GitHub"
export FUZZY_DELTA_DARK_THEME="Dracula"
export FUZZY_DELTA_LIGHT_THEME="GitHub"
```

### With Home Manager

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

Then in your Home Manager user config:

```nix
programs.fuzzy.enable = true;
```

#### Options

| option | type | default | description |
|---|---|---|---|
| `enable` | bool | false | enable the module |
| `theme.bat.dark` | str | `"Catppuccin Mocha"` | bat theme in dark mode |
| `theme.bat.light` | str | `"Catppuccin Latte"` | bat theme in light mode |
| `theme.delta.dark` | str | `"Catppuccin Mocha"` | delta theme in dark mode |
| `theme.delta.light` | str | `"Catppuccin Latte"` | delta theme in light mode |
| `ff.enable` | bool | true | enable `ff` binary |
| `fs.enable` | bool | true | enable `fs` live search binary |

Any of the underlying tools can be tuned via native [Home Manager options](https://nix-community.github.io/home-manager/options.xhtml)
alongside `programs.fuzzy`:

```nix
programs.bat.config.style = "numbers,changes";
programs.delta.options = { line-numbers = true; };
programs.fzf.defaultOptions = [ "--height 50%" "--layout=reverse" ];
```

## Themes

macOS system appearance is detected automatically —
set a dark and light variant for each tool:

```sh
bat --list-themes
delta --list-syntax-themes
```

## Alternatives

The design philosophy is **short-lived pickers over long-lived TUIs** —
each command exits after selection and returns you to the shell.
No app to quit, no mode to escape.

### Long-lived TUIs — yazi, broot, lazygit, tig

These tools need to stay open to be useful,
which means a dedicated terminal pane or window sacrificed permanently to the tool —
multiplied across every workspace you have open.
The workflow becomes: switch to the pane, navigate inside the UI, switch back.
Close the pane to reclaim the space and you lose navigation state and have to relaunch.

### Short-lived TUIs — television, forgit

Same lifecycle as fuzzy: launch, pick, exit, back at the prompt.
No screen space claimed between invocations.

**[television](https://github.com/alexpasmantier/television)** covers `ff` and `fs`
with built-in file and text-search channels (`tv files`, `tv text`).
The difference is in the details:
`ff` opens empty and lazy-loads on first keypress — `tv files` starts scanning immediately.
With a query argument, `ff`/`fs` pre-check for matches and exit with a message if none found;
`tv` has no equivalent.
After selection, `ff`/`fs` open the result in `bat` with full syntax highlighting and,
for `fs`, scroll to the exact matched line;
`tv` hands the path to `$EDITOR`.
Theming in `tv` is static;
fuzzy wraps `bat` and `delta` to track macOS system appearance.

**[forgit](https://github.com/wfxr/forgit)** is the git complement —
fzf pickers for interactive staging (`ga`), branch checkout (`gco`),
log browsing (`glo`), and diff review (`gd`).
It covers git interactive actions that fuzzy doesn't:
fuzzy's `delta` integration enhances the output of standard git commands
without changing how you invoke them;
forgit adds a picker layer on top for cases where you want to browse before acting.
The two are complementary rather than competing.

## Tools

| tool | role |
|---|---|
| [bat](https://github.com/sharkdp/bat) | syntax-highlighted file viewer (`cat` replacement), used by `ff` and `fs` |
| [delta](https://github.com/dandavison/delta) | diff pager, auto-wired as `git`'s pager |
| [fzf](https://github.com/junegunn/fzf) | interactive finder, powers `ff` and `fs` |
| [fd](https://github.com/sharkdp/fd) | fast file traversal, drives `ff` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | fast code search, drives `fs` |
