{
  config,
  lib,
  pkgs,
  inputs,
  hostVariables,
  ...
}: let
  cfg = config.modules.gui.noctalia-greeter;
  vars = hostVariables.noctalia-greeter;

  settings =
    lib.recursiveUpdate {
      session.default = vars.defaultSession;

      appearance = {
        scheme = "Noctalia";
        theme_mode = "dark";
        password_style = "default";
        power_buttons_position = "bottom-right";
      };

      cursor = {
        theme = "Adwaita";
        size = 24;
      };
    }
    vars.extraSettings;
in {
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  options.modules.gui.noctalia-greeter = {
    enable = lib.mkEnableOption "noctalia-greeter";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.noctalia-greeter = {
      enable = true;
      inherit settings;
      # Backs settings.cursor.path, so the theme above resolves in the store.
      cursorTheme.package = pkgs.adwaita-icon-theme;
      # Lets Noctalia push its palette to the login screen without a polkit
      # prompt. The constrained sync never accepts session commands.
      passwordless-sync-users = [hostVariables.username];
    };

    # greetd claims VT1 and aliases display-manager.service; GDM would fight it
    # for the seat, so the greeter wins wherever it is enabled.
    services.displayManager.gdm.enable = lib.mkForce false;

    # greetd is a system service, so it never picks up
    # environment.sessionVariables -- which is where NixOS exports the
    # aggregated session list. Without this the greeter only sees the .desktop
    # files that happen to sit in systemPackages, and the GNOME session goes
    # missing from the picker.
    systemd.services.greetd.environment.XDG_DATA_DIRS = lib.concatStringsSep ":" [
      "${config.services.displayManager.sessionData.desktops}/share"
      "/run/current-system/sw/share"
    ];
  };
}
