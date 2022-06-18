# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ../common.nix
    # ../modules/sssd.nix
    ../modules/qemu.nix
    ../modules/virtualbox.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "black-pearl";
  services.sshd.enable = true;
  services.openssh.forwardX11 = true;
  services.xserver.videoDrivers = [ "nvidia" ];

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
    openssh.authorizedKeys.keys = [
      # From Thinkpad
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6iglH6WeI53TcNgdecGEN+5owDQvG59P2JlnASDnSXkkhWnz6+MqVJ4WVMj1UzEBeNwneS1xdpsa2lIWnbHYCwuS3edUeJe6CxQ4raN7mg4yg631/NUck9ajJKi/V29x2ShC+sCD10ZyQTwOv0RnFRmfEHwHRsfS8QKSJUZKbYnszi/yLTBN7wIt3N3Mabg8GvcAhsDw+VzoEZhCVzldoOCEFvit3/2MslH6DQg81z1SpCtz1bwdPL/Y3M1HN7vgBPrXjinHdQV/TxxiD/lqWBZStIYr2NKJbyO3zrhp4e+8flXfAyEFlP/wxPmB4tRWLy/G6bQzMDgO+hmuottaEilkK4ExnkM8Up+/zCQR6dMG+7nss/yHN6dYBnmnrVfKSlV6Krg9XnszUMB+pNOImFwJLjSCtkBwdB0RwwLGKk6UlHBq1+q6nlS/0kT8WZqtiDyAqcV+y37BpY3DVUARPTla6Ruzti25hWIMqMkUedhmIVBOjQrJdaUPQie24T7/GYhUjk4t94yVYjF4d/RTb/CovD41PhHw9pxrz6GK7mG7fwDt8i3YWVPfgRka3EQcKV3FU1tmBJj+pI6go4KyB+QxpNlFf62ioqCyBTq2K2TQhpP3K5jArVnmH3+Cw1Rx0PL6aRQJ0wdY/FxzZsln8qqtiTfQDD0u6ZwYUZHXKTQ== nicholastmosher@gmail.com - From Thinkpad"
    ];
  };
}

