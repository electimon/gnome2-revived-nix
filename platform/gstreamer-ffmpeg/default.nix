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
  ffmpeg,
  yasm
}:

stdenv.mkDerivation rec {
  name = "gst-ffmpeg-0.10.13";

  src = fetchurl {
    urls = [
      "http://gstreamer.freedesktop.org/src/gst-ffmpeg/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
    ];
    sha256 = "sha256-dvygWwjgATTjy5L6NHUH9Cy9SN2wjtM0OpEt7xh/u2I=";
  };

  postPatch = ''
    find . -name Makefile.in -exec sed -i 's/\\#include/#include/g' {} +
    find . -type f -print0 | xargs -0 sed -i 's/ORC_TARGET_ALTIVEC_ALTIVEC/ORC_TARGET_POWERPC_ALTIVEC/g'
#    find . -name *.mak -exec sed -i 's/\\#include/#include/g' {} +
  '';

  patches = [ ./gst-ffmpeg-0.10.13-gcc-4.7-1.patch ./fix-mathops.patch ];

  buildInputs = [
    pkg-config
    glib
    gstreamer0_10_plugins_base
    libintl
    bzip2
    orc
    ffmpeg
  ];

  nativeBuildInputs = [ yasm ];

  propagatedBuildInputs = [ gstreamer0_10 ];

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = [ "-Wno-incompatible-pointer-types" "-Wno-error=format-security" ];
}
