{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    dotfiles.url = "github:nicholastmosher/dotfiles?dir=nix&ref=modular";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, home-manager, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        homeCommon = inputs.dotfiles.lib.homeCommon;
        systemCommon = inputs.dotfiles.lib.systemCommon;
      in rec {
        nixosConfigurations = {
          nixos = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              (import systemCommon)
            ];
          };
        };

        homeManagerConfigurations = {
          user = home-manager.lib.homeManagerConfiguration {
            inherit system;
            username = "user";
            homeDirectory = "/home/user";
            configuration = {
              imports = [
                (import homeCommon)
              ];
            };
          };
        };
      });
}
