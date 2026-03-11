{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  which,
  libxslt,
  docbook_xml_dtd_412,
  docbook-xsl-nons,
  libxml2-2_9,
}:

mkDerivation rec {
  pname = "scrollkeeper";
  version = "0.3.14";

  src = fetchurl {
    url = "https://download.gnome.org/sources/scrollkeeper/0.3/scrollkeeper-0.3.14.tar.bz2";
    sha256 = "sha256-7OGYcWnRNqoUjcAvHkeEy+XRohz2clA5VH8UF+TrwSI=";
  };
  configureFlags = [ "--with-xml-catalog=${docbook_xml_dtd_412}/xml/dtd/docbook/catalog.xml" ];
  propagatedBuildInputs = [
    which
    libxml2-2_9
    libxslt
  ]; # autogen.sh which is using gnome-common tends to require which
  nativeBuildInputs = [
    docbook_xml_dtd_412
    docbook-xsl-nons
  ];

  postInstall = ''
      mkdir -p $out/nix-support

      cat > $out/nix-support/setup-hook <<'EOF'
    addScrollkeeperStub() {
      fakebin="$TMPDIR/scrollkeeper-stub"
      mkdir -p "$fakebin"

      cat > "$fakebin/scrollkeeper-update" <<'SH'
    #!/bin/sh
    exit 0
    SH

      chmod +x "$fakebin/scrollkeeper-update"
      export PATH="$fakebin:$PATH"
    }

    preInstallHooks+=(addScrollkeeperStub)
    EOF
  '';
}
