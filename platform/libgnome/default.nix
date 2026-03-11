{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  gnome_vfs,
  libcanberra,
  libbonobo,
  glib,
}:

mkDerivation rec {
  pname = "libgnome";
  version = "2.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnome/${lib.versions.majorMinor version}/libgnome-${version}.tar.bz2";
    sha256 = "sha256-ssY5FoZkhXk7hzmCZt13eFSMFzSSPCcqlNhO4BG296Q=";
  };

  buildInputs = [
    gnome_vfs
    libcanberra
    glib
    libbonobo
  ];
  nativeBuildInputs = [
    gnome_vfs
    libcanberra
    glib
    libbonobo
  ];
  propagatedBuildInputs = [ which ]; # autogen.sh which is using libgnome tends to require which
}
