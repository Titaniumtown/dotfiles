update_all: system_update home_update sync_configs

system_update:
    doas alejandra -q /etc/nixos/*.nix
    doas nix flake update /etc/nixos
    doas nixos-rebuild boot --upgrade-all --impure

home_update:
    alejandra -q .config/home-manager/*.nix
    alejandra -q .config/home-manager/*.nix
    nix flake update .config/home-manager
    rm -rf ~/.gtkrc-2.0 || true
    home-manager switch

sync_configs:
    rsync -av --delete /etc/nixos/ ~/dotfiles/nix/etcnixos/
    rsync -av --delete ~/.config/home-manager/ ~/dotfiles/nix/home-manager/
    cp -v ~/justfile ~/dotfiles/
