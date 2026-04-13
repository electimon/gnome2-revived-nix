{
  lib,
  stdenv,
  mkDerivation,
  fetchgit,
  xmms-gtk2,
  pulseaudio
}:

mkDerivation rec {
  pname = "xmms-pulse";
  version = "0.9.4+git";

  src = fetchgit {
    url = "https://github.com/electimon/xmms-pulse";
    sha256 = "sha256-KFcJh/SVgy1w8T9iMES3C/yxsMGlztokzW6YkSjq98I=";
  };
  buildInputs = [ xmms-gtk2 pulseaudio ];
  configureFlags = [ "--disable-lynx" ];
}
