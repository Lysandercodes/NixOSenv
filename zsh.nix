{ config, pkgs, ... }: {
  # Zsh configuration
  home.file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink "/home/qwerty/NixOSenv/dotfiles/zshrc";
  home.file.".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "/home/qwerty/NixOSenv/dotfiles/p10k.zsh";
}
