# NixOS & Home Manager Configuration

## Contents

### Table of contents

<!-- toc -->

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

    ```

    > [!TIP]
    > I recommend using **OpenRouter** (Free Tier) as shown above. It offers high-quality models (like Gemini Flash) for free, bypassing OpenAI quota limits.

## 🛰️ Syncthing Management

Syncthing is managed primarily via its **Web GUI**.

- **GUI Access**: [localhost:8384](http://localhost:8384)
- **Workflow**: Use the GUI to add devices and folders. The configuration is stored locally in `~/.config/syncthing` and will **persist** across reboots and Nix rebuilds.
- **Nix Configuration**: `configuration.nix` simply enables the service and ensures it runs under your user account with the correct data paths. It does **not** override your GUI settings.

### ⚠️ Troubleshooting

- **"Failed to acquire lock"**: This happens if a "ghost" Syncthing process is running under your user account.
  - **Fix**: Run `killall syncthing` and then `sudo systemctl restart syncthing`.

This setup ensures that the `root` user (e.g., when running `sudo nvim`) shares the **exact same environment** as your regular user. Both accounts symlink their config to the same physical files in the `dotfiles/` directory.

## ⚠️ Important Notes

- **Syncthing**: Managed as a system-level service. If you see "Failed to acquire lock" errors, it means a rogue user-level process is running. Kill it with `killall syncthing` and restart the system service.
- **Git is Mandatory**: Nix Flakes will fail to find files that aren't tracked by Git. If you create a new file, `git add` it immediately.
- **Home Manager**: Both `qwerty` and `root` are managed through the Home Manager module inside the system configuration.
- **Syncthing**: You have to set up your own device(s).
