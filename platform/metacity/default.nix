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
  version = "2.31";

  src = fetchurl {
    url = "https://github.com/electimon/metacity/releases/download/2.35.1/metacity-2.30.5.tar.gz";
    sha256 = "sha256-ric06GdN4yodmy0E4C6c9hOC5eEyi5uXeSoYgmjJdhA";
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
