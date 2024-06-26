# My Dotfiles ✨
These are my dotfiles for my laptop (which I use [NixOS](https://nixos.org/) on). I'm still working on porting more configs to [home-manager](https://github.com/nix-community/home-manager).

## Structure
The `nix` folder contains two sub directories, `etcnixos` and `home-manager`. The former is the contents of `/etc/nixos` (hence the name), whereas the latter is the contents of `~/.config/home-manager`.
`justfile` is the [just](https://github.com/casey/just) script I use for updating my nixOS system and syncing the changes with this repo.

## What do I use?
Browser: Firefox 🦊

Text Editor: [helix](https://github.com/helix-editor/helix)

Terminal: [alacritty](https://github.com/alacritty/alacritty)

Shell: [fish](https://fishshell.com/) with the [pure](https://github.com/pure-fish/pure) prompt

WM: [niri](https://github.com/YaLTeR/niri)

There is more that I'm using, but those are the main ones! Read my configs to get more into the specifics.
