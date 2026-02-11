{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    
    # We use initExtra to source our "hot-reloadable" .zshrc from dotfiles.
    # This matches the pattern of managing the tool via Nix but the config via symlinks.
    initContent = ''
      source /home/qwerty/NixOSenv/dotfiles/zsh/.zshrc
    '';

    # Optional: HM can still handle these, and they will be integrated into the final .zshrc
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Symlink .p10k.zsh to home so the sourced .zshrc can find it easily
  home.file.".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "/home/qwerty/NixOSenv/dotfiles/zsh/.p10k.zsh";
}
