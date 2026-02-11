{ config, pkgs, lib, ... }: {
  # Disable Home Manager's Zsh management to prevent it from generating
  # its own .zshrc, giving our symlink absolute priority.
  programs.zsh.enable = false;

  # Create out-of-store symlinks for the shell configuration files.
  # This matches the Neovim pattern and ensures changes are instant.
  home.file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink "/home/qwerty/NixOSenv/dotfiles/zsh/.zshrc";
  home.file.".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "/home/qwerty/NixOSenv/dotfiles/zsh/.p10k.zsh";
}
