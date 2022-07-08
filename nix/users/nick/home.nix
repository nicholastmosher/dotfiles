{ config, lib, pkgs, ... }:

{
  imports = [ ../common.nix ];

  programs.git = {
    enable = true;
    userEmail = "nicholastmosher@gmail.com";
    userName = "Nick Mosher";
    extraConfig = {
      safe.directory = "/home/nick/.dotfiles";
    };
  };
}
