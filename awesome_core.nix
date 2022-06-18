{ config, pkgs, ... }:

{
  services.xserver = {

    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+awesome";
      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --mode 2560x1440 --pos 0x0 --rotate normal --rate 144 --output DP-4 --mode 2560x1440 --pos 2560x0 --rotate normal --rate 144
      '';
    };

    #desktopManager = {
    #  xfce.enable = true;
    #};

    windowManager = {
      awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          luarocks
        ];
      };
    };
  };

  #environment.systemPackages = with pkgs; [
  #
  #];

}
