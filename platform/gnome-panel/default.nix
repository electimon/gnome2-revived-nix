{
  lib,
  stdenv,
  fetchurl,
  which,
  intltool,
  python2,
  pkg-config,
  libSM,
  libICE,
  gtk2,
  dbus-glib,
  GConf,
  gnome-menus,
  libcanberra-gtk2,
  gnome-desktop,
  libwnck2,
  librsvg,
  libgweather,
  gnome-doc-utils,
  libxml2,
  libxslt,
  scrollkeeper,
}:

stdenv.mkDerivation rec {
  pname = "gnome-panel";
  version = "2.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-panel/${lib.versions.majorMinor version}/gnome-panel-${version}.tar.bz2";
    sha256 = "sha256-j3go63ohyBenO2l4RKTiAlYFmzI4ZBShD5fVHn2fyl8";
  };

  NIX_LDFLAGS = "-lgmodule-2.0 -lm ";
  buildInputs = [
    libSM
    libICE
    gtk2
    dbus-glib
    GConf
    gnome-menus
    libcanberra-gtk2
    gnome-desktop
    libwnck2
    librsvg
    libgweather
    libxml2
    libxslt
  ];
  nativeBuildInputs = [
    intltool
    python2
    pkg-config
    libSM
    libICE
    gtk2
    dbus-glib
    GConf
    gnome-menus
    libcanberra-gtk2
    gnome-desktop
    libwnck2
    librsvg
    libgweather
    gnome-doc-utils
    libxml2
    libxslt
    scrollkeeper
  ];
  propagatedBuildInputs = [ which ]; # autogen.sh which is using gnome-common tends to require which

  patches = [ ./0001-every-little-thought-is-a-different-sound-compile-fi.patch ];
}
