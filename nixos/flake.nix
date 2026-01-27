{
  description = "NixOS config with Antigravity";

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

        # Temporarily comment out or remove any custom Neovim blocks here
        # { ... your modules ... }

        {
          nixpkgs.config.allowUnfree = true;
          environment.systemPackages =
            [ antigravity-nix.packages.x86_64-linux.default ];
        }
      ];
    };
  };
}
