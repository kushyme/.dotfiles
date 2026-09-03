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
      opencloud = false;
    };
    software = {
      display-link = true;
      docker = true;
      flatpak = false;
      git = true;
      noisetorch = true;
      osu = false;
      tailscale = false;
      tmux = false;
      wine = false;
      ollama = false;
      zed-editor = false;
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
    networkInterface = "tailscale0";
    port = 5984;
  };
  tailscale = {
    client = {
      advertiseExitNode = false;
      advertiseRoutes = [];
      authKeyFile = null;
      disableTaildrop = false;
      ephemeral = null;
      extraSetFlags = [];
      extraUpFlags = [];
      interfaceName = "tailscale0";
      loginServer = null;
      openFirewall = false;
      permitCertUid = null;
      port = 41641;
      preauthorized = null;
      useRoutingFeatures = "none";
    };
  };
  opencloud = {
    address = "0.0.0.0";
    environment = {
      OC_INSECURE = "false";
    };
    environmentFile = null;
    networkInterface = "tailscale0";
    port = 9200;
    stateDir = "/var/lib/opencloud";
    url = null;
  };
}
