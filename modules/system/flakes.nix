{hostVariables, ...}: {
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [hostVariables.username];
      substituters = [
        "https://cache.nixos.org/"
        "https://cache.numtide.com"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };
    extraOptions = ''
      !include /home/${hostVariables.username}/.nix.conf
    '';
  };
}
