{ pkgs, ... }:
{
  enable = true;

  interactiveShellInit = ''
    set fish_greeting # Disable greeting

    #fixes gnupg password entry
    export GPG_TTY=(tty)
    pfetch
  '';

  shellAliases = {
    c = "cargo";
    cr = "cargo run";
    cb = "cargo build";

    # from DistroTube's dot files: Changing "ls" to "eza"
    ls = "eza -al --color=always --group-directories-first";
    la = "eza -a --color=always --group-directories-first";
    ll = "eza -l --color=always --group-directories-first";
    lt = "eza -aT --color=always --group-directories-first";

    # gets the largest files in a git repo's history
    "git-size" = ''
      git rev-list --objects --all |
              git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
              sed -n 's/^blob //p' |
              sort --numeric-sort --key=2 |
              cut -c 1-12,41- |
              numfmt --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest'';

    #aliases for (I think) macos commands
    pbcopy = "wl-copy";
    pbpaste = "wl-paste";
  };

  shellInit = ''
    fish_add_path ~/.local/bin
    fish_add_path ~/.cargo/bin
    set hydro_color_pwd 62A
    set hydro_color_error red
    set hydro_color_duration yellow
    set hydro_color_prompt green
    set hydro_color_git blue
  '';

  plugins = [
    {
      name = "hydro";
      src = pkgs.fishPlugins.hydro.src;
    }
  ];
}
