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
      noctalia = false;
      noctalia-greeter = false;
      umbriel = false;
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
  noctalia = {
    # Merged over the module defaults (the dock) into
    # ~/.config/noctalia/config.toml and validated at build time. Changes made
    # in Noctalia's settings panel still win (~/.local/state/noctalia/settings.toml).
    settings = {};
  };
  umbriel = {
    terminal = "kgx";
    fileManager = "nautilus";
    # Extra commands started with the session, next to Noctalia itself.
    autostart = [];
    keyboard = {
      layout = "";
      variant = "";
      options = "";
    };
    # Merged last into ~/.config/umbriel/config.toml: per-monitor [output.*]
    # blocks, extra window rules, keybind overrides, ...
    extraSettings = {};
  };
  noctalia-greeter = {
    # Session picker label, as printed by `noctalia-greeter sessions` -- the
    # Name= of the .desktop file, not its id.
    defaultSession = "Umbriel";
    # Merged last into /var/lib/noctalia-greeter/greeter.toml.
    extraSettings = {};
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
      servePorts = [];
      useRoutingFeatures = "none";
    };
  };
  opencloud = {
    address = "127.0.0.1";
    environment = {
      OC_INSECURE = "true";
      PROXY_TLS = "false";
    };
    environmentFile = null;
    networkInterface = "tailscale0";
    port = 9200;
    stateDir = "/var/lib/opencloud";
    url = null;
  };
}
