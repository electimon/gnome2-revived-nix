{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  gtk2,
  GConf,
  gnome-doc-utils,
  libSM,
  file,
  nautilus
}:

mkDerivation rec {
  pname = "file-roller";
  version = "2.33";

  src = fetchurl {
    url = "https://github.com/electimon/file-roller/releases/download/2.33/file-roller-2.32.2.tar.gz";
    sha256 = "11ff0ebedcc4d1b58b50fc5ac3aec52705dde9a28fa95c1fc1ceff9147872d5f";
  };

  buildInputs = [ gtk2 GConf libSM file.dev ] ++
  []; #  [ nautilus ]; # TODO, fix compilation with this enabled
  nativeBuildInputs = [ gnome-doc-utils ];
  configureFlags = [ "--enable-magic" ];
}
