{
  config,
  lib,
  hostVariables,
  ...
}: let
  cfg = hostVariables.opencloud;
  url =
    if cfg.url != null
    then cfg.url
    else "http://${hostVariables.host}:${toString cfg.port}";
in {
  options.modules.homelab.opencloud = {
    enable = lib.mkEnableOption "OpenCloud";
  };

  config = lib.mkIf config.modules.homelab.opencloud.enable {
    services.opencloud = {
      enable = true;
      address = cfg.address;
      port = cfg.port;
      inherit url;
      stateDir = cfg.stateDir;
      environment = cfg.environment;
      environmentFile = cfg.environmentFile;
    };

    networking.firewall.interfaces.${cfg.networkInterface}.allowedTCPPorts = [
      cfg.port
    ];
  };
}
