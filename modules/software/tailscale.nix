{
  config,
  lib,
  hostVariables,
  ...
}: let
  cfg = hostVariables.tailscale.client;
in {
  options.modules.software.tailscale = {
    enable = lib.mkEnableOption "Tailscale client";
  };

  config = lib.mkIf config.modules.software.tailscale.enable {
    services.tailscale = {
      enable = true;

      inherit
        (cfg)
        authKeyFile
        disableTaildrop
        interfaceName
        openFirewall
        permitCertUid
        port
        useRoutingFeatures
        ;

      authKeyParameters = {
        inherit (cfg) ephemeral preauthorized;
      };

      # `tailscale up` only runs when an auth key is present, so login-server
      # and advertised routes have to ride along with the up flags.
      extraUpFlags =
        cfg.extraUpFlags
        ++ lib.optional (cfg.loginServer != null) "--login-server=${cfg.loginServer}"
        ++ lib.optional (cfg.advertiseRoutes != []) "--advertise-routes=${lib.concatStringsSep "," cfg.advertiseRoutes}"
        ++ lib.optional cfg.advertiseExitNode "--advertise-exit-node";

      extraSetFlags =
        cfg.extraSetFlags
        ++ lib.optional (cfg.advertiseRoutes != []) "--advertise-routes=${lib.concatStringsSep "," cfg.advertiseRoutes}"
        ++ lib.optional cfg.advertiseExitNode "--advertise-exit-node";
    };
  };
}
