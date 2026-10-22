{
  config,
  inputs,
  pkgs,
  unpkgs,
  ...
}: {
  imports = [
    ./modules/bash.nix
    ./modules/git.nix
  ];

  home = {
    username = "sass";
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "26.05";
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    kdePackages.yakuake
    kdePackages.partitionmanager
    inputs.custom-packages.packages.${pkgs.stdenv.hostPlatform.system}.thorium-avx2
    scrcpy
    unzip
    pince
    gparted
    parted
    haruna
    tree
    vscodium-fhs
    unrar
    activate-linux
    discord
    cowsay

    # Приколы
    fortune

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Автозапуск yakuake
  xdg.configFile."autostart/yakuake.desktop".text = ''
    [Desktop Entry]
    Exec=${pkgs.kdePackages.yakuake}/bin/yakuake
    Name=Yakuake
    Type=Application
    Terminal=false
    NoDisplay=false
  '';

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/sass/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Другие настроки:
#     programs.emacs = {
#     enable = true;
#     extraPackages = epkgs: [
#       epkgs.nix-mode
#       epkgs.magit
#     ];
#   };
#
#   services.gpg-agent = {
#     enable = true;
#     defaultCacheTtl = 1800;
#     enableSshSupport = true;
#   };
}
