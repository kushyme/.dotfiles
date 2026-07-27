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
  boot.kernelParams = ["usbhid.mousepoll=1"];

  networking.hostName = hostVariables.host;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  services.xserver.enable = true;

  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  console.keyMap = "de";

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.${hostVariables.username} = {
    isNormalUser = true;
    description = "Erik Peters";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
    ];
  };

  programs.direnv.enable = true;

  programs.firefox = {
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    (unstable.brave.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
    })
    unstable.bruno
    spotify
    discord
    keepassxc
    github-desktop
    vscode-with-extensions
    obsidian
    gh
    lunar-client
    desmume
    azahar
    zip
    unzip
    jdk
    libreoffice-qt
    docker
    dbeaver-bin
    nodejs_24
    easyeffects
    (symlinkJoin {
      name = "modrinth-app-wayland-fix";
      paths = [modrinth-app];
      nativeBuildInputs = [makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/ModrinthApp \
          --set __NV_DISABLE_EXPLICIT_SYNC 1
      '';
    })
    gimp
    fastfetch
    geary
    zed-editor
  ];

  boot.extraModprobeConfig = ''
    options xpad triggers_to_buttons=0
  '';

  powerManagement.cpuFreqGovernor = "performance";

  programs.gamemode.enable = true;

  system.stateVersion = hostVariables.stateVersion;

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];
}
