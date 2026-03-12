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
  polkit
}:

mkDerivation rec {
  pname = "ConsoleKit";
  version = "0.4.6";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/ConsoleKit/dist/ConsoleKit-0.4.6.tar.xz";
    sha256 = "sha256-tB0X4G+ABZWJ++7+lq0HvMVkxJ5lUW2hyvl1FGR1Vlw=";
  };
  patches = [
    ./consolekit-pointer.patch
  ];
  buildInputs = [ dbus-glib libX11 pam systemd polkit ];
  configureFlags = [ "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system" "--enable-pam-module" "--with-pam-module-dir=${placeholder "out"}/lib/security" ];
}
