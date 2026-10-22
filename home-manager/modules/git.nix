{
  programs.git = {
    enable = true;
    ignores = [ "*.swp" "*.tmp" "*~"];
    lfs.enable = true;
    settings = {
      user.name = "YAFIZRUG";
      user.email = "sanko.veselkin@bk.ru";
      init.defaultBranch = "main";
      pull.rebase = true;
      safe.directory = "/etc/nixos";
      aliases = {
        co = "checkout";
        br = "branch";
        st = "status";
      };
    };
    # Возможно сделать общий файл для Игнора в будующем
#     programs.git.ignores = import ./gitignore_global.nix;

#       # gitignore_global.nix
#       ## MacOS (https://github.com/github/gitignore/blob/4488915eec0b3a45b5c63ead28f286819c0917de/Global/macOS.gitignore)
#
#       #### General:
#       ".AppleDouble"
#       ".LSOverride"
#       #### ....
#       ]

#     settings.user.name = "YAFIZRUG";
#     settings.user.email = "sanko.veselkin@bk.ru";
#     settings.init.defaultBranch = "main";
#     settings.pull.rebase = true;
#     settings.aliases = {
#           co = "checkout";
#           br = "branch";
#           st = "status";
  };
}
