{ inputs, ... }:
{
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    dates = "monthly";
    flags = [
      "--print-build-logs"
#       "--commit-lock-file" # Коммит lock файла для гита
    ];
    persistent = true;
  };
  # Удаление старых поколений ребилда
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  # Оптимизация хранилища nix. Удаление файлов и переприсвоение им ссылок
  nix.optimise = {
    automatic = true;
    dates = "monthly";
  };
  # Существует возможность выполнять оптимизацию после каждой сборки пакетов
  # nix.settings.auto-optimise-store = true;
}
