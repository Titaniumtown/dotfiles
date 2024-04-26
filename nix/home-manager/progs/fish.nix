{pkgs, ...}: {
  enable = true;
  /*
  interactiveShellInit = ''
    #set fish_greeting # Disable greeting
    fastfetch
  '';
  */

  shellAliases = {
    c = "cargo";
    cr = "cargo run";
    cb = "cargo build";

    # from DistroTube's dot files: Changing "ls" to "eza"
    ls = "eza -al --color=always --group-directories-first";
    la = "eza -a --color=always --group-directories-first";
    ll = "eza -l --color=always --group-directories-first";
    lt = "eza -aT --color=always --group-directories-first";

    #aliases for (I think) macos commands
    pbcopy = "wl-copy";
    pbpaste = "wl-paste";
  };

  shellInit = ''
    fish_add_path ~/.local/bin
    fish_add_path ~/.cargo/bin
  '';

  plugins = [
    {
      name = "pure";
      src = pkgs.fishPlugins.pure.src;
    }
  ];
}