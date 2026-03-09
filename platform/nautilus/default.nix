{
  stdenv,
  fetchurl,
  pkg-config,
  libxml2,
  dbus-glib,
  shared-mime-info,
  libexif,
  gtk2,
  gnome-desktop,
  libunique,
  intltool,
  GConf,
  libSM,
}:

stdenv.mkDerivation rec {
  pname = "nautilus";
  version = "2.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/nautilus/2.32/nautilus-2.32.1.tar.bz2";
    sha256 = "sha256-PXKRaC7Qzf6V9fr4AQRSjwr/smMwAH8I3XpB1+IbA0k=";
  };
  buildInputs = [
    pkg-config
    libxml2
    dbus-glib
    shared-mime-info
    libexif
    gtk2
    gnome-desktop
    libunique
    intltool
    GConf
    libSM
  ];
  NIX_LDFLAGS = "-lgmodule-2.0";
}
