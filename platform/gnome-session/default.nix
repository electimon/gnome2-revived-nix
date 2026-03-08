{
  lib,
  stdenv,
  fetchgit,
  which,
  intltool,
  pkg-config,
  glib,
  gtk2,
  upower,
  dbus-glib,
  libSM,
  GConf,
}:

stdenv.mkDerivation rec {
  pname = "gnome-session";
  version = "2.32.1";

  src = fetchgit {
    url = "https://daedalus.yzuinfra.moe/gnome2-revived/gnome-session-2.32.1.git";
    sha256 = "sha256-i2hhSNT/JEs5nYFeuxRICPbez2fA2595z40KOOgcl8I";
    rev = "2639af33c31128316dc19d96041f084da60ced3f";
  };

  propagatedBuildInputs = [
    which
    glib
    gtk2
    upower
    dbus-glib
    libSM
    GConf
  ]; # autogen.sh which is using gnome-common tends to require which
  nativeBuildInputs = [
    intltool
    pkg-config
    upower
  ];

  makeFlags = ''LDFLAGS=-"lupower-glib" '';
}
