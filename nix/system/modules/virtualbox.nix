{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vagrant
  ];
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "nmosher" ];
}

