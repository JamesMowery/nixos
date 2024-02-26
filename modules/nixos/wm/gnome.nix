{ pkgs, ... }:

{
  services.xserver = {
    displayManager = {
      gdm.enable = true;
    };
    desktopManager = {
      gnome.enable = true;
    };
  };
  programs = {
    gnome.gnome-tweaks;
  };
}
