# NixOS & Home Manager Configuration

This repository contains the complete NixOS system and user environment configuration, managed via **Flakes** and **Home Manager**.

## 🚀 Quick Start (Reproduction)

To apply this configuration to a new or existing NixOS system:

1.  **Clone the repository** (if not already present):
    ```bash
    git clone <repo-url> ~/NixOSenv
    cd ~/NixOSenv
    ```

2.  **Add all files to Git** (Flakes ignore untracked files!):
    ```bash
    git add .
    ```

3.  **Apply the configuration**:
    ```bash
    sudo nixos-rebuild switch --flake .#nixos
    ```

## 📂 File Structure

| File / Directory | Description |
| :--- | :--- |
| **`flake.nix`** | Entry point of the configuration. Defines inputs and user outputs. |
| **`configuration.nix`** | System-level settings (Kernel, network, global packages, services). |
| **`home.nix`** | Home Manager configuration for the regular user (`qwerty`). |
| **`home-root.nix`** | Home Manager configuration for the `root` user. |
| **`nvim.nix`** | Shared Neovim module. Now includes support for **JS, Python, C/C++, Go, and Zsh**. |
| **`zsh.nix`** | Shared Zsh environment module (aliases, p10k). |
| **`kitty.nix`** | Shared Kitty terminal module. |
| **`dotfiles/`** | **Source of Truth**. Contains physical Lua, Conf, and Zsh scripts. |
| **`cachix.nix`** | Binary cache configuration for faster builds. |

## 🛠 Language Support Table

| Language | LSP | Linter | Formatter |
| :--- | :--- | :--- | :--- |
| **Go** | `gopls` | `golangci-lint` | `gofumpt` |
| **Python** | `pyright` | `ruff` | `ruff` |
| **JS / TS** | `ts_ls`, `eslint` | `eslint_d` | `prettier` |
| **C / C++** | `clangd` | `cppcheck` | `clang-format` |
| **Zsh / Bash**| `bashls` | `shellcheck` | `shfmt` |
| **Nix** | `nil_ls` | - | `nixfmt` |
| **Lua** | `lua_ls` | `selene` | `stylua` |
| **Markdown** | `marksman` | `markdownlint` | `prettier` |
| **YAML** | `yamlls` | `yamllint` | `yamlfmt` |

## 🛠 Working Workflow

### Editing App Configs (Instant Results)
Configurations for **Neovim, Zsh, and Kitty** are managed via "out-of-store" symlinks. This means you edit the files in `~/NixOSenv/dotfiles/` and the changes are **instant**.

- **Neovim**: `~/NixOSenv/dotfiles/nvim/`
- **Zsh**: `~/NixOSenv/dotfiles/zshrc` and `p10k.zsh`
- **Kitty**: `~/NixOSenv/dotfiles/kitty/`

You do **not** need to run `nixos-rebuild` for simple config/script changes in these directories.

### Modifying Nix Configuration
If you add a new package or change a system-level setting:
1.  Edit the relevant `.nix` file.
2.  Run `git add .` (Crucial!).
3.  Run `sudo nixos-rebuild switch --flake .#nixos`.

## 🤝 Shared Environment (User + Root)
This setup ensures that the `root` user (e.g., when running `sudo nvim`) shares the **exact same environment** as your regular user. Both accounts symlink their config to the same physical files in the `dotfiles/` directory.

## ⚠️ Important Notes
- **Git is Mandatory**: Nix Flakes will fail to find files that aren't tracked by Git. If you create a new file, `git add` it immediately.
- **Home Manager**: Both `qwerty` and `root` are managed through the Home Manager module inside the system configuration.
- **Syncthing**: This needs to be set up for your specific devices, you could modify configuration.nix to add your own device(s).
