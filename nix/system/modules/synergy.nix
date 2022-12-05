{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    synergy
  ];

  services.synergy.server = {
    enable = true;
    autoStart = true;
    tls.enable = true;
  };

  networking.firewall.allowedTCPPorts = [
    24800 # Synergy
  ];
}
