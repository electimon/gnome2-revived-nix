{ fetchurl, stdenv, pkg-config, gstreamer0_10_plugins_base, aalib, cairo
, flac, libjpeg, zlib, speex, libpng, libdv, libcaca, libvpx
, libiec61883, libavc1394, taglib_1, pulseaudio, gdk-pixbuf, orc
, glib, gstreamer0_10, bzip2, libsoup, libintl, mkDerivation
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-good-0.10.31";

  src = fetchurl {
    urls = [
      "http://gstreamer.freedesktop.org/src/gst-plugins-good/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "1ijswgcrdp243mfsyza31fpzq6plz40p4b83vkr2x4x7807889vy";
  };

  patches = [ ./v4l.patch ./v4l-2.patch ./fixup-new-glib.diff ];

  postPatch = ''
    find . -name Makefile.in -exec sed -i 's/\\#include/#include/g' {} +
  '';

  configureFlags = [ "--enable-experimental" "--disable-oss" ];

  buildInputs =
    [ pkg-config glib gstreamer0_10_plugins_base pulseaudio libintl ]
      ++ [ aalib libcaca cairo libdv flac libjpeg libpng speex
        taglib_1 bzip2 libvpx gdk-pixbuf orc libsoup ];

  propagatedBuildInputs = [ gstreamer0_10 ];

  enableParallelBuilding = true;
}
