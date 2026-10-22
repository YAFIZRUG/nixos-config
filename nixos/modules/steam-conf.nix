{
  pkgs,
  unpkgs,
  config,
  ...
}: {
  # Набор оптимизаций, которые включаются по запросу игры.
  programs.gamemode.enable = true;
  # Для запуска гейммода нужно прописать в параметрах запуска программы gamemoderun %command%
  # Убедиться, что GameMode работает, можно командой gamemoded -s.
  # Для детальной проверки всех оптимизаций используйте gamemoded -t

  environment.systemPackages = with pkgs; [
    protonup-ng # Используй protonup команду для обновления протона
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATH = "${config.users.users.sass.home}.steam/root/compatibilitytools.d";
  };

  # Gamescope - инструмент для запуска Steam Big Picture
#   programs.gamescope = {
#     enable = true;
#     capSysNice = true; # Позволяет Gamescope повысить свой приоритет в системе
#   };

  programs.steam = {
    enable = true;
    package = unpkgs.steam;
#     gamescopeSession.enable = true;
    remotePlay.openFirewall = true; # Открывает порты для Steam Remote Play.
    dedicatedServer.openFirewall = true; # Открывает порты для выделенных серверов.
  };
}
