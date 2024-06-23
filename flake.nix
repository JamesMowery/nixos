{
  description = "NixOS Config Flake";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nix-alien.url = "github:thiagokokada/nix-alien";
    open-webui = {
      url = "github:shivaraj-bh/ollama-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    open-webui,
    ...
  }:
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
      browser = "firefox";
      terminal = "alacritty";
      editor = "nvim";
      
      display = "x11";
      #wm = "gnome";
      wm = "plasma";
      #wm = "bspwm";

      #display = "wayland";
      #wm = "hyprland";
    };
  
    system = "x86_64-linux";
    #lib = nixpkgs.lib;
    #pkgs = nixpkgs.legacyPackages.${system};
    # Stable
    pkgs = import nixpkgs {
      inherit system;
      inherit open-webui;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-25.9.0"
          "electron-27.3.11"
        ];
      };
    };
    # Unstable
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-25.9.0"
          "electron-27.3.11"
        ];
      };
    };

  in {
    nixosConfigurations = { 
      phoenix = nixpkgs.lib.nixosSystem rec {
        inherit pkgs;
        specialArgs = {
          inherit inputs;
          inherit systemSettings;
          inherit userSettings;
          inherit pkgs-unstable;
          inherit open-webui;
        };
        modules = [
          ./systems/phoenix/configuration.nix
          # Home Manager Setup
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.james = import ./systems/phoenix/home.nix;
            home-manager.extraSpecialArgs = {
            	inherit self;
	            inherit system;
              inherit pkgs-unstable;
              inherit open-webui;
            };
          }
          #inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
