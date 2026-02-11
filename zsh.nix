{ config, pkgs, ... }: {
  # Symlink Zsh configuration
  # Note: Zsh binary is managed system-wide or via home.packages
  home.file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink "/home/qwerty/NixOSenv/dotfiles/zsh/.zshrc";
  home.file.".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "/home/qwerty/NixOSenv/dotfiles/zsh/.p10k.zsh";
}
