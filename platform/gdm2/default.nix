{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  libX11,
  glib,
  gtk2,
  GConf,
  gnome-doc-utils,
  libxml2,
  libxdmcp,
  libcanberra-gtk2, 
  gnome-panel,
  pam,
  xorgserver,
  ConsoleKit2,
  dbus,
  gnome-session
}:

mkDerivation rec {
  pname = "gdm";
  version = "2.30.7";

  src = fetchurl {
    url = "mirror://gnome/sources/gdm/${lib.versions.majorMinor version}/gdm-${version}.tar.bz2";
    sha256 = "sha256-2LJY+wspTMbNlxXnN1V4przCjIKd+NEIBdbL9IevYPI=";
  };

  buildInputs = [
    libX11
    gtk2
    glib
    GConf
    libxml2
    libxdmcp
    libcanberra-gtk2
    gnome-panel
    pam
  ];
  nativeBuildInputs = [
    gnome-doc-utils
  ];
  patches = [ ./gdm-2.30.2-fixes-1.patch ./add-missing-dbus-daemon-dir-option.diff ./load-xdg.diff ./add-xsessions-path.diff ];
  configureFlags = [ "--with-xauth-dir=/var/run/gdm" "--with-dbus-daemon-dir=${dbus.lib}/bin" ];
  postConfigure = ''
    sed -i "s;X_SERVER;\"${xorgserver}/bin/Xorg\";g" daemon/gdm-server.c
    sed -i "s;LIBEXECDIR;\"${ConsoleKit2}/libexec\";g" daemon/gdm-server.c
    sed -i "s;DBUS_LAUNCH_DIR;\"${dbus.lib}/bin/dbus-launch\";g" daemon/gdm-welcome-session.c
    sed -i "s;BINDIR;\"${gnome-session}/bin\";g" daemon/gdm-greeter-session.c
  '';
}
