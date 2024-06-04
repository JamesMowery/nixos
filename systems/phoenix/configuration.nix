{ config, lib, pkgs, pkgs-unstable, inputs, systemSettings, userSettings, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos/boot/systemd-boot.nix
      (./. + "../../../modules/nixos/wm" + ("/" + userSettings.display) + ".nix")
      (./. + "../../../modules/nixos/wm" + ("/" + userSettings.wm) + ".nix")
      inputs.home-manager.nixosModules.default
    ];

  #nixpkgs.config.allowUnfree = true;	# Enable Unfree

  # FLAKES
  ############################################################
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # KERNEL
  ############################################################
  boot.kernelPackages = pkgs-unstable.linuxPackages_latest;

  # TIMEZONE/LOCALE
  ############################################################
  time.timeZone = "America/Phoenix";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # NETWORK
  ############################################################
  networking.hostName = "phoenix"; 	   # Define your hostname.
  networking.networkmanager.enable = true; # Use networkmanager
  #networking.firewall.allowedTCPPorts = [ 6742 ];

  # ELECTRON FIX
  ############################################################
  #nixpkgs.config.permittedInsecurePackages = [
  #  "electron-25.9.0"
  #];

  # APP IMAGE SUPPORT
  ############################################################
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  # VIRTUALIZATION
  ############################################################
  virtualisation.docker = {
    enable = true; 
    storageDriver = "btrfs";
  };

  #virtualisation.docker.rootless = {
  #  enable = true;
  #  setSocketVariable = true;
  #  #storageDriver = "btrfs";
  #};

  ############################################################
  # GPU/GRAPHICS
  ############################################################
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = [
      pkgs-unstable.mangohud
      pkgs-unstable.vaapiVdpau
      pkgs-unstable.libvdpau-va-gl
    ];
    #extraPackages32 = with pkgs; [mangohud];
  };

  # Load nvidia driver for Xorg and Wayland
  #services.xserver.videoDrivers = ["nvidia"];

  # Nvidia Options
  hardware.nvidia = {
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;
    # Enable the Nvidia settings menu,
    nvidiaSettings = true;
    # Handle Screen Tearing
    forceFullCompositionPipeline = true;
    # Driver version.
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Enable CUDA
  #nixpkgs.config.cudaSupport = true;	# Enable CUDA

  ############################################################
  # BLUETOOTH
  ############################################################
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  ############################################################
  # SOUND
  ############################################################
  #sound.enable = true;
  #security.rtkit.enable = true;
  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
  #  jack.enable = true;
  #};
  #hardware.pulseaudio.enable = false;

  ############################################################
  # USER
  ############################################################
  users.users.james = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "docker" "vboxusers" "plocate" ];
    packages = with pkgs; [
      #flatpak
    ];
  };

  ############################################################
  # HOME-MANAGER
  ############################################################
  home-manager = {
    #pass inputs to home-manager modules
    extraSpecialArgs = { inherit inputs; };
    users = {
      "james" = import ./home.nix;
    };
    useGlobalPkgs = true;
  };

  # SYSTEM PACKAGES
  ############################################################
  environment.systemPackages = with pkgs; [
    binutils
    bubblewrap
    clang
    docker-compose
    #fish
    gcc
    #git
    glibc
    gnome.gnome-tweaks
    home-manager
    i2c-tools
    libclang
    libgcc
    nvidia-vaapi-driver
    nvtop
    plocate
    #podman-compose
    vim
    wget
    zulu11
    
    #ollama
    #(import pkgs { config.cudaSupport = true; config.allowUnfree = true; }).ollama
  ];

  # SYSTEM PACKAGES CUSTOMIZED
  ############################################################
  programs.steam = {
    enable = true;
    #remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession.enable = true;
  };

  # BINARY SUPPORT
  ############################################################
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    glibc
    coreutils
    stdenv.cc.cc
    openssl
    xorg.libXcomposite
    xorg.libXtst
    xorg.libXrandr
    xorg.libXext
    xorg.libX11
    xorg.libXfixes
    libGL
    libva
    pipewire
    xorg.libxcb
    xorg.libXdamage
    xorg.libxshmfence
    xorg.libXxf86vm
    libelf
    
    # Required
    glib
    gtk2
    bzip2
    
    # Without these it silently fails
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXi
    xorg.libSM
    xorg.libICE
    gnome2.GConf
    nspr
    nss
    cups
    libcap
    SDL2
    libusb1
    dbus-glib
    ffmpeg
    # Only libraries are needed from those two
    libudev0-shim
    
    # Verified games requirements
    xorg.libXt
    xorg.libXmu
    libogg
    libvorbis
    SDL
    SDL2_image
    glew110
    libidn
    tbb
    
    # Other things from runtime
    flac
    freeglut
    libjpeg
    libpng
    libpng12
    libsamplerate
    libmikmod
    libtheora
    libtiff
    pixman
    speex
    SDL_image
    SDL_ttf
    SDL_mixer
    SDL2_ttf
    SDL2_mixer
    libappindicator-gtk2
    libdbusmenu-gtk2
    libindicator-gtk2
    libcaca
    libcanberra
    libgcrypt
    libvpx
    librsvg
    xorg.libXft
    libvdpau
    gnome2.pango
    cairo
    atk
    gdk-pixbuf
    fontconfig
    freetype
    dbus
    alsaLib
    expat
    # Needed for electron
    libdrm
    mesa
    libxkbcommon

    # For TastyTrade
    zlib

    # For TOS
    zulu11
    #jdk11
    
    # For TWS
    gtk3
    pkg-config
    pipewire

    # For freespace2
    icu
  ];

  ############################################################
  # DEFAULTS
  ############################################################
  programs.fish.enable = true;
  environment.shells = with pkgs; [ fish bash ];
  users.defaultUserShell = pkgs.fish;

  environment.sessionVariables = {
      FLAKE = "/home/james/.config/nixos";
  };

  ############################################################
  # OTHER
  ############################################################
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  ############################################################
  # SERVICES
  ############################################################
  # List services that you want to enable:
  #services.hardware.openrgb.enable = true;
  services.flatpak.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  
  services = {
    syncthing = {
        enable = true;
        user = "james";
        dataDir = "/home/james/Documents";    # Default folder for new synced folders
        configDir = "/home/james/Documents/.config/syncthing";   # Folder for Syncthing's settings and keys
    };
  };

  ############################################################
  # VERSION
  ############################################################
  system.stateVersion = "24.05"; # Did you read the comment?
}
