{ config, pkgs, ... }: {
  imports = [
    ./nvim.nix
    ./zsh.nix
    ./kitty.nix
  ];

  home.username = "qwerty";
  home.homeDirectory = "/home/qwerty";

  home.stateVersion = "25.11";

  home.sessionVariables = {
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
