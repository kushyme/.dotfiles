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
    unstable.bruno
    discord
    keepassxc
    github-desktop
    vscode-with-extensions
    obsidian
    gh
    python313
    libreoffice-qt
    wireguard-tools
    spotify
    zip
    unzip
    fastfetch
    zed-editor
    sourcegit
  ];

  system.stateVersion = hostVariables.stateVersion;

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];
}
