{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  glib,
  gtk2,
  libcanberra-gtk2,
  libXdamage,
  GConf,
  zenity,
  gnome-doc-utils,
}:

mkDerivation rec {
  pname = "metacity";
  version = "2.36.1";

  src = fetchurl {
    url = "https://github.com/electimon/metacity/releases/download/2.36.1/metacity-2.30.5.tar.gz";
    sha256 = "ca8776851dce075ff8466b803a8597033954bcf0de6b28cd86327c013db908fc";
  };

  propagatedBuildInputs = [ which ]; # autogen.sh which is using gnome-common tends to require which

  nativeBuildInputs = [
    glib
    gtk2
    libcanberra-gtk2
    libXdamage
    GConf
    zenity
    gnome-doc-utils
  ];

  patches = [
    ./fix-crash.diff
  ];
}
