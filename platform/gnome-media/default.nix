{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  gtk2,
  glib,
  GConf,
  gstreamer0_10,
  gstreamer0_10_plugins_base,
  gnome-doc-utils
}:

mkDerivation rec {
  pname = "gnome-media";
  version = "2.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-media/${lib.versions.majorMinor version}/gnome-media-${version}.tar.bz2";
    sha256 = "sha256-KwrU3s11QGOY9G6CoXDlO8vG4b3DNj8DoHsA9Zwv5eY=";
  };

  buildInputs = [ gtk2 glib GConf gstreamer0_10 gstreamer0_10_plugins_base gnome-doc-utils ];
  patches = [ ./fix-format-security.patch ];
}
