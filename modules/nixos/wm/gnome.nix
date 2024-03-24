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
  environment.systemPackages = [
    pkgs.gnome.gnome-tweaks
  ];
}
