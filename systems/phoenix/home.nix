{ config, pkgs, pkgs-unstable, open-webui, ... }:

{
  home.username = "james";
  home.homeDirectory = "/home/james";
  home.stateVersion = "24.05"; # Value should not be updated

  # Install packages into home environment
  home.packages = [
    # General
    pkgs.alacritty
    pkgs.fish
    pkgs.neofetch

    # Web
    #pkgs.firefox

    # AI
    #(pkgs-unstable.ollama.override { acceleration = "cuda"; })
    (pkgs.ollama.override { acceleration = "cuda"; })
    #pkgs-unstable.ollama
    #pkgs-unstable.cudaPackages.cudatoolkit
    #pkgs-unstable.cudaPackages.cudnn
    pkgs-unstable.open-webui

    # Utility
    pkgs-unstable.borgbackup
    pkgs-unstable.btop
    pkgs.flameshot
    pkgs.fzf
    pkgs.gparted
    pkgs.killall
    pkgs-unstable.kopia
    pkgs.nethogs
    pkgs.nmap
    pkgs-unstable.p7zip
    pkgs-unstable.ncdu
    pkgs-unstable.nh
    pkgs-unstable.openrgb
    pkgs-unstable.restic
    pkgs-unstable.tldr
    pkgs-unstable.motrix
    pkgs-unstable.nvd
    pkgs.ripgrep
    pkgs.starship
    pkgs-unstable.uget
    pkgs.unrar
    pkgs.unzip
    pkgs.yazi

    # Productivity
    pkgs.hunspell
    pkgs.hunspellDicts.en_US-large
    pkgs.libreoffice-qt
    pkgs-unstable.logseq
    pkgs.qalculate-qt
    pkgs-unstable.thunderbird

    # Development
    pkgs-unstable.bruno
    pkgs-unstable.dbeaver-bin
    pkgs-unstable.gh
    pkgs-unstable.godot_4
    pkgs-unstable.godot_4-export-templates
    pkgs-unstable.jq
    pkgs-unstable.lazygit
    pkgs.nodejs
    pkgs.tree-sitter
    pkgs-unstable.vscodium
    pkgs.websocat
    pkgs.dpkg

    # Multimedia
    pkgs-unstable.ffmpeg-full
    #pkgs.freetube
    pkgs-unstable.handbrake
    pkgs-unstable.mpv
    pkgs-unstable.spotube
    pkgs-unstable.stremio
    pkgs-unstable.yt-dlp
    
    # Creative
    pkgs.fluidsynth
    pkgs-unstable.freecad
    pkgs-unstable.gimp
    pkgs-unstable.inkscape
    #pkgs.kicad
    pkgs-unstable.obs-studio
    pkgs-unstable.obsidian

    # Gaming
    pkgs-unstable.goverlay
    pkgs-unstable.heroic
    pkgs-unstable.lutris
    pkgs-unstable.mangohud
    ##pkgs-unstable.openmw
    # pkgs-unstable.openttd
    pkgs-unstable.openttd-jgrpp
    pkgs-unstable.prismlauncher
    pkgs.protonup-qt
    pkgs-unstable.starsector

    # # Gaming Emulation
    # (pkgs-unstable.retroarch.override {
    #   cores = with libretro; [
    #     #NES
    #     fceumm
    #     mesen
    #     # fceux
    #     #SNES
    #     snes9x
    #     #GBOY/COLOR
    #     gambatte
    #     #GENESIS
    #     genesis-plus-gx
    #     #32X
    #     picodrive
    #     #2600
    #     stella
    #     #5200
    #     atari800
    #     #7800
    #     prosystem
    #     #GAMEGEAR
    #     smsplus-gx
    #     #NINTENDOD DS
    #     melonds
    #   ];
    # })

    # Virtualization / Emulation
    pkgs-unstable.bottles
    pkgs-unstable.distrobox
    #pkgs-unstable.podman
    pkgs-unstable.winetricks
    pkgs-unstable.wineWowPackages.stable
    #pkgs-unstable.wineWowPackages.waylandFull

    # Social
    pkgs-unstable.chatterino2
    #pkgs.discord
    pkgs-unstable.signal-desktop
    pkgs-unstable.telegram-desktop
    pkgs-unstable.vesktop

    # Finance
    #pkgs.ib-tws
    pkgs-unstable.tradingview
    #pkgs.jetbrains.jdk

    ## Wayland / Hyprland
    pkgs-unstable.hyprshot
    pkgs-unstable.hyprpaper
    pkgs-unstable.dolphin
    pkgs-unstable.kitty
    pkgs-unstable.wofi
    pkgs-unstable.waybar
    pkgs-unstable.mako

    # Gnome
    pkgs-unstable.gnome-extension-manager
    # Overrides Example
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # Shell Script Example
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  programs.firefox = {
    enable = true;
    #profiles.default = {
    #  id = 0;
    #  name = "default";
    #  isDefault = true;
    #  settings = {
    #    "extensions.formautofill.creditCards.enabled" = false;
    #    "dom.payments.defaults.saveAddress" = false;
    #    "extensions.pocket.enabled" = false;
    #    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    #    "layout.css.color-mix.enabled" = true;
    #    "media.ffmpeg.vaapi.enabled" = true;
    #    "cookiebanners.ui.desktop.enabled" = true;
    #    "devtools.command-button-screenshot.enabled" = true;
    #  };
    #};
  };

  programs.git = {
    enable = true;
    #package = pkgs.git;
    userName = "James Mowery";
    userEmail = "jmowery@gmail.com";
  };

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


  programs.tmux = {
    enable = true;
    shortcut = "b";
    # aggressiveResize = true; -- Disabled to be iTerm-friendly
    baseIndex = 1;
    newSession = true;
    # Stop tmux+escape craziness.
    escapeTime = 0;
    # Force tmux to use /tmp for sockets (WSL2 compat)
    secureSocket = false;

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
    ];

    extraConfig = ''
      # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      # Mouse works as expected
      set-option -g mouse on
      # easy-to-remember split pane commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
    '';
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
  # gtk = {
  #   enable = true;
  #   font.name = "TeX Gyre Adventor 10";
  #   theme = {
  #     name = "Juno";
  #     package = pkgs.juno-theme;
  #   };
  #   iconTheme = {
  #     name = "Papirus-Dark";
  #     package = pkgs.papirus-icon-theme;
  #   };
  #   cursorTheme = {
  #     name = "Bibata-Modern-Classic";
  #     package = pkgs.bibata-cursors;
  #   };
    
  #   #gtk2.extraConfig = {};

  #   gtk3.extraConfig = { 
  #     color-scheme = "prefer-dark";
  #     Settings = ''
  #       gtk-application-prefer-dark-theme=1
  #       gtk-cursor-theme-name=Bibata-Modern-Classic
  #       '';
  #   };

  #   gtk4.extraConfig = {
  #     color-scheme = "prefer-dark";
  #     Settings = ''
  #       gtk-application-prefer-dark-theme=1
  #       gtk-cursor-theme-name=Bibata-Modern-Classic
  #       '';
  #   };
  # };
  
  #gnome outside gnome
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        theme = "Juno";
      };
    };
  };

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
