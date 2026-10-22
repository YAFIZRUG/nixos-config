{
  stdenv,
  rustPlatform,
  lib,
  pkg-config,
  udev,
  libevdev,
  makeWrapper,
}:
rustPlatform.buildRustPackage rec {
  pname = "mouse_fix";
  version = "1.1";

  src = ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
    allowBuiltinFetchGit = true;
  };

  nativeBuildInputs = [pkg-config makeWrapper];
  buildInputs = [udev libevdev];

  # Отключаем проверку пути (иначе программа падает, т.к. бинарник не в /usr/local/bin)
  postPatch = ''
    sed -i 's/if current_path != EXE_DIR/if false/' src/main.rs
  '';

  meta = with lib; {
    description = "Linux mouse fix – объединяет несколько устройств мыши в одно виртуальное";
    homepage = "https://github.com/graymind75/linux_mouse_fix";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
