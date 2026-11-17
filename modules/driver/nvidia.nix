{
  config,
  lib,
  pkgs,
  ...
}: {
  options.modules.driver.nvidia = {
    enable = lib.mkEnableOption "nvidia";
  };

  config = lib.mkIf config.modules.driver.nvidia.enable {
    services.xserver.videoDrivers = [
      "nvidia"
    ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vulkan-validation-layers
        vulkan-loader
        vulkan-tools
      ];
    };
  };
}
