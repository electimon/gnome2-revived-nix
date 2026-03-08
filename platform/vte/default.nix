{
  lib,
  stdenv,
  fetchgit,
  which,
  intltool,
  glib,
  gtk2,
  pkg-config,
  ncurses,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "vte";
  version = "0.26.2";

  src = fetchgit {
    url = "https://daedalus.yzuinfra.moe/gnome2-revived/vte-0.26.2.git";
    sha256 = "sha256-leJ1dA9H4rXcYCyjvyBxH7m5goScPpBrtnGbZHWDPSc=";
  };

  propagatedBuildInputs = [ which intltool pkg-config glib gtk2 ncurses python3 ]; # autogen.sh which is using vte tends to require which
}
