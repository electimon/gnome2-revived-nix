{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  gtk2
}:

mkDerivation rec {
  pname = "gtk2-engines";
  version = "2.20.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk-engines/${lib.versions.majorMinor version}/gtk-engines-${version}.tar.bz2";
    sha256 = "sha256-FbaAq8psdz7LhSU1IfoQDdO4VJvv7sx1lbECCdYtZrU=";
  };

  buildInputs = [ gtk2 ];
}
