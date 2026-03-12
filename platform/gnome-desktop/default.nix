{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  libX11,
  glib,
  gtk2,
  GConf,
  python2,
  gnome-doc-utils,
  libxml2,
}:

mkDerivation rec {
  pname = "gnome-desktop";
  version = "2.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-desktop/${lib.versions.majorMinor version}/gnome-desktop-${version}.tar.bz2";
    sha256 = "sha256-Vcvs9n7+H6HleslmUgp8RteZyLo8ZSoSGfYMr8yzc50";
  };

  buildInputs = [
    libX11
    gtk2
    glib
    GConf
    libxml2
  ];
  propagatedBuildInputs = [ which ]; # autogen.sh which is using gnome-desktop tends to require which
  nativeBuildInputs = [
    libX11
    gtk2
    glib
    GConf
    python2
    gnome-doc-utils
    libxml2
  ];

  patches = [
    ./0001-1440-compile-fix.patch
  ];
}
