{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  glib,
  gtk2,
  libgcrypt,
  libtasn1,
  GConf,
  pam
}:

mkDerivation rec {
  pname = "gnome-keyring";
  version = "2.30.3";

  src = fetchurl {
    url = "https://download.gnome.org/sources/gnome-keyring/2.30/gnome-keyring-2.30.3.tar.bz2";
    sha256 = "sha256-sk5cbbYhiX8qAEXwCD4fh41hf1yAHTicLOAoosZ+KQs=";
  };

  buildInputs = [
    glib
    gtk2
    libgcrypt
    libtasn1
    GConf
    pam
  ];
  configureFlags = [ "--enable-acl-prompts" "--enable-ssh-agent" ];
  NIX_CFLAGS_COMPILE = [
    "-Wno-incompatible-pointer-types"
  ];
}
