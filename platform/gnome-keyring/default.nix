{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  glib,
  gtk2,
  libgcrypt,
  libtasn1,
  GConf
}:

mkDerivation rec {
  pname = "gnome-keyring";
  version = "2.28.2";

  src = fetchurl {
    url = "https://download.gnome.org/sources/gnome-keyring/2.28/gnome-keyring-2.28.2.tar.bz2";
    sha256 = "sha256-0taG+yUo7gRbvNnxjQ1FLg64jCJloZR/Y5FSthpZh/Y=";
  };

  buildInputs = [
    glib
    gtk2
    libgcrypt
    libtasn1
    GConf
  ];
  patches = [
#s    ./gnome-keyring-fix-asn1-prototypes.patch
#    ./0001-1440-compile-fix.patch
  ];
}
