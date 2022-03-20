{ pkgs, ... }:
{
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    gnupg
    pinentry
  ];
}

