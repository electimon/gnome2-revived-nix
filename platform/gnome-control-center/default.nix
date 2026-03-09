{
  lib,
  stdenv,
  fetchurl,
  which,
  gnome-doc-utils,
  pkg-config,
  intltool,
  libxml2,
  libxslt,
  gtk2,
  glib,
  gnome-desktop,
  GConf,
  gnome-menus,
  libunique,
  metacity,
  gnome-settings-daemon,
  libxklavier,
  libgnomekbd,
  libSM,
  scrollkeeper,
  desktop-file-utils,
}:

stdenv.mkDerivation rec {
  pname = "gnome-control-center";
  version = "2.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-control-center/${lib.versions.majorMinor version}/gnome-control-center-${version}.tar.bz2";
    sha256 = "sha256-17CefgczPai0aKGyr3pkzRLhvyvVDFfiwA5MMGQvEC8=";
  };

  configureFlags = [ "--disable-update-mimedb" ];
  buildInputs = [
    gtk2
    glib
    libxml2
    libxslt
    gnome-desktop
    GConf
    gnome-menus
    libunique
    gnome-settings-daemon
    libxklavier
    libgnomekbd
    libSM
  ];
  nativeBuildInputs = [
    gnome-doc-utils
    pkg-config
    intltool
    gtk2
    glib
    libxml2
    libxslt
    gnome-desktop
    GConf
    gnome-menus
    libunique
    metacity
    gnome-settings-daemon
    libxklavier
    libgnomekbd
    libSM
    scrollkeeper
    desktop-file-utils
  ];
  propagatedBuildInputs = [ which ]; # autogen.sh which is using gnome-control-center tends to require which
  NIX_LDFLAGS = "-lgmodule-2.0";
}
