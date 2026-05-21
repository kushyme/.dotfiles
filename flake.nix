{
  nixConfig = {
    extra-substituters = ["https://cache.numtide.com"];
    extra-trusted-public-keys = ["niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    llm-agents.url = "github:numtide/llm-agents.nix";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: let
    mkNixosConfiguration = {
      modules ? [],
      hostVariables,
    }: let
      system = hostVariables.system;
      pkgs-config = {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import inputs.nixpkgs-unstable pkgs-config;
    in
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          modules
          ++ [
            ./configuration.nix
            ./modules
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [
                (final: prev: {
                  unstable = pkgs-unstable;
                })
              ];
            }
          ];
        specialArgs = {
          inherit inputs hostVariables;
        };
      };
  in {
    nixosConfigurations = {
      work = mkNixosConfiguration {
        modules = [./hosts/work];
        hostVariables = import ./hosts/work/variables.nix;
      };
      home-pc = mkNixosConfiguration {
        modules = [./hosts/home-pc];
        hostVariables = import ./hosts/home-pc/variables.nix;
      };
      laptop = mkNixosConfiguration {
        modules = [./hosts/laptop];
        hostVariables = import ./hosts/laptop/variables.nix;
      };
    };
    overlays = import ./overlays.nix inputs;
  };
}
