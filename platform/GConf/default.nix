{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  dbus-glib,
  glib,
  ORBit2,
  libxml2,
  polkit,
  python312,
  gtk2,
}:

mkDerivation rec {
  pname = "gconf";
  version = "2.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/GConf/${lib.versions.majorMinor version}/GConf-${version}.tar.gz";
    sha256 = "sha256-IhJjfmzN9e+SkxVAjlEUVbzJwV+TL125QlS5llfdNB4";
  };

  # outputs = [
  #   "out"
  #   "dev"
  #   "man"
  # ];

  strictDeps = true;

  buildInputs = [
    ORBit2
    libxml2
    gtk2
  ]
  # polkit requires pam, which requires shadow.h, which is not available on
  # darwin
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) polkit;

  propagatedBuildInputs = [
    glib
    dbus-glib
  ];

  nativeBuildInputs = [
    python312
    glib
  ];

  configureFlags =
    # fixes the "libgconfbackend-oldxml.so is not portable" error on darwin
    lib.optionals stdenv.hostPlatform.isDarwin [ "--enable-static" ];

  postPatch = ''
    2to3 --write --nobackup gsettings/gsettings-schema-convert
    substituteInPlace configure \
      --replace 'pkg-config --variable giomoduledir gio-2.0' 'echo $out/lib/gio/modules'
  '';

  preInstall = ''
    mkdir -p $out/lib/gio/modules
  '';

  meta = {
    homepage = "https://projects.gnome.org/gconf/";
    description = "Deprecated system for storing application preferences";
    platforms = lib.platforms.unix;
  };

  patches = [
    ./0001-liar-dancer-fix-missing-GTK_DIALOG-cast.patch
    ./ok.patch
  ];

  postFixup = ''
    rm -f $out/lib/gio/modules/giomodule.cache
  '';
}
