{
  description = "GNOME2 revived";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    callPackage = pkgs.callPackage;
    libX11 = pkgs.xorg.libX11;
    libXmu = pkgs.xorg.libXmu;
    gtk2 = pkgs.gtk2;
  in
  {
    packages.${system} = rec {
      ORBit2 = callPackage ./platform/ORBit2 { inherit libIDL; };
      metacity = callPackage ./platform/metacity { inherit GConf; inherit zenity; };
      libIDL = callPackage ./platform/libIDL { };
      libart_lgpl = callPackage ./platform/libart_lgpl { };
      libglade = callPackage ./platform/libglade { };
      GConf = callPackage ./platform/GConf { inherit ORBit2; };
      libgnomecanvas = callPackage ./platform/libgnomecanvas { inherit libart_lgpl; inherit libglade;  };
      gnome-common = callPackage platform/gnome-common { };
      gnome_mime_data = callPackage ./platform/gnome-mime-data { };
      gtkglext = callPackage ./platform/gtkglext { inherit libX11; inherit libXmu; };
      zenity = callPackage ./platform/zenity { };
      default = pkgs.buildEnv rec {
        name = "gnome2-bootstrap";
        paths = [
          libart_lgpl
          libglade
          ORBit2
          libIDL
          GConf
          libgnomecanvas
          gnome-common
          gnome_mime_data
          gtkglext
          gtk2
          metacity
          zenity
        ];
      };
    };
  };
}
