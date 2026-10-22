# pkgs/default.nix
# После подключения этого оверлея вы можете обращаться к пакетам как pkgs.имя_пакета.
# Каждый пакет должен лежать в подпапке pkgs/<имя>/default.nix и быть вызван через callPackage.
pkgs: {
  linux-mouse-fix = pkgs.callPackage ./linux-mouse-fix { };
  pince = pkgs.callPackage ./pince { };
  # Добавьте другие пакеты по аналогии:
  # another-package = prev.callPackage ./another-package { };
}
