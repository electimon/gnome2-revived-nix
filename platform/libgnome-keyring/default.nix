{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
}:

mkDerivation rec {
  pname = "libgnome-keyring";
  version = "2.32.0";

  src = fetchurl {
    url = "https://download.gnome.org/sources/libgnome-keyring/2.32/libgnome-keyring-2.32.0.tar.gz";
    sha256 = "1pz13mpp09q5s3bikm8ml92s1g0scihsm4iipqv1ql3mp6d4z73a";
  };

  propagatedBuildInputs = [ which ]; # autogen.sh which is using gnome-common tends to require which
}
