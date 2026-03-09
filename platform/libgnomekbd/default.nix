{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gnome-common,
  intltool,
  gtk2,
  #  libxml2,
  glib,
  libxklavier,
  GConf,
}:

stdenv.mkDerivation rec {
  pname = "libgnomekbd";
  version = "2.32.0";

  src = fetchurl {
    url = "https://download.gnome.org/sources/libgnomekbd/2.32/libgnomekbd-2.32.0.tar.gz";
    sha256 = "sha256-OMGwJjPPeVqL/YbRWVvs0/x/PCmoV9UZwjSI65i4j/o=";
  };

  buildInputs = [
    glib
    gtk2
    libxklavier
  ];

  nativeBuildInputs = [
    pkg-config
    gnome-common
    intltool
    glib
    gtk2
    libxklavier
    GConf
  ];

  patches = [
    ./0001-explicit-declaration-of-internal-libxklavier-functio.patch
  ];
}
