{
  description = "GNOME2 revived";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      callPackage = pkgs.callPackage;
      libX11 = pkgs.xorg.libX11;
      libXmu = pkgs.xorg.libXmu;
      gtk2 = pkgs.gtk2.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          if [ -f "$dev/bin/gtk-builder-convert" ]; then
            chmod +x $dev/bin/gtk-builder-convert
            substituteInPlace $dev/bin/gtk-builder-convert \
              --replace "/usr/bin/env python" "${pkgs.python3}/bin/python"
          fi
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
        libgweather = callPackage ./platform/libgweather { inherit GConf; };
        gnome-desktop = callPackage ./platform/gnome-desktop {
          inherit GConf;
          scrollkeeper = scrollkeeper-0_3;
        };
        libart_lgpl = callPackage ./platform/libart_lgpl { };
        libglade = callPackage ./platform/libglade { };
        gnome-panel = callPackage ./platform/gnome-panel {
          inherit GConf;
          inherit gnome-menus;
          inherit gnome-desktop;
          inherit libgweather;
          scrollkeeper = scrollkeeper-0_3;
        };
        GConf = callPackage ./platform/GConf { inherit ORBit2; };
        libgnomecanvas = callPackage ./platform/libgnomecanvas {
          inherit libart_lgpl;
          inherit libglade;
        };
        gnome-common = callPackage platform/gnome-common { };
        gnome-menus = callPackage platform/gnome-menus { };
        gnome_mime_data = callPackage ./platform/gnome-mime-data { };
        gtkglext = callPackage ./platform/gtkglext {
          inherit libX11;
          inherit libXmu;
        };
        zenity = callPackage ./platform/zenity { };
        vte = callPackage ./platform/vte { };
        gnome-session = callPackage ./platform/gnome-session { inherit GConf; };
        scrollkeeper-0_3 = callPackage ./platform/scrollkeeper-0.3 { inherit libxml2-2_9; };
        libxml2-2_9 = callPackage ./platform/libxml2-2.9 { };
        gnome-terminal = callPackage ./platform/gnome-terminal {
          inherit vte;
          inherit GConf;
          inherit gnome-common;
          gtk2 = gtk2;
          scrollkeeper = scrollkeeper-0_3;
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
            scrollkeeper-0_3
            gnome-desktop
            gnome-panel
          ];
        };
      };
    };
}
