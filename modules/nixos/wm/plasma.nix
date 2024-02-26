{ pkgs, ... }:

{
  services.xserver = {
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true; 
  };
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
  programs.dconf.enable = true;
}
