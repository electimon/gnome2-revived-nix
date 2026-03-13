{
  description = "GNOME2 revived";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        config = {
          permittedInsecurePackages = [
            "python-2.7.18.7"
            "python-2.7.18.8" # Needed cuz my bestie scrollkeeper can't cope with py3 yet
            "python-2.7.18.12"
            "libsoup-2.74.3" # We should patch this (me)
          ];
        };
        inherit system;
      };

      mkDerivation =
        args:
        pkgs.stdenv.mkDerivation (
          args
          // {
            nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [
              pkgs.pkg-config
              pkgs.intltool
            ];
          }
        );

      callPackage =
        pkgPath: args:
        pkgs.callPackage pkgPath (
          args
          // {
            stdenv = pkgs.stdenv;
            mkDerivation = mkDerivation;
          }
        );

      # Our shite below

      #      GConf = pkgs.gnome2.GConf; # for using official GConf pkg
      gnome-common = pkgs.gnome2.gnome-common;
      # This was renamed in 25.11? or 25.05 whatever the fuck
      gnome-icon-theme =
        if pkgs.lib.hasAttr "gnome-icon-theme" pkgs then
          pkgs.gnome-icon-theme
        else
          pkgs.gnome2.gnome-icon-theme;
      gnome_mime_data = pkgs.gnome2.gnome_mime_data;
      # For some reason the official package doesn't seem to fix this bin? maybe no one uses it...
      gtk2 = pkgs.gtk2.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          chmod +x $dev/bin/gtk-builder-convert
          substituteInPlace $dev/bin/gtk-builder-convert \
            --replace "/usr/bin/env python" "${pkgs.python3}/bin/python"
        '';
      });
      gtkglext = pkgs.gnome2.gtkglext;
      libart_lgpl = pkgs.gnome2.libart_lgpl;
      libglade = pkgs.gnome2.libglade;
      libgnomecanvas = pkgs.gnome2.libgnomecanvas;
      libIDL = pkgs.gnome2.libIDL;
      # This was renamed in 24.11
      libsoup = if pkgs.lib.hasAttr "libsoup_2_4" pkgs then pkgs.libsoup_2_4 else pkgs.libsoup;
      libX11 = pkgs.xorg.libX11;
      libXmu = pkgs.xorg.libXmu;
      ORBit2 = pkgs.gnome2.ORBit2;
      xdg-user-dirs = pkgs.xdg-user-dirs;
    in
    {
      packages.${system} = rec {
        # I wrote pkgs for these b4 I knew they existed already sooooo, ill keep them here
        #        ORBit2 = callPackage ./platform/ORBit2 { inherit libIDL; };
        #        libIDL = callPackage ./platform/libIDL { };
        #        libart_lgpl = callPackage ./platform/libart_lgpl { };
        #        libglade = callPackage ./platform/libglade { };
        #        libgnomecanvas = callPackage ./platform/libgnomecanvas {
        #          inherit libart_lgpl;
        #          inherit libglade;
        #        };
        #        gnome-common = callPackage platform/gnome-common { };
        #        gnome_mime_data = callPackage ./platform/gnome-mime-data { };
        #        gtkglext = callPackage ./platform/gtkglext {
        #          inherit libX11;
        #          inherit libXmu;
        #        };
        #        libgnome-keyring = callPackage ./platform/libgnome-keyring { };

        # Consider moving outside of this flake..
        ConsoleKit2 = callPackage ./platform/ConsoleKit2 { };

        GConf = callPackage ./platform/GConf { inherit ORBit2; };

        gconf-defaults =
          pkgs.runCommand "gconf-defaults"
            {
              buildInputs = [ GConf ];
            }
            ''
              export GCONF_CONFIG_SOURCE=xml:merged:$out/etc/gconf/gconf.xml.defaults
              mkdir -p $out/etc/gconf/gconf.xml.defaults

              for s in ${gnome-base}/etc/gconf/schemas/*.schemas; do
                ${GConf}/bin/gconftool-2 --makefile-install-rule "$s"
              done

              for s in ${gnome-base}/etc/gconf/schemas/*.entries; do
                echo "Installing GConf default entries $s"
                if [ $s = "${gnome-base}/etc/gconf/schemas/panel-default-setup.entries" ]; then
                  echo "Encountered gnome-panel defaults!"
                  ${GConf}/bin/gconftool-2 \
                    --config-source=xml:merged:$out/etc/gconf/gconf.xml.defaults --direct --load "$s"
                  ${GConf}/bin/gconftool-2 \
                    --config-source=xml:merged:$out/etc/gconf/gconf.xml.defaults --direct --load "$s" /apps/panel
                else
                  ${GConf}/bin/gconftool-2 \
                    --config-source=xml:merged:$out/etc/gconf/gconf.xml.defaults --direct --load "$s"
                fi
              done
            '';

        gedit = callPackage ./platform/gedit {
          inherit GConf;
          inherit gtksourceview;
          inherit gnome-doc-utils;
        };

        gnome-applets = callPackage platform/gnome-applets {
          inherit gnome-icon-theme;
          inherit gnome-panel;
          inherit gnome-desktop;
          inherit gnome-settings-daemon;
          inherit gnome-doc-utils;
          inherit libgweather;
          inherit gstreamer0_10;
          inherit gstreamer0_10_plugins_base;
        };

        gnome-control-center = callPackage platform/gnome-control-center {
          inherit libgnomekbd;
          inherit gnome-desktop;
          inherit GConf;
          inherit gnome-menus;
          inherit metacity;
          inherit gnome-settings-daemon;
          inherit gnome-doc-utils;
        };

        gnome-desktop = callPackage ./platform/gnome-desktop {
          inherit GConf;
          inherit gnome-doc-utils;
        };

        gnome-doc-utils = callPackage ./platform/gnome-doc-utils {
          inherit libxml2-2_9;
          inherit scrollkeeper;
        };

        gnome-keyring = callPackage ./platform/gnome-keyring { };

        gnome-media = callPackage platform/gnome-media {
          inherit GConf;
          inherit gstreamer0_10;
          inherit gstreamer0_10_plugins_base;
          inherit gnome-doc-utils;
          inherit libglade;
        };

        gnome-menus = callPackage platform/gnome-menus { };

        gnome-panel = callPackage ./platform/gnome-panel {
          inherit GConf;
          inherit gnome-menus;
          inherit gnome-desktop;
          inherit libgweather;
          inherit gnome-doc-utils;
          inherit libbonobo;
          inherit libbonoboui;
        };

        gnome-session = callPackage ./platform/gnome-session { inherit GConf; };

        gnome-settings-daemon = callPackage platform/gnome-settings-daemon {
          inherit libgnomekbd;
          inherit GConf;
          inherit gnome-desktop;
        };

        gnome-terminal = callPackage ./platform/gnome-terminal {
          inherit vte;
          inherit GConf;
          inherit gnome-common;
          inherit gtk2;
          inherit gnome-doc-utils;
        };

        gnome-themes = callPackage ./platform/gnome-themes { };

        gnome-utils = callPackage ./platform/gnome-utils {
          inherit gnome-panel; # tell me why im including the ENTIRE gnome-panel TODO fix this to use dev output or sm shit
          inherit gnome-doc-utils;
        };

        gnome_vfs = callPackage ./platform/gnome-vfs {
          inherit GConf;
          inherit gnome_mime_data;
        };

        gstreamer0_10 = callPackage ./platform/gstreamer { };

        gstreamer0_10_plugins_base = callPackage ./platform/gstreamer-plugins-base { inherit gstreamer0_10; inherit gnome_vfs; };

        gstreamer0_10_plugins_good = callPackage ./platform/gstreamer-plugins-good { inherit gstreamer0_10; inherit gstreamer0_10_plugins_base; inherit libsoup; inherit GConf; };

        gtksourceview = callPackage ./desktop/gtksourceview { };

        gtk2-engines = callPackage ./platform/gtk2-engines { };

        libbonoboui = callPackage ./platform/libbonoboui {
          inherit GConf;
          inherit libgnome;
          inherit libgnomecanvas;
          inherit libbonobo;
          inherit libglade;
        };

        libbonobo = callPackage ./platform/libbonobo { inherit ORBit2; };

        libgnome = callPackage ./platform/libgnome {
          inherit gnome_vfs;
          inherit libbonobo;
        };

        libgnomekbd = callPackage ./platform/libgnomekbd {
          inherit gnome-common;
          inherit GConf;
        };

        libgweather = callPackage ./platform/libgweather {
          inherit GConf;
          inherit libsoup;
        };

        libxml2-2_9 = callPackage ./platform/libxml2-2.9 { };

        metacity = callPackage ./platform/metacity {
          inherit GConf;
          inherit zenity;
        };

        nautilus = callPackage ./platform/nautilus {
          inherit GConf;
          inherit gnome-desktop;
        };

        scrollkeeper = callPackage ./platform/scrollkeeper-0.3 { inherit libxml2-2_9; };

        thumbnailers = pkgs.buildEnv {
          name = "thumbnailers";
          paths = [ gnome-base pkgs.gdk-pixbuf pkgs.librsvg pkgs.libjxl pkgs.libavif ];
          pathsToLink = [ "/share/thumbnailers" ];
        };

        totem = callPackage ./platform/totem {
          inherit gstreamer0_10;
          inherit gstreamer0_10_plugins_base;
          inherit gstreamer0_10_plugins_good;
          inherit gnome-doc-utils;
          inherit GConf;
        };

        vte = callPackage ./platform/vte { };

        zenity = callPackage ./platform/zenity {
          inherit gnome-doc-utils;
        };

        mplayer = (pkgs.mplayer.override { x11Support = true; }).overrideAttrs (old: {
          configureFlags = (old.configureFlags or [ ]) ++ [
            "--enable-gui"
          ];
          buildInputs = (old.buildInputs or [ ]) ++ [
            gtk2
          ];
          postPatch = (old.postPatch or "") + ''
            substituteInPlace gui/interface.c \
              --replace 'MPLAYER_DATADIR "/skins"' '"/run/current-system/sw/share/mplayer/skins"'
          '';
        });
        mplayer-skins = callPackage ./desktop/mplayer-skins { };

        gnome-base = pkgs.buildEnv {
          name = "gnome2-base";
          paths = [
            ConsoleKit2
            GConf
            ORBit2
            gedit
            gnome-applets
            gnome-common
            gnome-control-center
            gnome-desktop
            gnome-icon-theme
            gnome-keyring
            gnome-media
            gnome-menus
            gnome_mime_data
            gnome-panel
            gnome-session
            gnome-settings-daemon
            gnome-themes
            gnome-terminal
            gnome-utils
            gstreamer0_10
            gstreamer0_10_plugins_base
            gstreamer0_10_plugins_good
            gtk2.out
            gtk2-engines
            gtkglext
            pkgs.hicolor-icon-theme
            libIDL
            libart_lgpl
            libglade
            libgnome
            libgnomecanvas
            libgweather
            metacity
            nautilus
            vte
            xdg-user-dirs
            zenity
          ];
        };

        default = pkgs.buildEnv {
          name = "gnome2-bootstrap";
          paths = [
            gnome-base
            gconf-defaults
            thumbnailers
          ];
        };

        extra-utils = pkgs.buildEnv rec {
          name = "extra-utils";
          paths = [
          ];
        };

        extra-apps = pkgs.buildEnv rec {
          name = "extra-apps";
          paths = [
            mplayer
            mplayer-skins
          ];
        };
      };
      nixosConfigurations.gnomevm = nixpkgs.lib.nixosSystem {
        system = system;

        specialArgs = {
          self = self;
          system = system;
        };

        modules = [
          # This is where gnome-session config lives
          ./modules/session.nix
          # Since we are using this flake as the sys config
          # and by we I mean me :sob: need 2 include the
          # actual sys config
          /etc/nixos/configuration.nix

          (
            { pkgs, ... }:
            {
              # We exist as a flake..
              nix.settings.experimental-features = [
                "nix-command"
                "flakes"
              ];

              # This is from modules/session.nix
              # it enables gnome2 selection in your display manager
              services.xserver.desktopManager.gnome2.enable = true;

              environment.systemPackages = [
                self.packages.${system}.default
                self.packages.${system}.extra-utils
                self.packages.${system}.extra-apps
              ];

              environment.etc."gconf/gconf.xml.defaults".source = "${
                self.packages.${system}.gconf-defaults
              }/etc/gconf/gconf.xml.defaults";

              environment.etc."gconf/2/path".text = ''
                include "$(USERCONFDIR)/gconf/path"
                include "$(HOME)/.gconf.path"
                xml:readwrite:$(HOME)/.gconf
                include /etc/gconf/2/local-defaults.path
                xml:readonly:/etc/gconf/gconf.xml.defaults
              '';

              # Enable the X11 windowing system.
              # Gnome 2 no supports wayland
              services.xserver.enable = true;
              # We should change this to gdm soon
              services.xserver.displayManager.lightdm.enable = true;
              # Gnome has trouble with libinput
              services.libinput.enable = false;

              # Configure keymap in X11
              services.xserver.xkb.layout = "us";

              # We need to use dbus or gnome will DIE
              services.dbus.enable = true;
              # and we need to start dbus-daemon not broker
              services.dbus.implementation = "dbus";
              services.xserver.updateDbusEnvironment = true;
              # Im praying this works
              security.polkit.enable = true;

              # Feed on you, survive off you....
              systemd.packages = [ self.packages.${system}.ConsoleKit2 ];
              services.dbus.packages = [ self.packages.${system}.ConsoleKit2 ]; # RAAAAAAAAAAAAAAa
              security.pam.services.lightdm.text = ''
                session optional ${self.packages.${system}.ConsoleKit2}/lib/security/pam_ck_connector.so
              '';

              xdg.mime.enable = true;
              xdg.icons.enable = true;

              # I forgot why i need this
              environment.pathsToLink = [ "/share" ];

              # GSTreamer
              environment.sessionVariables = {
                GST_PLUGIN_SYSTEM_PATH = "/run/current-system/sw/lib/gstreamer-0.10";
                GST_PLUGIN_PATH = "/run/current-system/sw/lib/gstreamer-0.10";
              };
            }
          )
        ];
      };
    };
}
