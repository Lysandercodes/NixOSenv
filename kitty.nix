{ config, pkgs, ... }: {
  # Kitty configuration
  xdg.configFile."kitty".source = config.lib.file.mkOutOfStoreSymlink "/home/qwerty/NixOSenv/dotfiles/kitty";
}
