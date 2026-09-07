{hostVariables, ...}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${hostVariables.username} = {
    # basic home-manager config
    home.username = "${hostVariables.username}";
    home.homeDirectory = "/home/${hostVariables.username}";
    home.stateVersion = hostVariables.stateVersion;
    programs.home-manager.enable = true;

    home.sessionVariables.BROWSER = "brave";

    # GNOME's "Default Apps" cannot persist this: mimeapps.list is a
    # read-only symlink into the store, so the default browser has to be
    # declared here.
    xdg.configFile."mimeapps.list".force = true;
    xdg.dataFile."applications/mimeapps.list".force = true;

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = ["brave-browser.desktop"];
        "x-scheme-handler/http" = ["brave-browser.desktop"];
        "x-scheme-handler/https" = ["brave-browser.desktop"];
        "x-scheme-handler/about" = ["brave-browser.desktop"];
        "x-scheme-handler/unknown" = ["brave-browser.desktop"];
      };
    };
  };
}
