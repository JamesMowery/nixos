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
  programs = {
    #breeze-qt5.enable = true;
    #breeze-gtk.enable = true;
    #breeze-icons.enable = true;
    dconf.enable = true;
  };
  environment.systemPackages = [
    pkgs.gsettings-desktop-schemas
  ];
  #xdg.portal = {
  #  enable = true;
  #  extraPortals = with pkgs; [
  #    xdg-desktop-portal-kde
  #    xdg-desktop-portal-gtk
  #    #xdg-desktop-portal-wlr
  #  ];
  #};
}
