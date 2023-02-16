{
  description = "NixOS Configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, darwin, ... }: {
    # Vanilla home-manager profiles
    homeManagerConfigurations = 
      let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
      in {
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

    # Darwin home-manager profiles
    darwinConfigurations."interceptor" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./system/interceptor/configuration.nix
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.nick = import ./users/nick/darwin.nix;
        }
      ];
    };

    nixosConfigurations = 
      let
        system = "x86_64-linux";
      in {
        thinkpad = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./system/thinkpad/configuration.nix
          ];
        };
      };
  };
}
