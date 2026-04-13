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
  version = "2.36.2";

  src = fetchurl {
    url = "https://github.com/electimon/metacity/archive/refs/tags/2.36.2.tar.gz";
    sha256 = "sha256-vw/+nXiOHAInwfoIpsZIlyXuwnkktBeOP/Zd444d5EQ=";
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
