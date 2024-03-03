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

  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
  };

  # Gnome Utilities
  #pkgs.gnome-text-editor.enable = true;
  #pkgs.gnome.file-roller.enable = true;
  #pkgs.gnome.gnome-font-viewer.enable = true;
  #pkgs.gnome.gnome-calculator.enable = true;
  #pkgs.gnome.nautilus.enable = true;             #gnome file manager

  services.gnome.gnome-keyring.enable = true;
  services.blueman.enable = true;
}
