{ pkgs, ... }:

{
  imports = [
              ./pipewire.nix
              #./dbus.nix
            ];

  xsession = {
  windowManager.bspwm = {
    enable = true;
    alwaysResetDesktops = true;
    startupPrograms = [
      "sxhkd"
      "flameshot"
      "dunst"
      "nm-applet --indicator"
      "sleep 2s;polybar -q main"
    ];
    monitors = {
      DP-2 = [
        "I"
        "II"
        "III"
        "IV"
        "V"
      ];
      DP-4 = [
	"VI"
	"VII"
	"VIII"
	"IX"
	"X"
      ];
    };
    rules = {
      "mpv" = {
        state = "floating";
        center = true;
      };
    };
    settings = {
      window_gap = 8;
      split_ratio = 0.5;
    };
    extraConfig = ''
    '';
    extraConfigEarly = ''
      systemctl --user start bspwm-session.target
      systemctl --user start tray.target
    ''
  };

  services.blueman.enable = true;
}
