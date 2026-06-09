{
  config,
  pkgs,
  lib,
  hostVariables,
  ...
}: {
  options.modules.console.atuin = {
    enable = lib.mkEnableOption "atuin";
  };

  config = lib.mkIf config.modules.console.atuin.enable {
    home-manager.users.${hostVariables.username} = {
      programs.atuin = {
        enable = true;
        package = pkgs.atuin;
        enableFishIntegration = config.modules.console.fish.enable;
        enableZshIntegration = config.modules.console.zsh.enable;
        forceOverwriteSettings = true;

        daemon = {
          enable = false;
          logLevel = "warn";
        };

        settings = {
          enter_accept = true;
          filter_mode = "workspace";
          filter_mode_shell_up_key_binding = "workspace";
          search_mode = "fuzzy";
          style = "compact";
          workspaces = true;
        };
      };
    };
  };
}
