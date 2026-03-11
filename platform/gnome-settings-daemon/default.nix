{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  dbus-glib,
  glib,
  gtk2,
  GConf,
  gnome-desktop,
  libxklavier,
  libgnomekbd,
  libSM,
}:

mkDerivation rec {
  pname = "gnome-settings-daemon";
  version = "2.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${lib.versions.majorMinor version}/gnome-settings-daemon-${version}.tar.bz2";
    sha256 = "sha256-1esCcAKPBy6NNsYeRnfVWERmnZqwnVJfbHa0mA7IHJ4=";
  };

  buildInputs = [
    dbus-glib
    glib
    gtk2
    GConf
    gnome-desktop
    libxklavier
    libgnomekbd
    libSM
  ];
  nativeBuildInputs = [
    dbus-glib
    glib
    gtk2
    GConf
    gnome-desktop
    libxklavier
    libgnomekbd
    libSM
  ];
  propagatedBuildInputs = [ which ]; # autogen.sh which is using gnome-settings-daemon tends to require which

  #  patches = [
  #    (fetchurl {
  #      name = "gnome-settings-daemon-libgnomekbd-patch";
  #      url = "https://raw.githubusercontent.com/OpenIndiana/oi-userland/8209d32a68c949022e900cf8c72953ba15fa6eab/components/desktop/gnome/gnome-settings-daemon-2/patches/gnome-settings-daemon-17-libgnomekbd.patch";
  #      sha256 = "sha256-iWXtMUGYEryQlXXuKvPhr82kpY43OJSNa4+QboObcYk";
  #    })
  #  ];
}
