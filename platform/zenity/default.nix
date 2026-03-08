{
  lib,
  stdenv,
  fetchurl,
  which,
  intltool,
  pkg-config,
  glib,
  gtk2,
  libcanberra-gtk2,
  libXdamage,
  gnome-doc-utils,
  libxml2,
  libxslt,
}:

stdenv.mkDerivation rec {
  pname = "zenity";
  version = "2.32.1";

  src = fetchurl {
    url = "https://download.gnome.org/sources/zenity/2.32/zenity-2.32.1.tar.bz2";
    sha256 = "sha256-iDi+BBoHNktipCgclxOS5KCbsBuzI3qDbsBFfsDqGKw=";
  };

  propagatedBuildInputs = [ which ]; # autogen.sh which is using gnome-common tends to require which

  nativeBuildInputs = [
    intltool
    pkg-config
    glib
    gtk2
    libcanberra-gtk2
    libXdamage
    gnome-doc-utils
    libxml2
    libxslt
  ];

  patches = [
  ];

  configureFlags = [ "--disable-scrollkeeper" ];
}
