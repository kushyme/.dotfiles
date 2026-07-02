{
  config,
  pkgs,
  lib,
  hostVariables,
  ...
}: let
  cfg = hostVariables.netbird.client;
in {
  options.modules.software.netbird = {
    enable = lib.mkEnableOption "NetBird client";
  };

  config = lib.mkIf config.modules.software.netbird.enable {
    environment.systemPackages = [
      pkgs.netbird
    ];

    services.netbird = {
      useRoutingFeatures = cfg.useRoutingFeatures;

      clients.default = {
        inherit (cfg) autoStart hardened interface logLevel port;
        name = "netbird";

        environment =
          lib.optionalAttrs (cfg.managementUrl != null) {
            NB_MANAGEMENT_URL = cfg.managementUrl;
          }
          // cfg.environment;

        login = lib.mkIf (cfg.setupKeyFile != null) {
          enable = true;
          setupKeyFile = cfg.setupKeyFile;
        };
      };
    };
  };
}
