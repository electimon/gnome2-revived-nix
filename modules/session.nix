{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xserver.desktopManager.gnome2;
in
{
  options.services.xserver.desktopManager.gnome2.enable = mkEnableOption "GNOME 2 revived";

  config = mkIf cfg.enable {

    services.xserver.desktopManager.session = [
      {
        name = "gnome2";
        bgSupport = true;
        start = ''
          export XDG_MENU_PREFIX=gnome-
          exec ${gnome-session}/bin/gnome-session
        '';
      }
    ];

  };
}
