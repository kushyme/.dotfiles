{
  config,
  lib,
  inputs,
  hostVariables,
  ...
}: let
  cfg = hostVariables.comfyui;

  # ComfyUI pins cudaPackages_13 for torch, and no public cache carries a
  # CUDA-enabled torch any more -- cuda-maintainers.cachix.org answers 401 --
  # so nixpkgs' source build would mean compiling torch, triton and magma on
  # the host. These are the wheels PyTorch publishes itself instead.
  #
  # The swap has to go through pythonPackagesExtensions rather than
  # python3.override: ComfyUI's package builds its interpreter with its own
  # packageOverrides, and a second override would replace that argument
  # instead of composing with it, silently dropping the -bin packages.
  pkgs-cuda = import inputs.nixpkgs-unstable {
    system = hostVariables.system;
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        pythonPackagesExtensions =
          prev.pythonPackagesExtensions
          ++ [
            (pyFinal: pyPrev: {
              # torch-bin refuses to evaluate against anything older than
              # cuda-bindings 13.0.3, and the package set still defaults to the
              # 12.9 build.
              cuda-bindings = pyPrev.cuda-bindings.override {
                cudaPackages = final.cudaPackages_13;
              };
              torch = pyPrev.torch-bin;
              torchaudio = pyPrev.torchaudio-bin;
              torchvision = pyPrev.torchvision-bin;
              triton = pyPrev.triton-bin;
            })
          ];
      })
    ];
  };
in {
  # 26.05 ships neither the package nor services.comfyui, so the service
  # definition comes from the unstable input by path.
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/misc/comfyui.nix"
  ];

  options.modules.software.comfyui = {
    enable = lib.mkEnableOption "ComfyUI";
  };

  config = lib.mkIf config.modules.software.comfyui.enable {
    services.comfyui = {
      enable = true;
      package = pkgs-cuda.comfyui;
      inherit (cfg) extraArgs listen port;
    };

    # The unit keeps its StateDirectory at 0700 comfyui:comfyui, which leaves
    # no way to drop checkpoints into models/ without becoming that user.
    # Widening it to the group keeps the tree off the rest of the system while
    # staying writable from a file manager. UMask has to follow: the service
    # seeds models/ and custom_nodes/ itself on first start, and systemd's
    # default 0022 would make those subdirectories read-only to the group.
    systemd.services.comfyui.serviceConfig = {
      StateDirectoryMode = lib.mkForce "0770";
      UMask = "0007";
    };
    users.users.${hostVariables.username}.extraGroups = ["comfyui"];
  };
}
