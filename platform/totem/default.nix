{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  gstreamer0_10,
  gstreamer0_10_plugins_base,
  gstreamer0_10_plugins_good,
  gtk2,
  glib,
  gnome-doc-utils,
  GConf
}:

mkDerivation rec {
  pname = "totem";
  version = "2.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/totem/${lib.versions.majorMinor version}/totem-${version}.tar.bz2";
    sha256 = "sha256-mC1qrso+SERpT8CiVA15K+p1PiS1XPMyAxiLMrWRT0c=";
  };
  buildInputs = [ gstreamer0_10 gstreamer0_10_plugins_base gstreamer0_10_plugins_good gtk2 glib GConf ];
  nativeBuildInputs = [ gnome-doc-utils ];
}
