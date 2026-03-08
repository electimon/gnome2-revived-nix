{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libIDL";
  version = "2.9.14";

  src = fetchurl {
    url = "https://ftp2.osuosl.org/pub/blfs/conglomeration/libxml2/libxml2-2.9.14.tar.xz";
    sha256 = "sha256-YNdKJX0czsBHXnScui8hVZ5IE577pv8oIkNXx8eY3+4=";
  };
}
