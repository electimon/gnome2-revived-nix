{
  lib,
  stdenv,
  fetchurl,
  which,
  intltool,
  glib,
  pkg-config,
  gtk2,
  libgcrypt,
  libtasn1,
}:

stdenv.mkDerivation rec {
  pname = "gnome-keyring";
  version = "2.32.1";

  src = fetchurl {
    url = "https://download.gnome.org/sources/gnome-keyring/2.32/gnome-keyring-2.32.1.tar.gz";
    sha256 = "sha256-UeVamK+X6CIq6R/F+AhLrNqPnuSz5M/4IvlOtfJBIBg=";
  };

  buildInputs = [
    glib
    gtk2
    libgcrypt
    libtasn1
  ];
  nativeBuildInputs = [
    pkg-config
    intltool
    gtk2
    libgcrypt
    libtasn1
  ];
  propagatedBuildInputs = [ which ]; # autogen.sh which is using gnome-common tends to require which
  patches = [
    ./gnome-keyring-fix-asn1-prototypes.patch
    ./0001-1440-compile-fix.patch
  ];
}
