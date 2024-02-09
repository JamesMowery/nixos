{ pkgs, ... }:

{
  imports = [ ./pipewire.nix
              ./fonts.nix
            ];

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
    excludePackages = [ pkgs.xterm ];
  };
}
