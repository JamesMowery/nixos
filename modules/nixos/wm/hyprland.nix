{ pkgs, ... }:

{
  imports = [];

  # Security
  security = {
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
    # pam.services.gtklock = {};
    pam.services.login.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;

  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    # Gnome Utilities
    gnome.file-roller.enable = true;
    gnome-text-editor.enable = true;
    gnome.file-roller.enable = true;
    gnome.gnome-font-viewer.enable = true;
    gnome.gnome-calculator.enable = true;
    gnome.nautilus.enable = true;             #gnome file manager
  };
}
