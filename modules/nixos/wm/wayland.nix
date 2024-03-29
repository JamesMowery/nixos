{ pkgs, ... }:

{
  imports = [
    ./pipewire.nix
    ./fonts.nix
    ./portals.nix
  ];

  environment.systemPackages = [ pkgs.wayland pkgs.waydroid ];

  # Configure xwayland
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
    #xkb.options = "caps:escape";
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
}
