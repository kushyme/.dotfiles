{
  config,
  lib,
  pkgs,
  inputs,
  hostVariables,
  ...
}: let
  cfg = config.modules.gui.noctalia;
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
          settings = hostVariables.noctalia.settings;
        };
      };
    })
  ];
}
