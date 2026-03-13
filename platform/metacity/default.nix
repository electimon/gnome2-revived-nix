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
  version = "2.36";

  src = fetchurl {
    url = "https://github.com/electimon/metacity/releases/download/2.36/metacity-2.30.5.tar.gz";
    sha256 = "7cdb194d0836bb17c8801aa039a1cd517d7b145e8f175e2b6ef7dfc9673c00bc";
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
  ];
}
