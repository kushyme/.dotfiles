{
  config,
  pkgs,
  lib,
  hostVariables,
  ...
}: let
  cfg = hostVariables.couchdb;
  couchdb = config.services.couchdb;

  putDb = name: ''
    response="$(mktemp)"
    status="$(
      curl -sS -o "$response" -w "%{http_code}" \
        -u "${cfg.adminUser}:$password" \
        -X PUT "http://127.0.0.1:${toString cfg.port}/${name}"
    )"

    case "$status" in
      201|202|412)
        ;;
      *)
        cat "$response" >&2
        echo "Failed to create CouchDB database ${name}: HTTP $status" >&2
        exit 1
        ;;
    esac
    rm -f "$response"
  '';
in {
  options.modules.homelab.couchdb = {
    enable = lib.mkEnableOption "CouchDB for Obsidian Self-hosted LiveSync";
  };

  config = lib.mkIf config.modules.homelab.couchdb.enable {
    assertions = [
      {
        assertion = cfg.adminPasswordFile != "";
        message = "CouchDB needs hostVariables.couchdb.adminPasswordFile set.";
      }
      {
        assertion = builtins.match "[a-z][a-z0-9_$()+-]*" cfg.databaseName != null;
        message = "CouchDB databaseName must be lowercase and URL-safe.";
      }
    ];

    services.couchdb = {
      enable = true;
      bindAddress = cfg.address;
      port = cfg.port;
      adminUser = cfg.adminUser;

      extraConfig = {
        couchdb = {
          single_node = true;
          max_document_size = "50000000";
        };
        chttpd = {
          require_valid_user = true;
          enable_cors = true;
          max_http_request_size = "4294967296";
        };
        chttpd_auth = {
          require_valid_user = true;
        };
        httpd = {
          WWW-Authenticate = ''Basic realm="couchdb"'';
          enable_cors = true;
        };
        cors = {
          credentials = true;
          origins = cfg.corsOrigins;
          methods = "GET, PUT, POST, HEAD, DELETE";
          headers = "accept, authorization, content-type, origin, referer";
        };
      };
    };

    networking.firewall.interfaces.${cfg.networkInterface}.allowedTCPPorts = [
      cfg.port
    ];

    systemd.tmpfiles.rules = [
      "d /var/lib/couchdb/secrets 0750 root couchdb - -"
    ];

    systemd.services.couchdb.preStart = lib.mkAfter ''
      if [ ! -r "${cfg.adminPasswordFile}" ]; then
        echo "Missing CouchDB admin password file: ${cfg.adminPasswordFile}" >&2
        echo "Create it with: sudo install -m 0640 -o root -g couchdb /dev/stdin ${cfg.adminPasswordFile}" >&2
        exit 1
      fi

      password="$(tr -d '\n' < "${cfg.adminPasswordFile}")"
      if [ -z "$password" ]; then
        echo "CouchDB admin password file is empty: ${cfg.adminPasswordFile}" >&2
        exit 1
      fi

      cat > "${couchdb.configFile}" <<EOF
      [admins]
      ${cfg.adminUser} = $password
      EOF
      chmod 0640 "${couchdb.configFile}"
    '';
    systemd.services.couchdb.unitConfig.ConditionPathExists = cfg.adminPasswordFile;

    systemd.services.obsidian-livesync-couchdb-init = {
      description = "Initialise CouchDB databases for Obsidian Self-hosted LiveSync";
      after = ["couchdb.service"];
      requires = ["couchdb.service"];
      wantedBy = ["multi-user.target"];
      path = [
        pkgs.coreutils
        pkgs.curl
      ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      unitConfig.ConditionPathExists = cfg.adminPasswordFile;

      script = ''
        if [ ! -r "${cfg.adminPasswordFile}" ]; then
          echo "Missing CouchDB admin password file: ${cfg.adminPasswordFile}" >&2
          exit 1
        fi

        password="$(tr -d '\n' < "${cfg.adminPasswordFile}")"

        for attempt in $(seq 1 60); do
          if curl -fsS -u "${cfg.adminUser}:$password" "http://127.0.0.1:${toString cfg.port}/" >/dev/null; then
            break
          fi

          if [ "$attempt" -eq 60 ]; then
            echo "CouchDB did not become ready in time" >&2
            exit 1
          fi

          sleep 1
        done

        ${putDb "_users"}
        ${putDb "_replicator"}
        ${putDb "_global_changes"}
        ${putDb cfg.databaseName}
      '';
    };
  };
}
