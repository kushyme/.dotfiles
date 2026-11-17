{
  config,
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
    (symlinkJoin {
      name = "brave-wayland";
      paths = [unstable.brave];
      nativeBuildInputs = [makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/brave \
          --add-flags "--enable-features=UseOzonePlatform" \
          --add-flags "--ozone-platform=wayland"
      '';
    })
    winetricks
    unstable.bruno
    spotify
    discord
    keepassxc
    vscode-with-extensions
    obsidian
    gh
    (symlinkJoin {
      name = "lunar-client-wayland-fix";
      paths = [lunar-client];
      nativeBuildInputs = [makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/lunarclient \
          --set __NV_DISABLE_EXPLICIT_SYNC 1
      '';
    })
    desmume
    azahar
    zip
    unzip
    jdk
    libreoffice-qt
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
    sourcegit
    dig
  ];

  boot.extraModprobeConfig = ''
    options xpad triggers_to_buttons=0
  '';

  powerManagement.cpuFreqGovernor = "performance";

  programs.gamemode.enable = true;

  # Xid 32/109 GPU faults on the RTX 2060 (Overwatch "rendering device lost")
  # started when nixpkgs moved 6.12 -> 6.18 *and* 580 -> 595 at the same time.
  # Pinning 580 alone on 6.18 still crashed (Xid 109, 2026-11-17), so go back
  # to the last known-good combo: 6.12 LTS kernel + 580 driver.
  boot.kernelPackages = pkgs.linuxPackages_6_12;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

  system.stateVersion = hostVariables.stateVersion;

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];
}
