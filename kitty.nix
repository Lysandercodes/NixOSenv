{ config, pkgs, ... }: {
  # Symlink Kitty configuration
  # Note: Kitty binary is managed system-wide
  xdg.configFile."kitty".source = config.lib.file.mkOutOfStoreSymlink "/home/qwerty/NixOSenv/dotfiles/kitty";
}
