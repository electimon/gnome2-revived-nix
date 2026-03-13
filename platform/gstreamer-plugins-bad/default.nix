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
  faad2,
  faac,
  libopus,
  libcdaudio,
  libass,
  libdvdnav,
  vo-aacenc,
  openal,
  librsvg,
  xvidcore
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-bad-0.10.23";

  src = fetchurl {
    urls = [
      "http://gstreamer.freedesktop.org/src/gst-plugins-bad/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
    ];
    sha256 = "sha256-Dq59GhNXroN3/e1qG0LmY4h76r4ObMM24u+a2kLhFJE=";
  };

  patches = [
    ./drop-vpx-compat-defs.patch
    ./gstcolorspaceorc.orc.patch
    ./cve-1.patch
  ];

  postPatch = ''
    find . -name Makefile.in -exec sed -i 's/\\#include/#include/g' {} +
#    find . -name *.mak -exec sed -i 's/\\#include/#include/g' {} +
  '';

  configureFlags = [
    "--disable-decklink"
    "--disable-nsf"
  ];

  buildInputs = [
    pkg-config
    glib
    gstreamer0_10_plugins_base
    libintl
    bzip2
    orc
    libvpx
    faad2
    faac
    libopus
    libcdaudio
    libass
    libdvdnav
    vo-aacenc
    openal
    librsvg
    xvidcore
  ];

  propagatedBuildInputs = [ gstreamer0_10 ];

  enableParallelBuilding = true;
}
