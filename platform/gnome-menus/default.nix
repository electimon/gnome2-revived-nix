{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  glib,
  python2,
}:

mkDerivation rec {
  pname = "gnome-menus";
  version = "2.30.5";

  src = fetchurl {
    url = "https://download.gnome.org/sources/gnome-menus/2.30/gnome-menus-2.30.5.tar.bz2";
    sha256 = "sha256-bcxWUAbW6MICWug6sfgu32vQTWHIBMDcm/XqUGKcTKo=";
  };

  propagatedBuildInputs = [
    glib
    which
    python2
  ]; # autogen.sh which is using gnome-common tends to require which
}
