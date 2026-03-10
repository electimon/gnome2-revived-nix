{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "mplayer-skins";
  version = "1";

  src = pkgs.fetchurl {
    url = "http://www.mplayerhq.hu/MPlayer/skins/Blue-1.13.tar.bz2";
    sha256 = "sha256-HJFtgYJ+Y2ijqNsMOquKgu8un4ZNt4ChlM92ie7CzcU=";
  };

  installPhase = ''
    mkdir -p $out/usr/share/mplayer/skins
    tar -xjf $src -C $out/usr/share/mplayer/skins
  '';
}