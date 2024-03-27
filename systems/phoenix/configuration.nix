{ config, lib, pkgs, inputs, systemSettings, userSettings, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos/boot/systemd-boot.nix
      (./. + "../../../modules/nixos/wm" + ("/" + userSettings.display) + ".nix")
      (./. + "../../../modules/nixos/wm" + ("/" + userSettings.wm) + ".nix")
      inputs.home-manager.nixosModules.default
    ];

  nixpkgs.config.allowUnfree = true;	# Enable Unfree

  ############################################################
  # FLAKES
  ############################################################
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ############################################################
  # ELECTRON FIX
  ############################################################
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  ############################################################
  # APP IMAGES
  ############################################################
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  ############################################################
  # NETWORK
  ############################################################
  networking.hostName = "phoenix"; 	   # Define your hostname.
  networking.networkmanager.enable = true; # Use networkmanager
  networking.firewall.allowedTCPPorts = [ 6742 ];

  ############################################################
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
  # TIMEZONE/LOCALE
  ############################################################
  time.timeZone = "America/Phoenix";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  ############################################################
  # GPU/GRAPHICS
  ############################################################
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [mangohud];
    extraPackages32 = with pkgs; [mangohud];
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  # Nvidia Options
  hardware.nvidia = {
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;
    # Enable the Nvidia settings menu,
    nvidiaSettings = true;
    # Handle Screen Tearing
    forceFullCompositionPipeline = true;
    # Driver version.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
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
    extraGroups = [ "wheel" "input" "docker" "vboxusers" "plocate" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      flatpak
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

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    #zulu11
  ];

  ############################################################
  # SYSTEM PACKAGES
  ############################################################
  environment.systemPackages = with pkgs; [
    vim
    wget
    fish
    zsh
    ollama
    binutils
    i2c-tools
    libgcc
    gcc
    glibc
    libclang
    clang
    plocate
    #(import pkgs { config.cudaSupport = true; config.allowUnfree = true; }).ollama
  ];
  
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession.enable = true;
  }; 

  ############################################################
  # DEFAULTS
  ############################################################
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.shells = with pkgs; [ fish zsh bash ];

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

  ############################################################
  # VERSION
  ############################################################
  system.stateVersion = "23.11"; # Did you read the comment?
}
