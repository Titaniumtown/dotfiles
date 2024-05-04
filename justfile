update_all: system_update home_update sync_configs

format_home:
    alejandra -q .config/home-manager

format_system:
    doas alejandra -q /etc/nixos

system_update:
    doas nix flake update /etc/nixos
    doas nixos-rebuild boot --upgrade-all --impure

home_update:
    nix flake update .config/home-manager
    rm -rf ~/.gtkrc-2.0 || true
    home-manager switch

sync_configs: format_home format_system
    rsync -a --delete /etc/nixos/ ~/dotfiles/nix/etcnixos/
    rsync -a --delete ~/.config/home-manager/ ~/dotfiles/nix/home-manager/
    cp ~/justfile ~/dotfiles/
