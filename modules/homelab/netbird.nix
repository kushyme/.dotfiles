{
  config,
  pkgs,
  lib,
  hostVariables,
  ...
}: let
  cfg = hostVariables.netbird;
  client = cfg.client;
  server = cfg.server;

  serverManagementUrl = "https://${server.domain}:443";
  managementUrl =
    if client.managementUrl != null
    then client.managementUrl
    else if server.enable
    then serverManagementUrl
    else null;
in {
  options.modules.homelab.netbird = {
    enable = lib.mkEnableOption "netbird";
  };

  config = lib.mkIf config.modules.homelab.netbird.enable (lib.mkMerge [
    {
      assertions = [
        {
          assertion = !server.enable || server.domain != "";
          message = "NetBird server needs hostVariables.netbird.server.domain set to a public DNS name.";
        }
        {
          assertion = !server.enable || server.oidcConfigEndpoint != "";
          message = "NetBird server needs hostVariables.netbird.server.oidcConfigEndpoint set.";
        }
        {
          assertion = !server.enable || server.authAuthority != "";
          message = "NetBird dashboard needs hostVariables.netbird.server.authAuthority set.";
        }
        {
          assertion = !server.enable || !server.enableNginx || server.acmeEmail != "";
          message = "NetBird nginx/ACME setup needs hostVariables.netbird.server.acmeEmail set.";
        }
      ];

      environment.systemPackages = [
        pkgs.netbird
      ];

      services.netbird.useRoutingFeatures = client.useRoutingFeatures;
    }

    (lib.mkIf client.enable {
      services.netbird.clients.default = {
        inherit (client) autoStart hardened interface logLevel port;
        name = "netbird";

        environment =
          lib.optionalAttrs (managementUrl != null) {
            NB_MANAGEMENT_URL = managementUrl;
          }
          // client.environment;

        login = lib.mkIf (client.setupKeyFile != null) {
          enable = true;
          setupKeyFile = client.setupKeyFile;
        };
      };
    })

    (lib.mkIf server.enable {
      networking.firewall.allowedTCPPorts = lib.mkIf server.enableNginx [
        80
        443
      ];

      security.acme = lib.mkIf server.enableNginx {
        acceptTerms = true;
        defaults.email = server.acmeEmail;
      };

      services.nginx.virtualHosts.${server.domain} = lib.mkIf server.enableNginx {
        enableACME = true;
        forceSSL = true;
      };

      services.netbird.server = {
        enable = true;
        domain = server.domain;
        enableNginx = server.enableNginx;

        coturn = {
          enable = server.enableCoturn;
          passwordFile = server.coturnPasswordFile;
          useAcmeCertificates = server.enableNginx;
        };

        dashboard.settings = {
          AUTH_AUTHORITY = server.authAuthority;
          AUTH_AUDIENCE = server.authAudience;
          AUTH_CLIENT_ID = server.authClientId;
          AUTH_REDIRECT_URI = "/nb-auth";
          AUTH_SILENT_REDIRECT_URI = "/nb-silent-auth";
          AUTH_SUPPORTED_SCOPES = server.authSupportedScopes;
        };

        management = {
          oidcConfigEndpoint = server.oidcConfigEndpoint;

          settings = {
            DataStoreEncryptionKey = {
              _secret = server.dataStoreEncryptionKeyFile;
            };
            TURNConfig = {
              Secret = {
                _secret = server.turnSecretFile;
              };
            };
          };
        };
      };
    })
  ]);
}
