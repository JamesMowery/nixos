{ pkgs, ... }:

{
  imports = [
    ./pipewire.nix
    ./fonts.nix
    #./portals.nix
  ];

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    xkb.layout = "us";
    xkb.variant = "";
    libinput.enable = false;
    #excludePackages = [ pkgs.xterm ];
  };
}
