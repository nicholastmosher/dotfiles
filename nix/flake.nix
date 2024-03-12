# Nix configuration flake heavily inspired/copied from github.com/nerosnm/config :thankyousoren:

{
  description = "Nix Configurations";

  nixConfig.extra-experimental-features = "nix-command flakes";
  nixConfig.extra-substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
  ];
  nixConfig.extra-trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  inputs = {
    # This is the release branch for NixOS 22.11, which is best to use for
    # system configurations for NixOS machines.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    # This branch of nixpkgs has newer versions of packages than `nixos-22.11`,
    # but is less likely to have cached binaries than other branches.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Absolute bleeding edge version of nixpkgs, not tested or cached yet.
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    # This branch of nixpkgs is more likely than `nixos-22.11` to have cached
    # binaries for Darwin platforms.
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";

    # Utility functions for writing flakes.
    flake-utils.url = "github:numtide/flake-utils/main";

    # Enables management of home directory files using Nix.
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Enables system-level configuration on Darwin platforms.
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";

    # Secrets management that avoids putting unencrypted secrets in the Nix
    # store.
    agenix.url = "github:ryantm/agenix/main";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "nixpkgs-darwin";

    helix.url = "github:helix-editor/helix";
    helix.inputs.nixpkgs.follows = "nixpkgs";
    helix.inputs.flake-utils.follows = "flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-darwin
    , nixpkgs-unstable
    , nixpkgs-master
    , flake-utils
    , nix-darwin
    , home-manager
    , agenix
    , helix
    , ...
    } @ inputs:
    let
      inherit (nixpkgs.lib) hasSuffix;
      inherit (flake-utils.lib) eachSystem;
      systems = flake-utils.lib.system;

      # The list of overlays that should be applied (first) to every import of
      # nixpkgs, regardless of which channel is being imported.
      baseOverlays = system: [
        (final: prev: {
          # ... ?
        })

        agenix.overlays.default
      ];

      # A function that imports the given `channel` (which should be a branch of
      # nixpkgs in the form of an input to this flake, like `nixpkgs` or
      # `nixpkgs-unstable`) for the system `system`, setting any necessary
      # config and applying the `upgradeOverlays` in the correct position
      # between the `baseOverlays` and the customisation overlays (`customPkgs`
      # and `overrides`).
      #
      # "Correct position" here refers to the convention for
      # overlay order in this flake: overlays should be applied in increasing
      # order of how much local control they exert over the package definitions.
      #
      # In other words:
      #
      # - Overlays defined in inputs are applied first because we have no
      #   control whatsoever over what the overlay does (and we would normally
      #   not want to mess with their inputs by applying other overlays before
      #   them).
      # - Then "upgrade overlays" should be applied, because they normally only
      #   pull packages from newer channels of nixpkgs, and don't do anything
      #   more, such as modifying the package definitions themselves. These
      #   should be applied in increasing order of how up-to-date the channel is
      #   that they pull packages from.
      # - Then overrides should be applied, because they modify package
      #   definitions by overriding their inputs or attributes.
      # - Finally, the custom packages overlay should be applied, because custom
      #   packages *completely replace* previous package definitions.
      #
      # This allows for some cool things, like upgrading the version of a
      # package first and then overriding its arguments separately later,
      # regardless of which version is being overridden.
      pkgsFor =
        { channel
        , system
        , upgradeOverlays ? [ ]
        }: import channel {
          inherit system;
          config.allowUnfree = true;
          overlays = (baseOverlays system) ++ upgradeOverlays;
        };

      # An overlay that picks packages from the flake inputs, regardless of the
      # channel this overlay is being applied to. This will be applied to all
      # channels, so that specific packages can be added or replaced with ones
      # from the flake inputs.
      upgradeToFromInput = system: _: _: nixpkgs.lib.genAttrs
        [
          "agenix"
          "helix"
          "home-manager"
        ]
        (name: inputs."${name}".packages."${system}".default);

      # A function that imports `nixpkgs-master` for the given system, with all
      # relevant upgrade overlays applied. In the case of `nixpkgs-master`, the
      # only relevant upgrade overlay is the `upgradeToFromInput` overlay, to
      # take packages directly from the flake inputs (any other upgrade overlays
      # would either cause infinite recursion or represent a *downgrade*
      # instead).
      masterFor = system: pkgsFor {
        channel = nixpkgs-master;
        inherit system;
        upgradeOverlays = [
          (upgradeToFromInput system)
        ];
      };

      # An overlay that picks packages from `master`, regardless of the channel
      # this overlay is being applied to. This will be applied to all channels
      # with packages older than the ones in `nixpkgs-master`, so that specific
      # packages can be upgraded to ones from master.
      upgradeToMaster = master: _: _: {
        inherit (master)
          bacon
          helix
          difftastic
          rust-analyzer-unwrapped
          ;
      };

      # A function that imports `nixpkgs-unstable` for the given system, with
      # all relevant upgrade overlays applied. In the case of
      # `nixpkgs-unstable`, the relevant upgrade overlays are
      # `upgradeWithMaster` (to upgrade any packages that are too old on
      # unstable to the ones from master), and `upgradeToFromInputs`.
      unstableFor = system: pkgsFor {
        channel = nixpkgs-unstable;
        inherit system;
        upgradeOverlays = [
          (upgradeToMaster (masterFor system))
          (upgradeToFromInput system)
        ];
      };

      # An overlay that picks packages from `unstable`, regardless of the
      # channel this overlay is being applied to. This will be applied to all
      # channels with packages older than the ones in `nixpkgs-unstable`, so
      # that specific packages can be upgraded to ones from unstable.
      upgradeToUnstable = unstable: _: _: {
        inherit (unstable)
          age-plugin-yubikey
          bat
          cachix
          cargo-about
          cargo-deny
          cargo-expand
          cargo-generate
          cargo-lints
          cargo-modules
          cargo-update
          cargo-watch
          erdtree
          fd
          git
          git-lfs
          grafana
          keybase
          nixpkgs-fmt
          openssh
          pounce
          rage
          rustup
          starship
          streamdeck-ui
          tailscale
          tectonic
          tempo
          udisks
          yubikey-manager
          ;
      };

      # If we're using Darwin, we should use the Darwin-specific version of
      # nixpkgs. Otherwise, use the release branch.
      selectStable = system:
        if (hasSuffix "-darwin" system)
        then nixpkgs-darwin
        else nixpkgs;

      # A function that imports the most relevant stable channel of nixpkgs for
      # the given system, with all relevant upgrade overlays applied. For stable
      # channels, the relevant upgrade overlays are `upgradeWithUnstable` (to
      # upgrade any packages that are too old on stable to the ones from
      # unstable), `upgradeWithMaster` and `upgradeToFromInput`.
      stableFor = system: pkgsFor {
        channel = (selectStable system);
        inherit system;
        upgradeOverlays = [
          (upgradeToUnstable (unstableFor system))
          (upgradeToMaster (masterFor system))
          (upgradeToFromInput system)
        ];
      };

      supportedSystems = with systems; [
        aarch64-darwin
        x86_64-darwin
        x86_64-linux
      ];

    in
      # Configs in this block are instantiated once per system
      (eachSystem supportedSystems (system:
        let
          pkgs = stableFor system;
        in {
          devShells = {
            default = pkgs.mkShell {
              name = "nicholastmosher/dotfiles";
              packages = [
                agenix
                home-manager
                # pkgs.age-plugin-yubikey
                # pkgs.deploy-rs
              ];
            };
          };

          homeConfigurations = {
            nick = inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                ./users/nick/home.nix
              ];
            };
          };

          nixosConfigurations = {
            thinkpad = nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                ./system/thinkpad/configuration.nix
              ];
            };
          };
        }

      # Configs in this block are instantiated just once
      )) // {
        darwinConfigurations = {
          # The Dauntless is the power in these waters, true enough...
          dauntless = 
          let
            system = "aarch64-darwin";
            pkgs = stableFor system;
          in
            nix-darwin.lib.darwinSystem {
              inherit system pkgs;
              modules = [
                ./system/dauntless/configuration.nix
                home-manager.darwinModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.nickmosher = import ./users/nickmosher/darwin.nix;
                }
              ];
            };

          # ... but there's no ship that can match the Interceptor for speed!
          interceptor = 
            let
              system = "aarch64-darwin";
              pkgs = stableFor system;
            in
              nix-darwin.lib.darwinSystem {
                inherit system pkgs;
                modules = [
                  ./system/interceptor/configuration.nix
                  home-manager.darwinModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.nick = import ./users/nick/darwin.nix;
                  }
                ];
              };
        };
      };
}
