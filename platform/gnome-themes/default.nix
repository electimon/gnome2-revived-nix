{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  gtk_engines,
  gtk2,
  iconnamingutils,
}:

mkDerivation rec {
  pname = "gnome-themes";
  version = "2.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-themes/${lib.versions.majorMinor version}/gnome-themes-${version}.tar.bz2";
    sha256 = "sha256-hgHuJMLgllkyIcvW69tmhgQiJaA8AqAcDWfBY/n+vRo=";
  };

  buildInputs = [
    gtk_engines
    gtk2
  ];
  nativeBuildInputs = [
    gtk2
    iconnamingutils
  ];
  propagatedBuildInputs = [ which ]; # autogen.sh which is using gnome-themes tends to require which
}
