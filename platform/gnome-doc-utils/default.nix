{
  lib,
  stdenv,
  fetchurl,
  which,
  python2,
  pkg-config,
  libxslt,
  intltool,
  libxml2,
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
    libxml2
  ];
  nativeBuildInputs = [
    python2
    pkg-config
    libxslt
    intltool
    scrollkeeper
  ];
  propagatedBuildInputs = [
    which
    python2
  ]; # autogen.sh which is using gnome-doc-utils tends to require which
}
