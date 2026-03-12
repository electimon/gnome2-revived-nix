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
  version = "2.35";

  src = fetchurl {
    url = "https://github.com/electimon/metacity/releases/download/2.35/metacity-2.34.21.tar.gz";
    sha256 = "sha256-9dzSSvJkQOMcs0zmIWwmMzkF42tMmfEOlACbwzyOHHs=";
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
