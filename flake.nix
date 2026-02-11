{
  description =
    "NixOS config with Google Antigravity (agentic IDE) on unstable";

  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    aussprachetrainer.url = "github:m-amir-gomaa/aussprachetrainer";
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, fenix, nixpkgs, antigravity-nix, aussprachetrainer, home-manager, ... }: {
    packages.x86_64-linux = {
      default = fenix.packages.x86_64-linux.minimal.toolchain;
      autocommit = nixpkgs.legacyPackages.x86_64-linux.callPackage ./modules/autocommit-pkg.nix { };
    };
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./hardware-configuration.nix
        ./configuration.nix

        # Add Antigravity directly (no overlay → no pkgs scoping issue)
        {
          nixpkgs.config.allowUnfree = true;

          environment.systemPackages = [
            antigravity-nix.packages.x86_64-linux.default
            aussprachetrainer.packages.x86_64-linux.default
          ];
        }
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ 
            fenix.overlays.default 
            (final: prev: {
              autocommit = final.callPackage ./modules/autocommit-pkg.nix {};
            })
          ];
          environment.systemPackages = [
            (pkgs.fenix.complete.withComponents [
              "cargo"
              "clippy"
              "rust-src"
              "rustc"
              "rustfmt"
              "rust-docs" # I added this one
            ])
            pkgs.rust-analyzer-nightly
          ];
        })
        # Automatic flake-based upgrades
        {
          system.autoUpgrade = {
            enable = true;
            flake = self.outPath;

            flags = [
              "--update-input"
              "nixpkgs"
              "--update-input"
              "antigravity-nix"
              "--commit-lock-file"
              "-L"
            ];

            dates = "weekly";
            randomizedDelaySec = "45min";
            operation = "switch";
          };
        }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.qwerty = import ./home.nix;
          home-manager.users.root = import ./home-root.nix;
        }
      ];
    };
  };
}
