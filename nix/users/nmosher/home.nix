{ config, lib, pkgs, ... }:

{
  imports = [ ../common.nix ];

  home.username = "nmosher";
  home.homeDirectory = "/home/nmosher";

  programs.git = {
    enable = true;
    userEmail = "nmosher@geisel-software.com";
    userName = "Nick Mosher";
  };
}
