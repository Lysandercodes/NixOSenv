# NixOS & Home Manager Configuration

This repository contains the complete NixOS system and user environment configuration, managed via **Flakes** and **Home Manager**.

## ✨ Magical One-Command Setup

Run this single command on a fresh system to clone the repo, set up essential symlinks, and apply the configuration:

```bash
git clone https://github.com/Lysandercodes/NixOSenv.git ~/NixOSenv && ln -sf ~/NixOSenv/dotfiles/zshrc ~/.zshrc && mkdir -p ~/.config/autocommit && touch ~/.config/autocommit/secrets.env && cd ~/NixOSenv && git add . && sudo nixos-rebuild switch --flake .#nixos
```

## 🚀 Quick Start (Manual)

If you've already cloned the repo or prefer manual steps:

1.  **Symlink `.zshrc`** (Critical for priority and NixOS compatibility):
    ```bash
    ln -sf ~/NixOSenv/dotfiles/zshrc ~/.zshrc
    ```

2.  **Add all files to Git** (Flakes ignore untracked files!):
    ```bash
    git -C ~/NixOSenv add .
    ```

3.  **Apply the configuration**:
    ```bash
    sudo nixos-rebuild switch --flake ~/NixOSenv#nixos
    ```

## 🪄 Instant Rebuild & Sync Alias

Use the `nrs` alias to add all changes and rebuild the system in one go:
```bash
nrs
```
*(Defined in `dotfiles/zshrc`)*

## 📂 File Structure

| File / Directory        | Description                                                                        |
| :---------------------- | :--------------------------------------------------------------------------------- |
| **`flake.nix`**         | Entry point of the configuration. Defines inputs and user outputs.                 |
| **`configuration.nix`** | System-level settings (Kernel, network, global packages, services).                |
| **`home.nix`**          | Home Manager configuration for the regular user (`qwerty`).                        |
| **`home-root.nix`**     | Home Manager configuration for the `root` user.                                    |
| **`nvim.nix`**          | Shared Neovim module. Manages LSPs/tools and symlinks dotfiles.                    |
| **`zsh.nix`**           | Zsh module. **Disables HM Zsh management** to allow a direct symlink to dotfiles.  |
| **`kitty.nix`**         | Shared Kitty module. Symlinks `~/.config/kitty` from dotfiles.                     |
| **`dotfiles/`**         | **Source of Truth**. Contains physical Lua, Conf, and Zsh scripts.                 |
| **`dotfiles/zshrc`**    | The primary `.zshrc` source file (linked to `~/.zshrc`).                           |
| **`cachix.nix`**        | Binary cache configuration for faster builds.                                      |

## 🛠 Configuration Management Guide

### 1. Zsh Configuration (`zsh`)

Zsh is managed via a direct out-of-store symlink to ensure **absolute priority** and **instant effects**:

*   **Mechanism**: Home Manager's internal Zsh management is **disabled** (`programs.zsh.enable = false`) to prevent Nix-generated wrapper scripts from overriding your settings.
*   **Where**: `~/NixOSenv/dotfiles/zshrc`
*   **How to Update**: Edit `dotfiles/zshrc` directly.
*   **Apply Changes**: **Instant!** Restart your shell or run `source ~/.zshrc`.
*   **NixOS Compatibility**: The file includes a boilerplate at the top (`source /etc/zshrc`) to ensure Nix paths and completions work correctly while maintaining your priority.

### 2. Neovim Configuration (`nvim`)

Neovim follows a similar pattern to Zsh for maximum flexibility:

*   **External Tools (Nix Managed)**: 
    *   **Where**: `~/NixOSenv/nvim.nix`
    *   **What**: Language Servers (LSPs), Formatters, etc.
    *   **Apply**: `nrs`.
*   **Config & Plugins (Lua Hot-Reload)**:
    *   **Where**: `~/NixOSenv/dotfiles/nvim/`
    *   **Apply**: **Instant!** Restart Neovim or source the file.
    *   **Mechanism**: `nvim.nix` creates an out-of-store symlink from `~/.config/nvim` to `~/NixOSenv/dotfiles/nvim`.

### 3. Kitty Configuration (`kitty`)

*   **User Config (Hot-Reload)**:
    *   **Where**: `~/NixOSenv/dotfiles/kitty/`
    *   **Apply**: **Instant!** Reload Kitty (`Ctrl+Shift+F5`).

## 🔄 Automation: Auto-Git & Backup

This repository includes a system-level module (`modules/auto-git-nixosenv.nix`) that automates the backup process to GitHub.

*   **Auto-Commit**: A systemd unit watches `~/NixOSenv` and commits changes with a timestamp and file list.
*   **Auto-Push**: A timer pushes to GitHub every 10 minutes using a dedicated anonymous SSH key.

## 🤝 Shared Environment (User + Root)

This setup ensures that the `root` user shares the **exact same environment** as your regular user by symlinking to the same physical `dotfiles/` directory.

## ⚠️ Important Notes

-   **Git is Mandatory**: Nix Flakes will fail to find files that aren't tracked by Git. Use `nrs` to ensure everything is tracked before rebuilding.
-   **Manual Symlinks**: Upon first installation, ensure the `.zshrc` symlink is created manually or via the "Magical" command.
-   **Syncthing**: Managed as a system-level service. GUI accessed via [localhost:8384](http://localhost:8384).
