{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  dbus-glib,
  libX11,
  pam,
  systemd,
  polkit,
  autoconf,
  automake,
  libtool,
}:

mkDerivation rec {
  pname = "ConsoleKit2";
  version = "1.2.6";

  src = fetchurl {
    url = "https://github.com/ConsoleKit2/ConsoleKit2/archive/refs/tags/1.2.6.tar.gz";
    sha256 = "sha256-1BIkEpxaaJRp69j+h+NMSnav23svYgHrJGMgJi6lqUI=";
  };
  #  patches = [
  #    ./consolekit-pointer.patch
  #    (fetchurl {
  #      url = "https://github.com/ConsoleKit2/ConsoleKit2/commit/8031482966a20dc80c5a87e4642a24e15cdd8e81.patch";
  #      sha256 = "sha256-vyfi+7MPnmnV/RCs6HdqF92sp+gSIikpKUt5IUxlfwo=";
  #    })
  #  ];
  postPatch = "./autogen.sh ";
  buildInputs = [
    dbus-glib
    libX11
    pam
    systemd
    polkit
  ];
  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];
  configureFlags = [
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--enable-pam-module"
    "--with-pam-module-dir=${placeholder "out"}/lib/security"
  ];
}
