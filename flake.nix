# flake.nix
# Используется как точка входа для NixOS и home-manager
#  - nixos-rebuild switch --flake /etc/nixos/#nixos  - для системы
#  - home-manager switch --flake /etc/nixos/#sass@nixos  - для пользователя
{
  description = "NixOS & Home Manager - All-in-One";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    zapret-discord-youtube.url = "github:kartavkun/zapret-discord-youtube";
    custom-packages = {
      url = "github:Rishabh5321/custom-packages-flake"; # Кастомные пакеты Рисхаба
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    creamlinux-installer = {
      type = "github";
      owner = "Novattz";
      repo = "creamlinux-installer";
      flake = false;
    };

    # nix-flatpak для декларативной установки флатпаков
#     nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, custom-packages, zapret-discord-youtube, home-manager, creamlinux-installer, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    unpkgs = import nixpkgs-unstable {
      localSystem = system;
      config = { allowUnfree = true; };
    };
  in
  {
    packages.x86_64-linux = import ./pkgs nixpkgs.legacyPackages.x86_64-linux;
    overlays = import ./overlays { inherit inputs; };

  # Сборка всей системы; sudo nixos rebuid switch --flake ./#nixos
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs unpkgs; };

    modules = [
      # Основная системная конфигурация
      ./nixos/configuration.nix

      ({ pkgs, ... }: {
          environment.systemPackages = [
            (import creamlinux-installer { inherit pkgs; })
          ];
        })

      # Интеграция home-manager в систему
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs unpkgs; };
        home-manager.users.sass = import ./home-manager/home.nix;
      }

      ({ ... }: {
        nixpkgs.overlays = [
          inputs.self.overlays.additions

          # You can also pass inline modules directly
#         ({ config, pkgs, ... }: {
#           networking.hostName = "my-hostname";
#           environment.systemPackages = [ pkgs.git ];
#         })
        ];
      })

      # Модуль zapret
      inputs.zapret-discord-youtube.nixosModules.withTestTools
      {
        services.zapret-discord-youtube = {
          enable = true;
          configName = "general(ALT9)";  # Или любой конфиг из папки configs (general, general(ALT), general (SIMPLE FAKE) и т.д.)
          # Команда для тестов: sudo zapret-test-strategies

          # Game Filter: "null" (отключен), "all" (TCP+UDP), "tcp" (только TCP), "udp" (только UDP)
          gameFilter = "null";  # или "all", "tcp", "udp"

          # Добавляем кастомные домены в list-general-user.txt
          listGeneral = [
            # itch.io
            "itch.io"
            "img.itch.zone"
            "html-classic.itch.zone"

            # Fextralife, codevein wiki
            "codevein.wiki.fextralife.com"
            "fextralife.com"

            # Steam
            "store.steampowered.com"
            "steampowered.com"
            "steamcommunity.com"
            "steamstatic.com"
            "steamcontent.com"
            "steamusercontent.com"
            "steamserver.net"
            "s.team"
          ];

          # Добавляем домены в list-exclude-user.txt (исключения)
          listExclude = [ "ubisoft.com" "origin.com" ];

          # Добавляем IP адреса в ipset-all.txt
          ipsetAll = [ "192.168.1.0/24" "10.0.0.1" ];

          # Добавляем IP адреса в ipset-exclude-user.txt (исключения)
          ipsetExclude = [ "203.0.113.0/24" ];
        };
      }
    ];
  }; #  syntax error. expecting ')'

    # === Home Manager (standalone) ===
    # home-manager rebuild switch --flake /etc/nixos
    homeConfigurations."sass@nixos" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      # Every attribute in extraSpecialArgs becomes a module argument, so home.nix or imported modules can declare arguments such as { inputs, ... { }:.
      extraSpecialArgs = { inherit inputs unpkgs; };
      modules = [
        ./home-manager/home.nix
        { home.homeDirectory = "/home/sass"; }
      ];
      # Use home-manager.sharedModules for Home Manager modules or settings that should be imported by every user declared in home-manager.users.
    };
  };
}

# Пример для нескольких машин
# outputs = { self, nixpkgs, ... }: {
#   nixosConfigurations = {
#     main-pc = nixpkgs.lib.nixosSystem {
#       system = "x86_64-linux";
#       modules = [ ./hosts/main-pc/configuration.nix ];
#     };
#     home-server = nixpkgs.lib.nixosSystem {
#       system = "x86_64-linux";
#       modules = [ ./hosts/home-server/configuration.nix ];
#     };
#     work-laptop = nixpkgs.lib.nixosSystem {
#       system = "aarch64-linux"; # Например, если это ARM-ноутбук
#       modules = [ ./hosts/work-laptop/configuration.nix ];
#     };
#   };
# };
