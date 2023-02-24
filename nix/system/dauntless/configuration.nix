{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      system = aarch64-darwin # M1 gang
      extra-platforms = aarch64-darwin x86_64-darwin # But we use rosetta too
      experimental-features = nix-command flakes
      build-users-group = nixbld
    '';
  };
  services.nix-daemon.enable = true;

  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;

  security.pam.enableSudoTouchIdAuth = true;

  users.users.nickmosher = {
    name = "nickmosher";
    home = "/Users/nickmosher";
  };
}
