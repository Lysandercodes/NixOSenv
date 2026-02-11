{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./cachix.nix
    ./modules/auto-git-nixosenv.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Locale & Time
  time.timeZone = "Africa/Cairo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.UTF-8";
  };

  # X11 / GNOME
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.xkb.layout = "us";

  # Audio (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # Users
  users.users.qwerty = {
    isNormalUser = true;
    description = "qwerty";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.zsh;
  };

  # Auto Login (GNOME)
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "qwerty";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Browsers
  programs.firefox.enable = true;

  # NVIDIA & Graphics
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    powerManagement.enable = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  # Experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Qt global wrapping
  qt.enable = true;

  # Allow unfree packages (NVIDIA driver requires it)
  nixpkgs.config.allowUnfree = true;

  # Packages
  environment.systemPackages = with pkgs; [
    # Core tools
    neovim
    marksman
    icu
    curl
    wget
    git
    gcc
    unzip
    cmake
    fd
    ripgrep
    androidenv.androidPkgs.platform-tools
    syncthing

    # Terminals
    gnome-terminal
    kitty
    alacritty
    foot

    # Python + PyQt6
    python3
    python313
    python313Packages.pip
    python313Packages.pyqt6
    python313Packages.matplotlib
    python313Packages.pyqtgraph
    python313Packages.plyer
    python313Packages.pyinstaller
    python313Packages.requests
    sqlite

    # Qt6
    qt6.qtbase
    qt6.qtwayland

    # Graphics & verification
    libGL
    mesa
    mesa-demos # provides glxinfo

    # Development tools
    go
    cargo
    gnumake42
    nodejs_24
    nodePackages.prettier
    prettierd
    lua
    luajit
    lua-language-server
    stylua
    nil
    shfmt
    gofumpt
    xclip
    inotify-tools
    imagemagick

    # Apps & utilities
    praat
    discord
    google-chrome
    tor-browser
    zapzap
    materialgram
    localsend
    yt-dlp
    ffmpeg
    wireshark
    dig
    krita
    anki
    encfs
    davinci-resolve
    pdfarranger
    kdePackages.okular
    pdfstudio2024
    gnome-keyring
    seahorse
    espeak
    speechd
    piper-tts
    ydotool
    wtype
    nextdns
    uv
    libreoffice

    # # Wine
    # wineWowPackages.stable
    # wine
    # (wine.override { wineBuild = "wine64"; })
    # wine64
    # wineWowPackages.staging
    # wineWowPackages.waylandFull
    # winetricks

    # nerd-fonts
    nerd-fonts.noto
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack

    # Containers
    flatpak
    appimage-run

    # Cursor-cli
    cursor-cli

    # cachix
    devenv
    cachix
    rsync
    beets
  ];

  services.flatpak.enable = true;
  xdg.portal.enable = true;
  # Power management
  services.tlp.enable = true;
  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 70;
    STOP_CHARGE_THRESH_BAT0 = 80;
  };
  services.power-profiles-daemon.enable = false;
  services.gnome.gnome-keyring.enable = false;

  # NextDNS
  services.nextdns = {
    enable = true;
    arguments = [
      "-config"
      "78326e"
      "-cache-size"
      "10MB"
    ];
  };

  # System version & extras
  system.stateVersion = "25.11";

  services.dbus.packages = [ pkgs.glib ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
  programs.nix-ld.enable = true;

  services.syncthing = {
    enable = true;
    user = "qwerty";
    group = "users";
    configDir = "/home/qwerty/.config/syncthing";
    dataDir = "/home/qwerty/.config/syncthing";

    openDefaultPorts = false;

    settings = {
      options = {
        globalAnnounceEnabled = false;
        localAnnounceEnabled = true;
        relaysEnabled = false;
        natEnabled = false;
      };
    };

    overrideDevices = true;

    # Devices: use a short name as key, real ID goes in .id
    settings.devices = {
      Friday = {
        id = "6GEMF6X-WBQUHOC-4NM2GSK-VHB4DSM-HDZKZQA-BGWMDUR-SIZNSB4-AEN6SQK";
        name = "Friday"; # optional, shows nicely in GUI
        addresses = [
          "tcp://192.168.1.2:22000" # your phone's local IP
        ];
      };
    };

    settings.folders = {
      "cxvn6-pfich" = {
        label = "Music";
        path = "~/Music";
        devices = [ "Friday" ];
        type = "sendreceive";
      };

      "h53c3-35tfw" = {
        label = "NixOS-config";
        path = "~/NixOSenv";
        devices = [ "Friday" ];
        type = "sendonly";
      };

      "kbq2u-oj5d5" = {
        label = "library";
        path = "~/Downloads/library";
        devices = [ "Friday" ];
        type = "sendreceive";
      };
    };
  };

  # Automatic cleanup
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 10";
  nix.settings.auto-optimise-store = true;
}
