{
  description = "NixOS Config Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #openrgb-rules.url = "https://openrgb.org/releases/release_0.9/60-openrgb.rules";
  };

  outputs = { self, nixpkgs, ... } @inputs:
    let
    # Defined System Settings
    systemSettings = {
      system = "x86_64-linux";	# System Arch
        hostname = "phoenix";		# Hostname
        profile = "personal";		# Select a defined profile
        timezone = "America/Phoenix";	# Timezone
        locale = "en_US.UTF-8";		# Locale
    };
  # Defined User Settings
  userSettings = {
    username = "james";
    name = "James Mowery";
    email = "jmowery@gmail.com";
    dotfilesDir = "~/.dotfiles";
    wm = "gnome";
    #wm = "hyprland";
    display = "x11";
    #display = "wayland";
    browser = "firefox";
    terminal = "alacritty";
    editor = "nvim";
  };

  system = "x86_64-linux";
  lib = nixpkgs.lib;
  pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit systemSettings;
        inherit userSettings;
      };
      modules = [
        ./systems/phoenix/configuration.nix
          inputs.home-manager.nixosModules.default
      ];
    };
  };
}
