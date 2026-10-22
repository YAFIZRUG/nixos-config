{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 rec {
  pname = "pince";
  version = "0.10.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/korcankaraokcu/PINCE/releases/download/v${version}/PINCE-x86_64.AppImage";
    hash = "sha256-RFRmQAmqTyrafjiXGrjZkhWpF9jz9OIVi3LW7UwJCLg=";
  };

  extraPkgs = pkgs: with pkgs; [
    zstd
  ];

  meta = with lib; {
    description = "Reverse engineering tool for games (Linux alternative to Cheat Engine)";
    homepage = "https://github.com/korcankaraokcu/PINCE";
    license = with licenses; [ gpl3Plus cc-by-30 ];
    platforms = platforms.linux;
    mainProgram = "pince";
  };
}
