# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ../common.nix
    ../modules/virtualbox.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "thinkpad";
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    openconnect
    google-chrome
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nick = {
    isNormalUser = true;
    home = "/home/nick";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };
}

