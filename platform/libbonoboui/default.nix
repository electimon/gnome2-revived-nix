{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libbonobo,
  gtk2,
  GConf,
  libgnome,
  libgnomecanvas,
  intltool,
  libxml2,
  libglade
}:

stdenv.mkDerivation rec {
  pname = "libbonoboui";
  version = "2.24.5";

  src = fetchurl {
    url = "mirror://gnome/sources/libbonoboui/${lib.versions.majorMinor version}/libbonoboui-${version}.tar.bz2";
    sha256 = "sha256-+rXyrGyELZSYYcB8tSCv5b7j3OVYBRUc6c0Bvg7Eb80=";
  };

  buildInputs = [
    gtk2
  ];
  nativeBuildInputs = [
    pkg-config
    intltool
  ];
  propagatedBuildInputs = [ libgnomecanvas libgnome libbonobo libglade libxml2 GConf ];
  NIX_CFLAGS_COMPILE = [ "-Wno-incompatible-pointer-types" ]; # todo remove this
}
