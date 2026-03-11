{
  lib,
  stdenv,
  mkDerivation,
  fetchgit,
  which,
  vte,
  GConf,
  libSM,
  gnome-doc-utils,
  gnome-common,
  autoconf,
  automake,
  libtool,
  gtk2,
  libxslt,
  libxml2,
  scrollkeeper,
}:

mkDerivation rec {
  pname = "gnome-terminal";
  version = "2.32.1";

  src = fetchgit {
    url = "https://daedalus.yzuinfra.moe/gnome2-revived/gnome-terminal-2.32.1";
    sha256 = "sha256-MTu5TK6gDCegtPD65lhTQ1EpMVPjx4FMDEqHJCtW8NA=";
    rev = "70267e760f";
  };

  preConfigure = ''
    NOCONFIGURE=1 autoreconf -fi
  '';

  propagatedBuildInputs = [
    gtk2
    which
    vte
    GConf
    libSM
    gnome-doc-utils
    gnome-common
    autoconf
    automake
    libtool
    libxslt
    libxml2
    scrollkeeper
  ]; # autogen.sh which is using gnome-common tends to require which
}
