{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "mplayer-skins";
  version = "1";

  src = pkgs.fetchurl {
    url = "http://www.mplayerhq.hu/MPlayer/skins/Blue-1.13.tar.bz2";
    sha256 = "sha256-HJFtgYJ+Y2ijqNsMOquKgu8un4ZNt4ChlM92ie7CzcU=";
  };

  installPhase = ''
    mkdir -p $out/share/mplayer/skins
    tar -xjf $src -C $out/share/mplayer/skins
    ln -s $out/share/mplayer/skins/Blue $out/share/mplayer/skins/default
  '';
}
