{ config, pkgs, ... }:

{
  services.xserver = {

    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+bspwm";
    };

    desktopManager = {
      xfce.enable = true;
    };

    windowManager = {
      bspwm = {
        enable = true;
        #configFile = "${pkgs.bspwm}/share/doc/bspwm/examples/bspwmrc"
        #sxhkd.configFile = "${pkgs.bspwm}/share/doc/bspwm/examples/sxhkdrc"
      };
    };

  };

  environment.systemPackages = with pkgs; [
    bspwm
    sxhkd
    polybar
    picom
    rofi
  ];

}
