{
  description = "GNOME2 revived";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      callPackage = pkgs.callPackage;
      gnome2 = pkgs.gnome2;
      libX11 = pkgs.xorg.libX11;
      libXmu = pkgs.xorg.libXmu;
      ORBit2 = gnome2.ORBit2;
      GConf = gnome2.GConf;
      libIDL = gnome2.libIDL;
      libart_lgpl = gnome2.libart_lgpl;
      libglade = gnome2.libglade;
      libbonobo = gnome2.libbonobo;
      gnome_vfs = gnome2.gnome_vfs;
      libgnomecanvas = gnome2.libgnomecanvas;
      gtkglext = gnome2.gtkglext;
      gnome_mime_data = gnome2.gnome_mime_data;
      gnome-common = gnome2.gnome-common;
      xdg-user-dirs = pkgs.xdg-user-dirs;
      isOld = pkgs.lib.versionOlder pkgs.lib.version "25.11";
      libsoup = if pkgs.lib.hasAttr "libsoup_2_4" pkgs then pkgs.libsoup_2_4 else pkgs.libsoup;
      gtk2 = pkgs.gtk2.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          chmod +x $dev/bin/gtk-builder-convert
          substituteInPlace $dev/bin/gtk-builder-convert \
            --replace "/usr/bin/env python" "${pkgs.python3}/bin/python"
        '';
      });
    in
    {
      packages.${system} = rec {
        #        ORBit2 = callPackage ./platform/ORBit2 { inherit libIDL; };
        metacity = callPackage ./platform/metacity {
          inherit GConf;
          inherit zenity;
        };
        #        libIDL = callPackage ./platform/libIDL { };
        libgweather = callPackage ./platform/libgweather {
          inherit GConf;
          inherit libsoup;
        };
        gnome-desktop = callPackage ./platform/gnome-desktop {
          inherit GConf;
          inherit scrollkeeper;
        };
        #        libart_lgpl = callPackage ./platform/libart_lgpl { };
        #        libglade = callPackage ./platform/libglade { };
        libgnomekbd = callPackage ./platform/libgnomekbd {
          inherit gnome-common;
          inherit GConf;
        };
        gnome-panel = callPackage ./platform/gnome-panel {
          inherit GConf;
          inherit gnome-menus;
          inherit gnome-desktop;
          inherit libgweather;
          inherit scrollkeeper;
        };
        GConf = callPackage ./platform/GConf { inherit ORBit2; };
        #        libgnomecanvas = callPackage ./platform/libgnomecanvas {
        #          inherit libart_lgpl;
        #          inherit libglade;
        #        };
        #        gnome-common = callPackage platform/gnome-common { };
        gnome-settings-daemon = callPackage platform/gnome-settings-daemon {
          inherit libgnomekbd;
          inherit GConf;
          inherit gnome-desktop;
        };
        gnome-control-center = callPackage platform/gnome-control-center {
          inherit libgnomekbd;
          inherit gnome-desktop;
          inherit GConf;
          inherit gnome-menus;
          inherit metacity;
          inherit gnome-settings-daemon;
          inherit scrollkeeper;
        };
        gnome-menus = callPackage platform/gnome-menus { };
        #        gnome_mime_data = callPackage ./platform/gnome-mime-data { };
        #        gtkglext = callPackage ./platform/gtkglext {
        #          inherit libX11;
        #          inherit libXmu;
        #        };
        zenity = callPackage ./platform/zenity { };
        libgnome = callPackage ./platform/libgnome {
          inherit gnome_vfs;
          inherit libbonobo;
        };
        gnome-doc-utils = callPackage ./platform/gnome-doc-utils { inherit scrollkeeper; };
        vte = callPackage ./platform/vte { };
        nautilus = callPackage ./platform/nautilus {
          inherit GConf;
          inherit gnome-desktop;
        };
        gnome-session = callPackage ./platform/gnome-session { inherit GConf; };
        scrollkeeper = callPackage ./platform/scrollkeeper-0.3 { inherit libxml2-2_9; };
        libxml2-2_9 = callPackage ./platform/libxml2-2.9 { };
        #        libgnome-keyring = callPackage ./platform/libgnome-keyring { };
        gnome-keyring = callPackage ./platform/gnome-keyring { };
        gnome-themes = callPackage ./platform/gnome-themes { };
        gnome-terminal = callPackage ./platform/gnome-terminal {
          inherit vte;
          inherit GConf;
          inherit gnome-common;
          inherit gtk2;
          inherit scrollkeeper;
        };
        default = pkgs.buildEnv rec {
          name = "gnome2-bootstrap";
          paths = [
            libart_lgpl
            libglade
            ORBit2
            libIDL
            libgweather
            GConf
            libgnomecanvas
            gnome-common
            gnome-menus
            gnome-session
            gnome_mime_data
            gnome2.gnome-icon-theme
            gtkglext
            metacity
            zenity
            vte
            gnome-terminal
            scrollkeeper
            gnome-desktop
            gnome-panel
            gnome-control-center
            gnome-settings-daemon
            gnome-keyring
            gnome-themes
            libgnome
            gtk2.out
            xdg-user-dirs
            nautilus
            pkgs.hicolor-icon-theme
          ];
        };
      };
      nixosConfigurations.gnomevm = nixpkgs.lib.nixosSystem {
        system = system;

        specialArgs = {
          gnome-session = self.packages.x86_64-linux.gnome-session;
        };

        modules = [
          ./modules/session.nix
          /etc/nixos/configuration.nix

          (
            { pkgs, ... }:
            {
              nix.settings.experimental-features = [
                "nix-command"
                "flakes"
              ];

services.xserver.desktopManager.gnome2.enable = true;

              environment.systemPackages = [
                self.packages.${system}.default
              ];

              services.xserver.enable = true;
              services.xserver.displayManager.startx.enable = true;

              environment.sessionVariables = {
                GCONF_CONFIG_SOURCE = "xml:readwrite:/var/lib/gconf;xml:readonly:/etc/gconf/gconf.xml.defaults";
                GCONF_SCHEMA_INSTALL_SOURCE=xml:readwrite:/var/lib/gconf;
              };
              systemd.tmpfiles.rules = [
                "d /var/lib/gconf 0755 root root -"
              ];
              environment.etc."gconf/schemas".source = "${self.packages.${system}.default}/etc/gconf/schemas";

              system.activationScripts.gconfSchemas.text = ''
                export GCONF_CONFIG_SOURCE=xml:readwrite:/var/lib/gconf
                export GCONF_SCHEMA_INSTALL_SOURCE=xml:readwrite:/var/lib/gconf
                mkdir -p /var/lib/gconf

                for s in ${self.packages.${system}.default}/etc/gconf/schemas/*.schemas; do
                  echo "Installing GConf schema $s"
                  ${self.packages.${system}.GConf}/bin/gconftool-2 \
                    --makefile-install-rule "$s"
                done
              '';
            }
          )
        ];
      };
    };
}
