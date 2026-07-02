{
  lib,
  pkgs,
  config,
  hostVariables,
  ...
}: let
  cfg = config.modules.software.osu;
in {
  options.modules.software.osu = {
    enable = lib.mkEnableOption "osu!lazer";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.osu-lazer-bin;
      defaultText = lib.literalExpression "pkgs.osu-lazer-bin";
      description = "osu! package to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    home-manager.users.${hostVariables.username} = {
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/x-osu-beatmap-archive" = ["osu!.desktop"];
          "application/x-osu-skin-archive" = ["osu!.desktop"];
        };
      };
    };
  };
}
