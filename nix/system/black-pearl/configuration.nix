# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "black-pearl";
  services.sshd.enable = true;
  services.openssh.forwardX11 = true;

  environment.systemPackages = with pkgs; [
    awscli2
    docker
    kubectl
    minikube
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nmosher = {
    isNormalUser = true;
    home = "/home/nmosher";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };
}

