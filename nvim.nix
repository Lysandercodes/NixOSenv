{ config, pkgs, ... }:
{
  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      # LSPs and Formatters (replacing Mason)
      gopls
      nodePackages.vscode-langservers-extracted # html, css, json, eslint
      nodePackages.typescript-language-server
      yaml-language-server
      nil # nix lsp
      bash-language-server
      pyright
      stylua
      shellcheck
      delve
      gofumpt
      shfmt
      markdownlint-cli2
      selene
      golangci-lint
      yamllint
      htmlhint
      marksman
      clang-tools # clangd, clang-format
      ruff # python lint/format
      black # python format
      isort # python import sort
      nodePackages.prettier # js/ts/md format
      nodePackages.eslint_d # js/ts lint
      nixfmt-rfc-style # nix format
      cppcheck # c++ lint
      icu
    ];
  };

  # Manage Neovim config directory
  # Note: pointing to the absolute path in qwerty's home to keep configs in sync
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "/home/qwerty/NixOSenv/dotfiles/nvim";
}
