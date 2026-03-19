{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  gtk2,
  GConf,
  gnome-doc-utils,
  libSM
}:

mkDerivation rec {
  pname = "file-roller";
  version = "2.32.2";

  src = fetchurl {
    url = "mirror://gnome/sources/file-roller/${lib.versions.majorMinor version}/file-roller-${version}.tar.bz2";
    sha256 = "sha256-Pdvk5BNOq0/46XeJoWJq7Gy8WIGQ8vUghQ0GlwN+V1U=";
  };

  buildInputs = [ gtk2 GConf libSM ];
  nativeBuildInputs = [ gnome-doc-utils ];
  patches = [ ./fixes.patch ];
}
