{
  home = {
    location = {
      sourceDirectories = ["/etc/nixos" "/home/primary/.librewolf" "/home/primary/dotfiles" "/home/primary/.config" "/home/primary/Documents" "/home/primary/projects" "/home/primary/Pictures" "/home/primary/school" "/home/primary/.wallpaper.png" "/home/primary/.ssh" "/home/primary/justfile" "/home/primary/.local/share/fish" "/home/primary/.gnupg"];
      excludeHomeManagerSymlinks = true;

      repositories = [
        "ssh://server-public/mnt/bak/laptop"
      ];
    };

    retention = {
      keepHourly = 48;
      keepDaily = 30;
      keepWeekly = 26;
      keepMonthly = 24;
      keepYearly = 10;
    };

    storage = {
      #super secret password location (maybe I should find a way to store secrets properly)
      encryptionPasscommand = "cat /home/primary/Documents/secrets/borg_bak_pass";
    };
  };
}
