#bash.nix
{
  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos/"; # В версии nixos 25.11 нужно будет убрать "/etc/nixos/" поскольку он будет по умолчанию смотреться в этой директории
      nrr = "sudo nixos-rebuild boot --flake /etc/nixos/";
      hms = "home-manager switch --flake /etc/nixos/";
      ndir = "cd /etc/nixos/nixos";
      nconf = "kate /etc/nixos/nixos/configuration.nix";
      hdir = "cd /etc/nixos/home-manager";
      hconf = "kate /etc/nixos/home-manager/home.nix";
      fmt = "alejandra .";
      # Обновление системы с флейком: обновляет inputs флейка и пересобирает систему
      nru = "sudo nix flake update --flake /etc/nixos/ && sudo nixos-rebuild switch --flake /etc/nixos/";
      # Только обновление inputs флейка
      nfu = "sudo nix flake update --flake /etc/nixos/";
    };
  };
}
