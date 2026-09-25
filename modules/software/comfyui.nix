{
  config,
  lib,
  hostVariables,
  ...
}: let
  cfg = hostVariables.comfyui;
  user = config.users.users.${hostVariables.username};

  # NixOS leaves uid null when it lets useradd allocate one, so the numeric id
  # the container has to drop to is not readable from config. 1000 is what the
  # first normal user gets.
  uid =
    if user.uid != null
    then user.uid
    else 1000;
in {
  options.modules.software.comfyui = {
    enable = lib.mkEnableOption "ComfyUI";
  };

  config = lib.mkIf config.modules.software.comfyui.enable {
    assertions = [
      {
        assertion = config.virtualisation.docker.enable;
        message = "ComfyUI runs in a container: modules.software.docker has to be enabled on this host.";
      }
    ];

    # torch and CUDA come out of the image rather than out of nixpkgs. Building
    # it here means compiling torch: no public cache carries a CUDA-enabled one
    # since cuda-maintainers.cachix.org went private, and nixpkgs' prebuilt
    # wheels sit at CUDA versions that disagree with each other -- torch at
    # cu130 against torchaudio at cu128 -- which torchaudio rejects at import.
    # The image also lets ComfyUI-Manager install custom nodes, which it does
    # with pip at runtime and cannot do against a read-only store; the video
    # model ecosystem is distributed almost entirely as such nodes.
    hardware.nvidia-container-toolkit.enable = true;

    virtualisation.oci-containers = {
      backend = "docker";
      containers.comfyui = {
        image = cfg.image;

        # ComfyUI has no authentication and its UI browses the container's
        # filesystem, so the published port carries an explicit address rather
        # than landing on every interface.
        ports = ["${cfg.address}:${toString cfg.port}:8188"];

        volumes = [
          "${cfg.dataDir}/run:/comfy/mnt"
          "${cfg.dataDir}/basedir:/basedir"
        ];

        environment =
          {
            BASE_DIRECTORY = "/basedir";
            # ComfyUI-Manager's own gate on what it will install.
            SECURITY_LEVEL = cfg.securityLevel;
            USE_UV = "true";
            # The entrypoint drops to these, so checkpoints and outputs end up
            # owned by the login user instead of root.
            WANTED_GID = toString config.users.groups.${user.group}.gid;
            WANTED_UID = toString uid;
          }
          // lib.optionalAttrs (cfg.extraArgs != []) {
            COMFY_CMDLINE_EXTRA = lib.concatStringsSep " " cfg.extraArgs;
          };

        extraOptions = [
          # CDI device, which is what hardware.nvidia-container-toolkit wires
          # up; --gpus all would need the legacy runtime instead.
          "--device=nvidia.com/gpu=all"
        ];
      };
    };

    # Both bind mounts have to exist before the unit starts, owned by the id
    # the container drops to -- docker would otherwise create them as root.
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 ${hostVariables.username} ${user.group} - -"
      "d ${cfg.dataDir}/run 0750 ${hostVariables.username} ${user.group} - -"
      "d ${cfg.dataDir}/basedir 0750 ${hostVariables.username} ${user.group} - -"
    ];
  };
}
