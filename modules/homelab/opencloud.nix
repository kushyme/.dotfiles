{
  config,
  lib,
  hostVariables,
  pkgs,
  ...
}: let
  cfg = hostVariables.opencloud;
  url =
    if cfg.url != null
    then cfg.url
    else "https://${hostVariables.host}:${toString cfg.port}";
in {
  options.modules.homelab.opencloud = {
    enable = lib.mkEnableOption "OpenCloud";
  };

  config = lib.mkIf config.modules.homelab.opencloud.enable {
    services.opencloud = {
      enable = true;
      package = pkgs.unstable.opencloud;
      webPackage = pkgs.unstable.opencloud.web;
      idpWebPackage = pkgs.unstable.opencloud.idp-web;
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
