{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
}:

mkDerivation rec {
  pname = "hicolor-icon-theme";
  version = "0.12";

  src = fetchurl {
    url = "https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.12.tar.gz";
    sha256 = "sha256-ntymkGF+qhkFSVHKU1AcgCGAJivoiA7YR1SsRsk77HM=";
  };

  buildInputs = [
  ];
}
