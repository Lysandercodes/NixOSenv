{ config, pkgs, ... }:
{
  imports = [
    ./nvim.nix
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

  # ────────────────────────────────────────────────────────────────
  # Git configuration — declarative and reproducible
  # ────────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;

    userName = "m-amir-gomaa";
    userEmail = "mo.gomaa.formal@gmail.com";

    # Nice defaults (you can remove or change any of these)
    extraConfig = {
      init.defaultBranch = "main"; # modern default instead of master
      core.editor = "nvim"; # or "vim", "nano", etc. — optional
      # pull.rebase          = false;      # or true if you prefer rebase on pull
      # credential.helper    = "cache";    # or "store" / "osxkeychain" etc.
    };

    # Optional: enable delta (pretty diff viewer) if you like it
    # delta.enable = true;
  };
}
