{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  dbus-glib,
  glib,
  gtk2,
  GConf,
  gnome-desktop,
  libxklavier,
  libgnomekbd,
  libSM,
  pulseaudio,
  polkit,
  libnotify,
  libcanberra-gtk2
}:

mkDerivation rec {
  pname = "gnome-settings-daemon";
  version = "2.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${lib.versions.majorMinor version}/gnome-settings-daemon-${version}.tar.bz2";
    sha256 = "sha256-1esCcAKPBy6NNsYeRnfVWERmnZqwnVJfbHa0mA7IHJ4=";
  };

  buildInputs = [
    dbus-glib
    glib
    gtk2
    GConf
    gnome-desktop
    libxklavier
    libgnomekbd
    libSM
    polkit
    libnotify
    libcanberra-gtk2
  ];
  nativeBuildInputs = [
    dbus-glib
    glib
    gtk2
    GConf
    gnome-desktop
    libxklavier
    libgnomekbd
    libSM
    pulseaudio
  ];
  propagatedBuildInputs = [ which ]; # autogen.sh which is using gnome-settings-daemon tends to require which

  patches = [
    ./0001-PATCH-region-panel-add-keys-removed-from-libgnomekbd.patch
    ./0002-two-more-fixes-for-libnotify.patch
    ./0003-housekeeping-Support-new-thumbnails-path-for-newer-g.patch
    ./0004-fixing-issue-with-Control-key-at-keybinding.patch
    ./0005-media-keys-React-to-stream-removed-signal-from-GvcMi.patch
  ];
}
