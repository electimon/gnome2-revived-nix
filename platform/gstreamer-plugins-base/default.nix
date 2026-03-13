{
  fetchurl,
  stdenv,
  pkg-config,
  python,
  libX11,
  libXv,
  alsa-lib,
  cdparanoia,
  libogg,
  libtheora,
  libvorbis,
  freetype,
  pango,
  liboil,
  glib,
  cairo,
  orc,
  libintl,
  gstreamer0_10,
  mkDerivation,
  gnome_vfs,
  linuxHeaders,
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-0.10.36";

  src = fetchurl {
    urls = [
      "http://gstreamer.freedesktop.org/src/gst-plugins-base/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
    ];
    sha256 = "0jp6hjlra98cnkal4n6bdmr577q8mcyp3c08s3a02c4hjhw5rr0z";
  };

  postPatch = ''
    sed -i 's@/bin/echo@echo@g' configure
    sed -i -e 's/^   /\t/' docs/{libs,plugins}/Makefile.in
    find . -name Makefile.in -exec sed -i 's/\\#include/#include/g' {} +
  '';

  # TODO : v4l, libvisual
  buildInputs = [
    pkg-config
    glib
    cairo
    orc
    libintl
  ]
  # can't build alsaLib on darwin
  ++ [
    libX11
    libXv
    libogg
    libtheora
    libvorbis
    freetype
    pango
    liboil
    cdparanoia
    alsa-lib
    linuxHeaders
    gnome_vfs
  ];

  propagatedBuildInputs = [ gstreamer0_10 ];

  postInstall = "rm -rf $out/share/gtk-doc";

  patches = [ ./fix-pointer-cast.patch ];
}
