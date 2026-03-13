{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  gmime,
  libxml2,
  libsoup
}:

mkDerivation rec {
  pname = "totem-pl-parser";
  version = "2.32.6";

  src = fetchurl {
    url = "mirror://gnome/sources/totem-pl-parser/${lib.versions.majorMinor version}/totem-pl-parser-${version}.tar.bz2";
    sha256 = "e71c8f63a88a75d5c544ac54d10be1edfeef7b26427dea0a9e8e7bd16663241f";
  };
  buildInputs = [ gmime libxml2 libsoup ];
}
