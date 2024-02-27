{ config, pkgs, ... }:

{
  home.username = "james";
  home.homeDirectory = "/home/james";
  home.stateVersion = "23.11"; # Value you should not be updated

  # Install packages into home environment
  home.packages = with pkgs; [
    # General
    alacritty 
    wget
    unzip
    killall
    ripgrep
    fzf
    gparted
    tldr
    nvd
    yazi
    #fish
    #starship
    #ollama
    #cudatoolkit

    # Web
    firefox
    floorp

    # Utility
    nethogs
    openrgb
    nh
    flameshot
    hyprshot
    distrobox
    #podman
    #jdk17
    openjdk11

    # Productivity
    libreoffice-qt
    hunspell
    hunspellDicts.en_US-large
    qalculate-qt
    thunderbird

    # Development
    git
    lazygit
    neofetch
    tree-sitter
    vscodium
    nodejs

    # Multimedia
    yt-dlp
    ffmpeg
    btop
    mpv
    handbrake
    stremio
    freetube

    # Gaming
    lutris
    heroic
    bottles
    protonup-qt
    openttd-jgrpp
    mangohud
    #openmw
    starsector
    wineWowPackages.stable
    #wineWowPackages.waylandFull
    winetricks
    
    # Creative
    obs-studio
    gimp
    inkscape
    obsidian
    fluidsynth
    freecad
    kicad

    # Social
    discord
    signal-desktop
    telegram-desktop

    # Wayland / Hyprland
    hyprpaper
    dolphin
    kitty
    wofi
    waybar
    mako

    # Finance
    tradingview

    # Theme

    # Overrides Example
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # Shell Script Example
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  programs.neovim = {
    enable = true;
    #extraConfig = ''
    #  set number relativenumber
    #  '';
    plugins = [
      #vimPlugins.nvim-treesitter
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ];
  };

  #gtk = {
  #  enable = true;
  #  theme = {
  #    name = "Juno";
  #    package = pkgs.juno-theme;
  #  };
  #  iconTheme = {
  #    name = "Papirus-Dark"; 
  #    package = pkgs.papirus-icon-theme;
  #  };
  #  cursorTheme = {
  #    name = "breeze_cursors";
  #  };
  #  gtk3.extraConfig = {
  #    Settings = ''
  #      gtk-application-prefer-dark-theme=1
  #    '';
  #  };
  #  gtk4.extraConfig = {
  #    Settings = ''
  #      gtk-application-prefer-dark-theme=1
  #    '';
  #  };
  #};

  #Gtk 
  #gtk = {
  #  enable = true;
  #  font.name = "TeX Gyre Adventor 10";
  #  theme = {
  #    name = "Juno";
  #    package = pkgs.juno-theme;
  #  };
  #  iconTheme = {
  #    name = "Papirus-Dark";
  #    package = pkgs.papirus-icon-theme;
  #  };
  #  cursorTheme = {
  #    name = "Bibata-Modern-Classic";
  #    package = pkgs.bibata-cursors;
  #  };
  #  
  #  #gtk2.extraConfig = {};

  #  gtk3.extraConfig = { 
  #    color-scheme = "prefer-dark";
  #    Settings = ''
  #      gtk-application-prefer-dark-theme=1
  #      gtk-cursor-theme-name=Bibata-Modern-Classic
  #      '';
  #  };

  #  gtk4.extraConfig = {
  #    color-scheme = "prefer-dark";
  #    Settings = ''
  #      gtk-application-prefer-dark-theme=1
  #      gtk-cursor-theme-name=Bibata-Modern-Classic
  #      '';
  #  };

  #};
  #gnome outside gnome
  #dconf = {
  #  enable = true;
  #  settings = {
  #    "org/gnome/desktop/interface" = {
  #      color-scheme = "prefer-dark";
  #      theme = "Juno";
  #    };
  #  };
  #};

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/james/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Enable bluetooth icon (requires blueman service in system config)
  services.blueman-applet.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
