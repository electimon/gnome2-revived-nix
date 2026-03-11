{
  lib,
  stdenv,
  mkDerivation,
  fetchgit,
  which,
  glib,
  gtk2,
  ncurses,
  python3,
}:

mkDerivation rec {
  pname = "vte";
  version = "0.26.2";

  src = fetchgit {
    url = "https://daedalus.yzuinfra.moe/gnome2-revived/vte-0.26.2.git";
    sha256 = "sha256-leJ1dA9H4rXcYCyjvyBxH7m5goScPpBrtnGbZHWDPSc=";
  };

  propagatedBuildInputs = [
    which
    glib
    gtk2
    ncurses
    python3
  ]; # autogen.sh which is using vte tends to require which
}
