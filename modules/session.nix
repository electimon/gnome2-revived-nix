{
  config,
  lib,
  pkgs,
  self,
  ...
}:

with lib;

let
  cfg = config.services.xserver.desktopManager.gnome2;
in
{
  options.services.xserver.desktopManager.gnome2.enable = mkEnableOption "GNOME 2 Revived";

  config = mkIf cfg.enable {

    services.xserver.desktopManager.session = [
      {
        name = "gnome2";
        bgSupport = true;
        start = ''
          # Set GTK_PATH so that GTK+ can find the theme engines.
          export GTK_PATH=${config.system.path}/lib/gtk-2.0

          # Set GTK_DATA_PREFIX so that GTK+ can find the Xfce themes.
          export GTK_DATA_PREFIX=${config.system.path}

          # Set XDG_MENU_PREFIX for gnome-panel.
          export XDG_MENU_PREFIX=gnome-

          # Set TMPDIR for gconf-sanity-check-2
          export TMPDIR=/tmp

          exec ${self.packages.${system}.ConsoleKit}/bin/ck-launch-session ${pkgs.dbus}/bin/dbus-run-session ${self.packages.x86_64-linux.gnome-session}/bin/gnome-session
        '';
      }
    ];

  };
}
