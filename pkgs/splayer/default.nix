{
  pkgs,
  lib,
  ...
}:
pkgs.stdenvNoCC.mkDerivation rec {
  pname = "splayer";
  version = "v3.0.0-beta.1";

  src = pkgs.fetchurl {
    url = "https://github.com/imsyy/SPlayer/releases/download/v3.0.0-beta.1/splayer_3.0.0-beta.1_amd64.deb";
    hash = "sha256-LFgiTHYwpvMbV36RCb56TlwJKYTXZkLUkouI4oy85vY=";
  };

  nativeBuildInputs = with pkgs; [
    dpkg
    makeWrapper
  ];

  buildInputs = with pkgs; [
    glib
    nss
    nspr
    dbus.lib
    at-spi2-atk
    cups.lib
    libdrm
    gtk3
    pango
    cairo
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    libgbm
    expat
    xorg.libxcb
    libxkbcommon
    alsa-lib
  ];

  phases = [
    "buildPhase"
  ];

  buildPhase = ''
    dpkg -x $src ./
    mkdir -p $out
    mv ./usr/share $out/share
    mv ./opt/SPlayer $out/
    substituteInPlace $out/share/applications/splayer.desktop \
      --replace-fail "/opt/SPlayer/splayer" "$out/bin/splayer"
    makeWrapper $out/SPlayer/splayer $out/bin/splayer \
      --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"
  '';

  meta = with lib; {
    description = "A simple music player";
    homepage = "https://github.com/imsyy/SPlayer";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
  };
}
