{
  lib,
  stdenv,
  mkDerivation,
  fetchgit,
  which,
  autoconf,
  libtool,
  automake,
  gtk2,
  alsa-lib,
  libmikmod,
  libogg
}:

mkDerivation rec {
  pname = "xmms-gtk2";
  version = "1.2.12+git";

  src = fetchgit {
    url = "https://github.com/electimon/xmms-gtk2";
    sha256 = "sha256-0KuxUIwFVUOHShUjXzDOXgVLHY5xzj/5yGCfXHKcIUk=";
  };

  preConfigure = [ "autoreconf -fi" ];
  nativeBuildInputs = [ autoconf libtool automake ];
  buildInputs = [ gtk2 alsa-lib libmikmod libogg ];
  propagatedBuildInputs = [ which ]; # autogen.sh which is using xmms-gtk2 tends to require which
  NIX_LDFLAGS = "-lmvec";
}
