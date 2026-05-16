{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  glib,
  gtk2,
  gnome-doc-utils,
  GConf,
  gnome-desktop,
  gnome-icon-theme,
  shared-mime-info
}:

mkDerivation rec {
  pname = "eog";
  version = "2.32.1";

  src = fetchurl {
    url = "https://download.gnome.org/sources/eog/2.32/eog-2.32.1.tar.bz2";
    sha256 = "sha256-VDZy+46OMAvyz0x+70O1sWJOLkjmqggBoIOue+stcHg=";
  };

  nativeBuildInputs = [
    gnome-doc-utils
  ];

  buildInputs = [
    GConf
    glib
    gtk2
    gnome-desktop
    gnome-icon-theme
    shared-mime-info
  ];

  NIX_CFLAGS_COMPILE = [ "-Wno-incompatible-pointer-types" ]; # TODO remove
  NIX_LDFLAGS = "-lgmodule-2.0 -lm";
}
