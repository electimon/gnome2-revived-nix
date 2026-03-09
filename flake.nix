{
  description = "GNOME2 revived";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      callPackage = pkgs.callPackage;
      libX11 = pkgs.xorg.libX11;
      libXmu = pkgs.xorg.libXmu;
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
        ORBit2 = callPackage ./platform/ORBit2 { inherit libIDL; };
        metacity = callPackage ./platform/metacity {
          inherit GConf;
          inherit zenity;
        };
        libIDL = callPackage ./platform/libIDL { };
        libgweather = callPackage ./platform/libgweather {
          inherit GConf;
          inherit libsoup;
        };
        gnome-desktop = callPackage ./platform/gnome-desktop {
          inherit GConf;
          inherit scrollkeeper;
        };
        libart_lgpl = callPackage ./platform/libart_lgpl { };
        libglade = callPackage ./platform/libglade { };
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
        libgnomecanvas = callPackage ./platform/libgnomecanvas {
          inherit libart_lgpl;
          inherit libglade;
        };
        gnome-common = callPackage platform/gnome-common { };
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
        gnome_mime_data = callPackage ./platform/gnome-mime-data { };
        gtkglext = callPackage ./platform/gtkglext {
          inherit libX11;
          inherit libXmu;
        };
        zenity = callPackage ./platform/zenity { };
        gnome-doc-utils = callPackage ./platform/gnome-doc-utils { inherit scrollkeeper; };
        vte = callPackage ./platform/vte { };
        gnome-session = callPackage ./platform/gnome-session { inherit GConf; };
        scrollkeeper = callPackage ./platform/scrollkeeper-0.3 { inherit libxml2-2_9; };
        libxml2-2_9 = callPackage ./platform/libxml2-2.9 { };
        #        libgnome-keyring = callPackage ./platform/libgnome-keyring { };
        gnome-keyring = callPackage ./platform/gnome-keyring { };
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
          ];
        };
      };
    };
}
