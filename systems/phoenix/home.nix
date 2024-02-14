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

    # Utility
    nethogs
    openrgb

    # Development
    git
    lazygit
    neovim
    neofetch
    tree-sitter
    vscodium

    # Multimedia
    yt-dlp
    ffmpeg
    btop
    mpv
    handbrake
    stremio

    # Gaming
    lutris
    heroic
    bottles
    protonup-qt
    openttd-jgrpp
    mangohud
    #openmw
    starsector
    
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

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
