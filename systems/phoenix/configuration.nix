# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, systemSettings, userSettings, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos/boot/systemd-boot.nix
      #../../modules/nixos/wm/plasma.nix
      #../../modules/nixos/wm/x11.nix
      (./. + "../../../modules/nixos/wm" + ("/" + userSettings.display) + ".nix")
      (./. + "../../../modules/nixos/wm" + ("/" + userSettings.wm) + ".nix")
      inputs.home-manager.nixosModules.default
    ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;	# Enable Unfree
  #nixpkgs.config.cudaSupport = true;	# Enable CUDA

  # Enable Electron
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  ############################################################
  # FILESYSTEM
  ############################################################
  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/E475-AC97";
      fsType = "vfat";
    };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/4e905fe1-b4e6-4ac2-ae86-05e6e065b9da";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "space_cache=v2" "noatime" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/4e905fe1-b4e6-4ac2-ae86-05e6e065b9da";
      fsType = "btrfs";
      options = [ "subvol=@home"  "compress=zstd" "space_cache=v2" "noatime" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/4e905fe1-b4e6-4ac2-ae86-05e6e065b9da";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "space_cache=v2" "noatime" ];
    };

  fileSystems."/mnt/games" =
    { device = "/dev/disk/by-uuid/6b09080b-4ff2-4655-878b-feb9a5b8e5be";
      fsType = "btrfs";
      options = [ "subvol=@games" "compress=zstd" "space_cache=v2" "noatime" ];
    };
  
  fileSystems."/mnt/data" =
    { device = "/dev/disk/by-uuid/6b09080b-4ff2-4655-878b-feb9a5b8e5be";
      fsType = "btrfs";
      options = [ "subvol=@data" "compress=zstd" "space_cache=v2" "noatime" ];
    };
  
  fileSystems."/mnt/backup" =
    { device = "/dev/disk/by-uuid/6b09080b-4ff2-4655-878b-feb9a5b8e5be";
      fsType = "btrfs";
      options = [ "subvol=@backup" "compress=zstd" "space_cache=v2" "noatime" ];
    };
  
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };

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
  #  enable = true; 
    storageDriver = "btrfs";
    #setSocketVariable = true;
  };
  
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
    #storageDriver = "btrfs";
  };

  ############################################################
  # TIMEZONE/LOCALE
  ############################################################
  # Set your time zone.
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

  ############################################################
  # BLUETOOTH
  ############################################################
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  ############################################################
  # SOUND
  ############################################################
  # Enable sound.
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
    extraGroups = [ "wheel" "input" "docker" "vboxusers" ]; # Enable ‘sudo’ for the user.
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

  ############################################################
  # SYSTEM PACAKGES
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
    libclang
    clang
    #(import pkgs { config.cudaSupport = true; config.allowUnfree = true; }).ollama
  ];

  environment.shells = with pkgs; [ fish zsh bash ];
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession.enable = true;
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

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  system.stateVersion = "23.11"; # Did you read the comment?
}
