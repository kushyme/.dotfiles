{
  lib,
  pkgs,
  config,
  hostVariables,
  ...
}: let
  cfg = config.modules.software.osu;
  osuMimeTypes =
    pkgs.runCommand "osu-mime-types" {
      nativeBuildInputs = [pkgs.shared-mime-info];
    } ''
      mkdir -p $out/share/mime/packages
      cat > $out/share/mime/packages/osu.xml <<'EOF'
      <?xml version="1.0" encoding="UTF-8"?>
      <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
        <mime-type type="application/x-osu-beatmap-archive">
          <comment>osu! beatmap archive</comment>
          <glob pattern="*.osz"/>
        </mime-type>
        <mime-type type="application/x-osu-skin-archive">
          <comment>osu! skin archive</comment>
          <glob pattern="*.osk"/>
        </mime-type>
        <mime-type type="application/x-osu-replay">
          <comment>osu! replay</comment>
          <glob pattern="*.osr"/>
        </mime-type>
        <mime-type type="application/x-osu-beatmap">
          <comment>osu! beatmap</comment>
          <glob pattern="*.osu"/>
        </mime-type>
      </mime-info>
      EOF
      update-mime-database $out/share/mime
    '';
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
      osuMimeTypes
    ];

    home-manager.users.${hostVariables.username} = {
      xdg.configFile."mimeapps.list".force = true;
      xdg.dataFile."applications/mimeapps.list".force = true;

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
