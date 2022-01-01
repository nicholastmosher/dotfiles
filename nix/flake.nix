{
  description = "NixOS Configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-20.09";
    home-manager.url = "github:nix-community/home-manager/release-20.09";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };

    lib = nixpkgs.lib;

  in {
    homeManagerConfigurations = {
      nick = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "nick";
        homeDirectory = "/home/nick";
        configuration = {
          imports = [
            ./users/nick/home.nix
          ];
        };
      };
    };

    nixosConfigurations = {
      thinkpad = lib.nixosSystem {
        inherit system;

        modules = [
          ./system/configuration.nix
        ];
      };
    };
  };
}
