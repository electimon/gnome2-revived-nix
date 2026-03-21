{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  gtk2,
  glib,
  libwnck2,
  librsvg,
  GConf,
  libgtop,
  gnome-icon-theme,
  dbus-glib,
  libxml2,
  glibmm,
  gtkmm2,
  gnome-doc-utils
}:

mkDerivation rec {
  pname = "gnome-system-monitor";
  version = "2.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-system-monitor/${lib.versions.majorMinor version}/gnome-system-monitor-${version}.tar.bz2";
    sha256 = "sha256-JbJWavM2xE3Cea/XpSLjYWtoBH8aGjTIpQJKUviUQps=";
  };

  buildInputs = [
    gtk2
    dbus-glib
    libwnck2
    librsvg
    GConf
    libgtop
    libxml2
    glibmm
    gtkmm2
  ];
  nativeBuildInputs = [
    gnome-icon-theme
    gnome-doc-utils
  ];
  CXXFLAGS = [ "-std=gnu++11" ];
  postPatch = '' substituteInPlace ./src/lsof.cpp --replace "static_cast<std::ostringstream&>" "" '';
  NIX_LDFLAGS = "-lgmodule-2.0";
}
