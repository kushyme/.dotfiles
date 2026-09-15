{
  config,
  lib,
  pkgs,
  inputs,
  hostVariables,
  ...
}: let
  cfg = config.modules.gui.noctalia;

  settings =
    lib.recursiveUpdate {
      # Mirrors the GNOME dash-to-dock setup in gnome.nix: fixed at the bottom
      # on every monitor, running-window dots, app grid button at the end.
      dock = {
        enabled = true;
        position = "bottom";
        icon_size = 42;
        auto_hide = false;
        show_running = true;
        show_dots = true;
        magnification = false;
        inactive_scale = 1.0;
        inactive_opacity = 1.0;
        launcher_position = "end";
        # Same favorites as GNOME; the dock matches the desktop file stem.
        pinned = map (lib.removeSuffix ".desktop") hostVariables.gnome.fav-icon;
      };
    }
    hostVariables.noctalia.settings;
in {
  imports = [
    inputs.noctalia.nixosModules.default
  ];

  options.modules.gui.noctalia = {
    enable = lib.mkEnableOption "noctalia";
  };

  config = lib.mkMerge [
    # `imports` cannot sit behind mkIf, and the upstream home-manager module
    # gates everything on programs.noctalia.enable anyway, so it costs nothing
    # on hosts that leave this module disabled.
    {
      home-manager.users.${hostVariables.username}.imports = [
        inputs.noctalia.homeModules.default
      ];
    }

    (lib.mkIf cfg.enable {
      programs.noctalia = {
        enable = true;
        # NetworkManager, bluetooth, upower and a power profile daemon, which
        # the control center widgets talk to.
        recommendedServices.enable = true;
      };

      environment.systemPackages = with pkgs; [
        brightnessctl
        libnotify
        playerctl
        wl-clipboard
      ];

      home-manager.users.${hostVariables.username} = {
        programs.noctalia = {
          enable = true;
          inherit settings;
        };
      };
    })
  ];
}
