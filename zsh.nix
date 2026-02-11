{ config, pkgs, lib, ... }: {
  # Disable Home Manager's Zsh management to prevent it from generating
  # its own .zshrc, giving our symlink absolute priority.
  programs.zsh.enable = false;

  # Create out-of-store symlink for the shell configuration file.
  # We point specifically to 'dotfiles/zshrc' as requested.
  home.file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink "/home/qwerty/NixOSenv/dotfiles/zshrc";
  
  # Ensure .p10k.zsh is also linked if needed by the sourced file
  home.file.".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "/home/qwerty/NixOSenv/dotfiles/zsh/.p10k.zsh";
}
