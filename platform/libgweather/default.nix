{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  gtk2,
  libxml2,
  libsoup,
  GConf,
  tzdata,
}:

mkDerivation rec {
  pname = "libgweather";
  version = "2.30.3";

  src = fetchurl {
    url = "mirror://gnome/sources/libgweather/${lib.versions.majorMinor version}/libgweather-${version}.tar.bz2";
    sha256 = "sha256-uDU3RmFCPzfEaqjjc2iuJKaIVvEXt8IeR1oh79ulJkw";
  };

  configureFlags = [ "--with-zoneinfo-dir=${tzdata}/share/zoneinfo" ];
  buildInputs = [
    gtk2
    libxml2
    GConf
    libsoup
    tzdata
  ];
  nativeBuildInputs = [
    gtk2
    libxml2
    libsoup
    GConf
    tzdata
  ];
  propagatedBuildInputs = [ which ]; # autogen.sh which is using libgweather tends to require which
}
