# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ../common.nix
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ZFS boot
  boot.supportedFilesystems = [ "zfs" ];
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };

  # Luks encrypted boot
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-id/ata-WDC_WD5000AAKX-75U6AA0_WD-WCC2ERN73182-part2";
      preLVM = true;
    };
  };

  networking.hostId = "ce93344e";
  networking.hostName = "dutchman"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  users.users.davyjones = {
    isNormalUser = true;
    home = "/home/davyjones";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      # From Thinkpad
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6iglH6WeI53TcNgdecGEN+5owDQvG59P2JlnASDnSXkkhWnz6+MqVJ4WVMj1UzEBeNwneS1xdpsa2lIWnbHYCwuS3edUeJe6CxQ4raN7mg4yg631/NUck9ajJKi/V29x2ShC+sCD10ZyQTwOv0RnFRmfEHwHRsfS8QKSJUZKbYnszi/yLTBN7wIt3N3Mabg8GvcAhsDw+VzoEZhCVzldoOCEFvit3/2MslH6DQg81z1SpCtz1bwdPL/Y3M1HN7vgBPrXjinHdQV/TxxiD/lqWBZStIYr2NKJbyO3zrhp4e+8flXfAyEFlP/wxPmB4tRWLy/G6bQzMDgO+hmuottaEilkK4ExnkM8Up+/zCQR6dMG+7nss/yHN6dYBnmnrVfKSlV6Krg9XnszUMB+pNOImFwJLjSCtkBwdB0RwwLGKk6UlHBq1+q6nlS/0kT8WZqtiDyAqcV+y37BpY3DVUARPTla6Ruzti25hWIMqMkUedhmIVBOjQrJdaUPQie24T7/GYhUjk4t94yVYjF4d/RTb/CovD41PhHw9pxrz6GK7mG7fwDt8i3YWVPfgRka3EQcKV3FU1tmBJj+pI6go4KyB+QxpNlFf62ioqCyBTq2K2TQhpP3K5jArVnmH3+Cw1Rx0PL6aRQJ0wdY/FxzZsln8qqtiTfQDD0u6ZwYUZHXKTQ== nicholastmosher@gmail.com - From Thinkpad"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}

