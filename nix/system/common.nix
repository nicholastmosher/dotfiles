# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
#
# Common configuration options available to all machines.

{ config, pkgs, lib, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use unstable Nix with Flakes
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports = [
    ./modules/docker.nix
    ./modules/gpg.nix
    # ./modules/update.nix
    ./modules/x11.nix
  ];

  # Networking
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;
  networking.networkmanager.enable = true;

  # Keybase
  services.keybase.enable = true;
  services.kbfs.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    dig
    vim
    git
    wget
    file
    tmux
    docker
    nodejs
    rustup
    awscli2
    firefox
    kubectl
    ripgrep
    clang_12
    minikube
    obsidian
    starship
    alacritty
    keybase-gui
    openconnect
    appimage-run
    jetbrains.clion
    jetbrains.idea-ultimate
    gnome.gnome-tweaks
    gnomeExtensions.vertical-overview
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}

