{hostVariables, ...}: {
  nix = let
    nixSettings = builtins.fromJSON (builtins.readFile ../../nix-settings.json);
  in {
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };
    settings = rec {
      auto-optimise-store = true;
      trusted-users = [hostVariables.username];
      experimental-features = nixSettings."experimental-features";
      substituters = nixSettings.substituters;
      trusted-public-keys = nixSettings."trusted-public-keys";
      trusted-substituters = substituters;
    };
    extraOptions = ''
      !include /home/${hostVariables.username}/.nix.conf
    '';
  };
}
