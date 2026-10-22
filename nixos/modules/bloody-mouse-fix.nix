# bloody-mouse-fix.nix
{
  config,
  pkgs,
  ...
}: let
  # Здесь указывается ваш собранный пакет mouse_fix.
  # Если вы собрали его локально, путь может выглядеть так:
  my-package = pkgs.linux-mouse-fix; # TODO: Изменить название переменной
in {
  # 1. Добавляем пакет в окружение системы
  environment.systemPackages = [ my-package ];

  # 2. Объявляем сам systemd-сервис
  systemd.services.mouse_fix = {
    description = "Fix mouse movement issue by merging multiple event files";
    # Указываем, что сервис нужно запускать при загрузке
    wantedBy = [ "multi-user.target" ];
    # Команда для запуска сервиса. Важно использовать полный путь к бинарнику из Nix store
    serviceConfig = {
      ExecStart = "${my-package}/bin/mouse_fix capture";
      Restart = "on-failure";
      User = "root";
      Type = "simple";
    };
  };
}
