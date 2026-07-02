{
  config,
  lib,
  hostVariables,
  ...
}: let
  cfg = hostVariables.netbird.server;
in {
  options.modules.homelab.netbird = {
    enable = lib.mkEnableOption "self-hosted NetBird server";
  };

  config = lib.mkIf config.modules.homelab.netbird.enable {
    assertions = [
      {
        assertion = cfg.domain != "";
        message = "NetBird server needs hostVariables.netbird.server.domain set to a public DNS name.";
      }
      {
        assertion = cfg.oidcConfigEndpoint != "";
        message = "NetBird server needs hostVariables.netbird.server.oidcConfigEndpoint set.";
      }
      {
        assertion = cfg.authAuthority != "";
        message = "NetBird dashboard needs hostVariables.netbird.server.authAuthority set.";
      }
      {
        assertion = !cfg.enableNginx || cfg.acmeEmail != "";
        message = "NetBird nginx/ACME setup needs hostVariables.netbird.server.acmeEmail set.";
      }
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.enableNginx [
      80
      443
    ];

    security.acme = lib.mkIf cfg.enableNginx {
      acceptTerms = true;
      defaults.email = cfg.acmeEmail;
    };

    services.nginx.virtualHosts.${cfg.domain} = lib.mkIf cfg.enableNginx {
      enableACME = true;
      forceSSL = true;
    };

    services.netbird.server = {
      enable = true;
      domain = cfg.domain;
      enableNginx = cfg.enableNginx;

      coturn = {
        enable = cfg.enableCoturn;
        passwordFile = cfg.coturnPasswordFile;
        useAcmeCertificates = cfg.enableNginx;
      };

      dashboard.settings = {
        AUTH_AUTHORITY = cfg.authAuthority;
        AUTH_AUDIENCE = cfg.authAudience;
        AUTH_CLIENT_ID = cfg.authClientId;
        AUTH_REDIRECT_URI = "/nb-auth";
        AUTH_SILENT_REDIRECT_URI = "/nb-silent-auth";
        AUTH_SUPPORTED_SCOPES = cfg.authSupportedScopes;
      };

      management = {
        oidcConfigEndpoint = cfg.oidcConfigEndpoint;

        settings = {
          DataStoreEncryptionKey = {
            _secret = cfg.dataStoreEncryptionKeyFile;
          };
          TURNConfig = {
            Secret = {
              _secret = cfg.turnSecretFile;
            };
          };
        };
      };
    };
  };
}
