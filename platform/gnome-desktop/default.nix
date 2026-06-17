{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  libX11,
  glib,
  gtk2,
  GConf,
  python2,
  gnome-doc-utils,
  libxml2,
  pygtk,
  pycairo,
  pygobject,
  makeWrapper
}:

mkDerivation rec {
  pname = "gnome-desktop";
  version = "2.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-desktop/${lib.versions.majorMinor version}/gnome-desktop-${version}.tar.bz2";
    sha256 = "sha256-Vcvs9n7+H6HleslmUgp8RteZyLo8ZSoSGfYMr8yzc50";
  };

  buildInputs = [
    libX11
    gtk2
    glib
    GConf
    libxml2
    pygtk # for gnome-about
  ];
  propagatedBuildInputs = [ which ]; # autogen.sh which is using gnome-desktop tends to require which
  nativeBuildInputs = [
    libX11
    gtk2
    glib
    GConf
    python2
    gnome-doc-utils
    libxml2
    makeWrapper
  ];

  patches = [
    ./0001-1440-compile-fix.patch
    ./0001-fix-thumbnails-with-glib-2.34.patch
  ];

  postFixup = ''
    wrapProgram $out/bin/gnome-about \
      --prefix PYTHONPATH : "${pygtk}/lib/python2.7/site-packages" \
      --prefix PYTHONPATH : "${pygtk}/lib/python2.7/site-packages/gtk-2.0" \
      --prefix PYTHONPATH : "${pygobject}/lib/python2.7/site-packages" \
      --prefix PYTHONPATH : "${pycairo}/lib/python2.7/site-packages"
  '';
}
