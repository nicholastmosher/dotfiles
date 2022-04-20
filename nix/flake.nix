{
  description = "NixOS Configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
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

  in rec {
    lib = {
      systemCommon = pkgs.callPackage ./system/common.nix {};
      homeCommon = pkgs.callPackage ./users/common.nix {};
    };

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

      davyjones = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "davyjones";
        homeDirectory = "/home/davyjones";
        configuration = {
          imports = [
            ./users/davyjones/home.nix
          ];
        };
      };

      nmosher = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "nmosher";
        homeDirectory = "/home/nmosher";
        configuration = {
          imports = [
            ./users/nmosher/home.nix
          ];
        };
      };
    };

    nixosConfigurations = {
      thinkpad = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./system/thinkpad/configuration.nix
        ];
      };

      dutchman = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./system/dutchman/configuration.nix
        ];
      };

      black-pearl = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./system/black-pearl/configuration.nix
        ];
      };
    };
  };
}
