{
  lib,
  stdenv,
  fetchurl,
  which,
  yasm,
  gtk2,
  zlib,
  libX11,
  libXext,
  libxv,
  libXScrnSaver,
  xorgproto,
  xorgserver
}:

stdenv.mkDerivation rec {
  pname = "mplayer";
  version = "1.5";

  src = fetchurl {
    url = "http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.5.tar.xz";
    sha256 = "sha256-ZQzVW7PLRMmznONtrEiEKFWXmcXxjRbZjtsrclbLv4U=";
  };

  buildInputs = [ zlib gtk2 libX11 libX11.dev libX11.dev.out libXext libxv libXScrnSaver xorgproto xorgserver ];

  nativeBuildInputs = [ yasm zlib gtk2 libX11 libX11.dev libX11.dev.out libXext libxv libXScrnSaver xorgproto xorgserver ];

  configureFlags = [ "--enable-gui" ];

  NIX_CFLAGS_COMPILE = [ "-Wno-incompatible-pointer-types" "-Wno-int-conversion" ];

  patches = [
    ./fix-binutils-asm.patch
  ];
}
