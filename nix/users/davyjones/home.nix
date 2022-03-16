{ config, lib, pkgs, ... }:

{
  imports = [ ../common.nix ];

  home.username = "davyjones";
  home.homeDirectory = "/home/davyjones";

  programs.git = {
    enable = true;
    userEmail = "nicholastmosher@gmail.com";
    userName = "Nick Mosher";
  };
}
