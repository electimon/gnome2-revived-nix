{
  lib,
  stdenv,
  fetchurl,
  which,
  python2,
  pkg-config,
  libxslt,
  intltool,
  libxml2-2_9,
  scrollkeeper,
}:

stdenv.mkDerivation rec {
  pname = "gnome-doc-utils";
  version = "0.20.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-doc-utils/${lib.versions.majorMinor version}/gnome-doc-utils-${version}.tar.bz2";
    sha256 = "sha256-9sAST2G5QAxj2mMN06msG3OOrABY2iRWYf9pn60meso=";
  };

  buildInputs = [
    python2
    libxml2-2_9
  ];
  nativeBuildInputs = [
    python2
    pkg-config
    libxml2-2_9
    libxslt
    intltool
    scrollkeeper
  ];

  # This package has xml2po in it, so anyone using it implictly needs
  # python as well as the libxml python module for xml2po to function
  propagatedBuildInputs = [
    python2
    libxml2-2_9
  ];
}
