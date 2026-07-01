{
  config,
  lib,
  ...
}: {
  options.modules.homelab.obsidian = {
    enable = lib.mkEnableOption "Obsidian LiveSync server";
  };

  config = lib.mkIf config.modules.homelab.obsidian.enable {
    assertions = [
      {
        assertion = false;
        message = "modules.homelab.obsidian is a placeholder and has not been implemented yet.";
      }
    ];
  };
}
