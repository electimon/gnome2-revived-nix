{
  pkgs,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  python2,
  gnome-icon-theme,
  glib,
  gtk2,
  gnome-panel,
  gnome-desktop,
  libgtop,
  gnome-settings-daemon,
  libwnck2,
  gnome-doc-utils,
  libgweather,
  gstreamer0_10,
  gstreamer0_10_plugins_base,
}:

mkDerivation rec {
  pname = "gnome-applets";
  version = "2.32.1.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-applets/${pkgs.lib.versions.majorMinor version}/gnome-applets-${version}.tar.bz2";
    sha256 = "sha256-K5L+SzBi374mT0VHK02zon0eaeEyYNN9qfs2ssvUAyc=";
  };

  buildInputs = [
    python2
    gnome-icon-theme
    glib
    gtk2
    gnome-panel
    gnome-desktop
    libgtop
    libwnck2
    gnome-settings-daemon
    libgweather
    gstreamer0_10
    gstreamer0_10_plugins_base
  ];
  nativeBuildInputs = [ gnome-doc-utils ];
  NIX_LDFLAGS = "-lgmodule-2.0 -lm -lX11";
  NIX_CFLAGS_COMPILE = [
    "-Wno-incompatible-pointer-types"
    "-Wno-implicit-function-declaration"
  ]; # todo remove this
  installPhase = ''
    sed -i 's|chmod 4755|echo skipping chmod|g' cpufreq/src/cpufreq-selector/Makefile
    make install
  '';
  configureFlags = [
    "--disable-scrollkeeper"
    "--disable-docs"
    "--enable-mixer-applet"
  ]; # todo fix this
}
