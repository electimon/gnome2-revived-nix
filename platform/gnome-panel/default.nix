{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  python2,
  libSM,
  libICE,
  gtk2,
  dbus-glib,
  GConf,
  gnome-menus,
  libcanberra-gtk2,
  gnome-desktop,
  libwnck2,
  librsvg,
  libgweather,
  gnome-doc-utils,
  libxml2,
  libxslt,
  libbonobo,
  libbonoboui,
  scrollkeeper,
}:

mkDerivation rec {
  pname = "gnome-panel";
  version = "2.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-panel/${lib.versions.majorMinor version}/gnome-panel-${version}.tar.bz2";
    sha256 = "sha256-j3go63ohyBenO2l4RKTiAlYFmzI4ZBShD5fVHn2fyl8";
  };

  NIX_LDFLAGS = "-lgmodule-2.0 -lm ";
  buildInputs = [
    libSM
    libICE
    gtk2
    dbus-glib
    GConf
    gnome-menus
    libcanberra-gtk2
    gnome-desktop
    libwnck2
    librsvg
    libgweather
    libxml2
    libxslt
    libbonoboui
    libbonobo
  ];
  nativeBuildInputs = [
    python2
    libSM
    libICE
    gtk2
    dbus-glib
    GConf
    gnome-menus
    libcanberra-gtk2
    gnome-desktop
    libwnck2
    librsvg
    libgweather
    gnome-doc-utils
    libxml2
    libxslt
    scrollkeeper
  ];
  propagatedBuildInputs = [ which ]; # autogen.sh which is using gnome-common tends to require which

  configureFlags = [ "--enable-bonobo" ];

  patches = [ ./0001-every-little-thought-is-a-different-sound-compile-fi.patch ];

  NIX_CFLAGS_COMPILE = [
    "-I${GConf}/include/gconf/2" # fucking bonobo build path isnt including this path even though all the other makefiles do, i need 2 patch this but i cba rn
    "-Wno-implicit-function-declaration" # how fucking broken is this shit?? panel-applets-bonobo-module.c:32:9: error: implicit declaration of function 'panel_applets_manager_bonobo_register'; did you mean 'panel_applets_manager_bonobo_get_type'?
    # HELLO??
  ];
}
