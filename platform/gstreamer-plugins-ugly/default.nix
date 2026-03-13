{
  fetchurl,
  stdenv,
  pkg-config,
  gstreamer0_10_plugins_base,
  libvpx,
  gdk-pixbuf,
  orc,
  glib,
  gstreamer0_10,
  bzip2,
  libintl,
  mkDerivation,
  libmad,
  libcdio,
  libmpeg2,
  x264,
  twolame,
  libdvdread
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-ugly-0.10.19";

  src = fetchurl {
    urls = [
      "http://gstreamer.freedesktop.org/src/gst-plugins-ugly/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
    ];
    sha256 = "sha256-HKkAWSdcD13KcdTRYBqPQpt4UrrtByPoIHA7l34sjfA=";
  };

  postPatch = ''
        find . -name Makefile.in -exec sed -i 's/\\#include/#include/g' {} +
    #    find . -name *.mak -exec sed -i 's/\\#include/#include/g' {} +
  '';

  patches = [ ./cdio-cd-text-api.patch ];

  configureFlags = [
  ];

  buildInputs = [
    pkg-config
    glib
    gstreamer0_10_plugins_base
    libintl
    bzip2
    orc
    libmad
    libcdio
    libmpeg2
    x264
    twolame
    libdvdread
  ];

  propagatedBuildInputs = [ gstreamer0_10 ];

  enableParallelBuilding = true;
}
