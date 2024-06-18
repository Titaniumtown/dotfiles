update_all: system_update home_update sync_configs

format_home:
    nixfmt ~/.config/home-manager

format_system:
    doas nixfmt /etc/nixos

system_update:
    doas nix flake update /etc/nixos
    doas nixos-rebuild boot

home_update:
    nix flake update ~/.config/home-manager
    home-manager switch

sync_configs: format_home format_system
    rsync -a --delete /etc/nixos/ ~/dotfiles/nix/etcnixos/
    rsync -a --delete ~/.config/home-manager/ ~/dotfiles/nix/home-manager/
    cp ~/justfile ~/dotfiles/
