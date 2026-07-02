{
  username = "erikp";
  host = "default";
  system = "x86_64-linux";
  osLanguage = "en_US.UTF-8";
  keyboardLayout = "de_DE.UTF-8";
  stateVersion = "26.05";
  modules = {
    console = {
      atuin = true;
      fish = false;
      zsh = true;
    };
    driver = {
      nvidia = false;
      amdgpu = false;
    };
    gui = {
      gnome = true;
    };
    homelab = {
      couchdb = false;
      netbird = false;
      obsidian = false;
      opencloud = false;
    };
    software = {
      display-link = true;
      docker = true;
      flatpak = false;
      git = true;
      noisetorch = true;
      osu = false;
      tmux = false;
      wine = false;
      ollama = false;
    };
    systemSettings = {
      bootanimation = true;
      gaming = false;
      virtualization = false;
    };
  };
  git = {
    lfs = true;
    extraConfig = {
      defaultBranch = "main";
      credential-helper = "store";
    };
    credentials = {
      email = "159010501+kushyme@users.noreply.github.com";
      name = "kushyme";
    };
    includes = [];
  };
  gnome = {
    fav-icon = [];
    idle-delay = 0;
  };
  couchdb = {
    address = "0.0.0.0";
    adminPasswordFile = "/var/lib/couchdb/secrets/admin-password";
    adminUser = "obsidian";
    corsOrigins = "app://obsidian.md,capacitor://localhost,http://localhost";
    databaseName = "obsidian";
    networkInterface = "wt0";
    port = 5984;
  };
  netbird = {
    client = {
      enable = true;
      autoStart = true;
      environment = {};
      hardened = false;
      interface = "wt0";
      logLevel = "info";
      managementUrl = null;
      port = 51820;
      setupKeyFile = null;
      useRoutingFeatures = "none";
    };
    server = {
      enable = false;
      domain = "";
      enableNginx = true;
      enableCoturn = true;
      acmeEmail = "";
      oidcConfigEndpoint = "";
      authAuthority = "";
      authAudience = "netbird";
      authClientId = "netbird";
      authSupportedScopes = "openid profile email";
      coturnPasswordFile = "/var/lib/netbird/secrets/coturn-password";
      dataStoreEncryptionKeyFile = "/var/lib/netbird/secrets/data-store-encryption-key";
      turnSecretFile = "/var/lib/netbird/secrets/turn-secret";
    };
  };
  opencloud = {
    address = "0.0.0.0";
    environment = {
      OC_INSECURE = "true";
    };
    environmentFile = null;
    networkInterface = "wt0";
    port = 9200;
    stateDir = "/var/lib/opencloud";
    url = null;
  };
}
