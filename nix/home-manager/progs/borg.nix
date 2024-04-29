{
  home = {
    location = {
      sourceDirectories = ["/etc/nixos" "/home/primary/.mozilla" "/home/primary/dotfiles" "/home/primary/.config" "/home/primary/Documents" "/home/primary/projects" "/home/primary/Pictures" "/home/primary/school" "/home/primary/.wallpaper.png" "/home/primary/misc" "/home/primary/.ssh" "/home/primary/justfile"];
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
      encryptionPasscommand = "cat /home/primary/misc/recovery_or_keys/borg_bak_pass";
    };
  };
}
