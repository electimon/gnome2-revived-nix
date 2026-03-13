{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  python2,
  glib,
  gtk2,
  libxml2,
  GConf,
  gtksourceview,
  libSM,
  gnome-doc-utils
}:

mkDerivation rec {
  pname = "gedit";
  version = "2.30.4";

  src = fetchurl {
    url = "mirror://gnome/sources/gedit/${lib.versions.majorMinor version}/gedit-${version}.tar.bz2";
    sha256 = "a561fe3dd1d199baede1bd07c4ee65f06fc7c494dd4d3327117f04149a608e3c";
  };

  buildInputs = [ python2 glib gtk2 libxml2 GConf gtksourceview libSM ];
  nativeBuildInputs = [ gnome-doc-utils ];

  configureFlags = [ "--disable-spell" ];

  NIX_LDFLAGS = "-lgmodule-2.0 -lICE";
  NIX_CFLAGS_COMPILE = "-Wno-incompatible-pointer-types -Wno-implicit-function-declaration"; # todo remove

  postPatch = '' sed -i "s/g_printf/g_print/g" tests/smart-converter.c '';
}
