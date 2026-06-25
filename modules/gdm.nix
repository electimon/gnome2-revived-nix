{
  config,
  lib,
  pkgs,
  self,
  system,
  ...
}:

let
  cfg = config.services.xserver.displayManager.gdm2;

in
{
  options = {
    services.xserver.displayManager.gdm2 = {
      enable = lib.mkEnableOption "" // {
        description = '' yeah? '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ self.packages.x86_64-linux.gdm2 ];

    services.xserver.displayManager.gdm.enable = false; # you cant have both..
    services.xserver.displayManager.lightdm.enable = false;

    services = {
      xserver = {
        exportConfiguration = true;
        logFile = lib.mkDefault null;
      };
    };

    users.extraUsers.gdm =
      { name = "gdm";
        uid = config.ids.uids.gdm;
        group = "gdm";
        home = "/var/run/gdm";
        description = "GDM user";
      };

    users.extraGroups.gdm.gid = config.ids.gids.gdm;

    security.pam.services = {
      gdm.text = ''
        auth     required       pam_succeed_if.so audit quiet_success user = gdm
        auth     optional       pam_permit.so

        account  required       pam_succeed_if.so audit quiet_success user = gdm
        account  sufficient     pam_unix.so

        password required       pam_deny.so

        session  required       pam_succeed_if.so audit quiet_success user = gdm
        session  required       pam_env.so envfile=/etc/pam/environment
        session  optional       ${pkgs.systemd}/lib/security/pam_systemd.so
        session  optional       pam_keyinit.so force revoke
        session  optional       pam_permit.so

        session optional ${self.packages.${system}.ConsoleKit2}/lib/security/pam_ck_connector.so
      '';

#      gdm-autologin.text = ''
#        auth     requisite      pam_nologin.so
#
#        auth     required       pam_succeed_if.so uid >= 1000 quiet
#        auth     required       pam_permit.so
#
#        account  sufficient     pam_unix.so
#
#        password requisite      pam_unix.so nullok sha512
#
#        session  optional       pam_keyinit.so revoke
#        session  required       pam_env.so envfile=/etc/pam/environment
#        session  required       pam_unix.so
#        session  required       pam_loginuid.so
#        session  optional       ${pkgs.systemd}/lib/security/pam_systemd.so
#      '';
     };
    # The only dir I see that gdm uses
    systemd.tmpfiles.rules = [
      "d /var/log/gdm 0711 gdm gdm - -"
      "d /var/run/gdm 0711 gdm gdm - -"
      "d /var/run/gdm/.gconf 0711 gdm gdm - -"
    ];

    # I guess this creates the actual service definition in  systemd
#    services.xserver.displayManager.generic.enable = true;
    
#    services.xserver.displayManager.generic.execCmd = ''
#      export PATH=${self.packages.${system}.gdm2}/sbin:$PATH
#      exec ${self.packages.${system}.gdm2}/bin/gdm
#    '';
    services.displayManager = {
      enable = true;
      environment = {
          XDG_DATA_DIRS = lib.makeSearchPath "share" [
            self.packages.${system}.gnome-base
            config.services.displayManager.sessionData.desktops
          ];
      };
      execCmd = ''
        # Set GTK_PATH so that GTK+ can find the theme engines.
        export GTK_PATH=${config.system.path}/lib/gtk-2.0

        # Set GTK_DATA_PREFIX so that GTK+ can find the Xfce themes.
        export GTK_DATA_PREFIX=${config.system.path}

        # Set XDG_MENU_PREFIX for gnome-panel.
        export XDG_MENU_PREFIX=gnome-

        # Set TMPDIR for gconf-sanity-check-2
        export TMPDIR=/tmp

        exec ${self.packages.${system}.gdm2}/bin/gdm
      '';
    };

    systemd.services.display-manager.enable = true; # we dont match the name of default enabled targets
    # why? idk
    systemd.services.display-manager.unitConfig = {
      After = [ "plymouth-quit-wait.service" ];
    };
    systemd.services.display-manager.after = [
      "rc-local.service"
      "systemd-machined.service"
      "systemd-user-sessions.service"
      "user.slice"
    ];
    systemd.services.display-manager.serviceConfig = {
      BusName = "org.freedesktop.DisplayManager";
      IgnoreSIGPIPE = "no";
      KeyringMode = "shared";
      KillMode = "mixed";
      StandardError = "inherit";
    };
    systemd.services.display-manager.restartIfChanged = false;
  };
}
