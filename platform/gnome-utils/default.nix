{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  glib,
  gtk2,
  gnome-panel,
  libgtop,
  libcanberra-gtk2,
  scrollkeeper,
  gnome-doc-utils,
  libSM,
}:

mkDerivation rec {
  pname = "gnome-utils";
  version = "2.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-utils/${lib.versions.majorMinor version}/gnome-utils-${version}.tar.bz2";
    sha256 = "sha256-AzpVz0QglrKOpikgQzVP6v4ADR5fTruWKpttcuuak/o=";
  };

  buildInputs = [
    glib
    gtk2
    gnome-panel
    libgtop
    libcanberra-gtk2
    libSM
  ];
  nativeBuildInputs = [
    scrollkeeper
    gnome-doc-utils
  ];
  NIX_CFLAGS_COMPILE = [ "-Wno-implicit-function-declaration" ]; # TODO fix this
  postPatch = ''
    substituteInPlace baobab/src/baobab.h \
      --replace 'BaobabApplication baobab' 'static BaobabApplication baobab'
  '';
  patches = [
    ./fix-gdict-incl.patch
    ./switch-to-non-entry-box.patch
  ];
}
