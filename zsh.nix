{ config, pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;
    
    # We use initContent to source our "hot-reloadable" .zshrc from dotfiles.
    # We use lib.mkAfter to ensure this is the very last thing in the generated .zshrc
    initContent = lib.mkAfter ''
      source /home/qwerty/NixOSenv/dotfiles/zsh/.zshrc
    '';

    # Completion is fine, but we disable these two because they are loaded 
    # via oh-my-zsh plugins in the sourced .zshrc above.
    enableCompletion = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;
  };

  # Symlink .p10k.zsh to home so the sourced .zshrc can find it easily
  home.file.".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "/home/qwerty/NixOSenv/dotfiles/zsh/.p10k.zsh";
}
