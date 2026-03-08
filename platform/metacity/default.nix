{
  lib,
  stdenv,
  fetchgit,
  which,
  intltool,
  pkg-config,
  glib,
  gtk2,
  libcanberra-gtk2,
  libXdamage,
  GConf,
  zenity,
  gnome-doc-utils,
}:

stdenv.mkDerivation rec {
  pname = "metacity";
  version = "2.30.3";

  src = fetchgit {
    url = "https://daedalus.yzuinfra.moe/gnome2-revived/metacity-2.30.3.git";
    sha256 = "sha256-mX9gkusObLNngTYa+mL9eXKgMG/eGel9bVriDIjkko4=";
  };

  propagatedBuildInputs = [ which ]; # autogen.sh which is using gnome-common tends to require which

  nativeBuildInputs = [ intltool pkg-config glib gtk2 libcanberra-gtk2 libXdamage GConf zenity gnome-doc-utils ];

  patches = [
  ];
}
