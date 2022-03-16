{
  system.autoUpgrade = {
    enable = true;
    flake = "github:nicholastmosher/dotfiles?dir=nix";
    dates = "*-*-* *:00:00"; # Update hourly. See `man systemd.time` for syntax
  };
}

