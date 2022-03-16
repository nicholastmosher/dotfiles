{ config, lib, pkgs, ... }:

{
  imports = [ ../common.nix ];

  programs.git = {
    enable = true;
    userEmail = "nmosher@geisel-software.com";
    userName = "Nick Mosher";
  };
}
