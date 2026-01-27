{
  description =
    "NixOS config with Google Antigravity (agentic IDE) on unstable";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, antigravity-nix, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./hardware-configuration.nix
        ./configuration.nix

        # Add Antigravity directly (no overlay → no pkgs scoping issue)
        {
          nixpkgs.config.allowUnfree = true;

          environment.systemPackages =
            [ antigravity-nix.packages.x86_64-linux.default ];
        }

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
      ];
    };
  };
}
