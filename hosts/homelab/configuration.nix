{
  hostVariables,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking = {
    hostName = hostVariables.host;
    networkmanager.enable = true;
  };
  time.timeZone = "Europe/Berlin";
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
  services.openssh = {
    enable = true;
  };
  console.keyMap = "de";
  security.rtkit.enable = true;
  users.users.${hostVariables.username} = {
    isNormalUser = true;
    description = "Erik Peters";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
    ];
  };
  programs.direnv.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    unzip
    zip
    fastfetch
  ];
  powerManagement.cpuFreqGovernor = "performance";
  system.stateVersion = hostVariables.stateVersion;
  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];
}
