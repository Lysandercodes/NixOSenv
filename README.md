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

| File / Directory        | Description                                                                        |
| :---------------------- | :--------------------------------------------------------------------------------- |
| **`flake.nix`**         | Entry point of the configuration. Defines inputs and user outputs.                 |
| **`configuration.nix`** | System-level settings (Kernel, network, global packages, services).                |
| **`home.nix`**          | Home Manager configuration for the regular user (`qwerty`).                        |
| **`home-root.nix`**     | Home Manager configuration for the `root` user.                                    |
| **`nvim.nix`**          | Shared Neovim module. Contains Nix-managed plugins, LSPs, and tools.               |
| **`zsh.nix`**           | Shared Zsh module. Symlinks `.zshrc` and `.p10k.zsh` from dotfiles.                |
| **`kitty.nix`**         | Shared Kitty module. Symlinks `~/.config/kitty` from dotfiles.                     |
| **`dotfiles/`**         | **Source of Truth**. Contains physical Lua, Conf, and Zsh scripts.                 |
| **`cachix.nix`**        | Binary cache configuration for faster builds.                                      |

## 🛠 Configuration Management Guide

### 1. Neovim Configuration (`nvim`)

Neovim is managed in a hybrid way to offer both stability and flexibility:

*   **Plugins & Tools (Nix Managed)**:
    *   **Where**: `~/NixOSenv/nvim.nix`
    *   **What**: Language Servers (LSPs), Formatters, Linters, and Neovim Plugins.
    *   **How to Update**: Edit `nvim.nix` to add/remove packages.
    *   **Apply Changes**: Run `sudo nixos-rebuild switch --flake .#nixos`.

*   **User Config (Lua Hot-Reload)**:
    *   **Where**: `~/NixOSenv/dotfiles/nvim/`
    *   **What**: Keymaps, options, autocommands, and plugin settings (Lua code).
    *   **How to Update**: Edit files in `dotfiles/nvim/` directly.
    *   **Apply Changes**: **Instant!** Restart Neovim or source the file. No rebuild needed.
    *   **Mechanism**: `nvim.nix` creates an out-of-store symlink from `~/.config/nvim` to `~/NixOSenv/dotfiles/nvim`.

### 2. System Packages & Nix Settings

*   **System Packages**:
    *   **Where**: `~/NixOSenv/configuration.nix` (under `environment.systemPackages`).
    *   **How to Update**: Add package names to the list.
    *   **Apply Changes**: Run `sudo nixos-rebuild switch --flake .#nixos`.

*   **Flake Inputs**:
    *   **Where**: `~/NixOSenv/flake.nix`
    *   **How to Update**: Run `nix flake update` to update `flake.lock`.

### 3. Zsh & Kitty (Managed via Home Manager Symlinks)

**Zsh** and **Kitty** configurations are now symlinked by Home Manager to their source of truth in `~/NixOSenv/dotfiles/`.

*   **Zsh**:
    *   **Management File**: `~/NixOSenv/zsh.nix`
    *   **Source of Truth**: `~/NixOSenv/dotfiles/zsh/.zshrc` and `.p10k.zsh`
    *   **Target**: `~/.zshrc` and `~/.p10k.zsh` linked automatically.

*   **Kitty**:
    *   **Management File**: `~/NixOSenv/kitty.nix`
    *   **Source of Truth**: `~/NixOSenv/dotfiles/kitty/`
    *   **Target**: `~/.config/kitty/` linked automatically.

You can edit files in `dotfiles/zsh/` or `dotfiles/kitty/` and see changes instantly (hot-reload), just like with Neovim.

## 🤝 Shared Environment (User + Root)

This setup ensures that the `root` user (e.g., when running `sudo nvim`) shares the **exact same environment** as your regular user. Both accounts symlink their config to the same physical files in the `dotfiles/` directory.

## ⚠️ Important Notes

-   **Git is Mandatory**: Nix Flakes will fail to find files that aren't tracked by Git. If you create a new file, `git add` it immediately.
-   **Home Manager**: Both `qwerty` and `root` are managed through the Home Manager module inside the system configuration.
-   **Syncthing**: You have to set up your own device(s).

