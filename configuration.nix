# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  pkgs,
  hostVariables,
  ...
}: {
  # --- Overlay für OpenBLAS (i686) ---
  nixpkgs.overlays = [
    (final: prev: {
      openblas =
        if prev.stdenv.hostPlatform.system == "i686-linux"
        then prev.openblas.overrideAttrs (_: {doCheck = false;})
        else prev.openblas;
    })
  ];
  imports = [
    ./home.nix
  ];
  # Modules
  modules.console.atuin.enable = hostVariables.modules.console.atuin;
  modules.console.fish.enable = hostVariables.modules.console.fish;
  modules.console.zsh.enable = hostVariables.modules.console.zsh;
  modules.driver.amdgpu.enable = hostVariables.modules.driver.amdgpu;
  modules.driver.nvidia.enable = hostVariables.modules.driver.nvidia;
  modules.gui.gnome.enable = hostVariables.modules.gui.gnome;
  modules.software.displaylink.enable = hostVariables.modules.software.display-link;
  modules.software.docker.enable = hostVariables.modules.software.docker;
  modules.software.flatpak.enable = hostVariables.modules.software.flatpak;
  modules.software.git.enable = hostVariables.modules.software.git;
  modules.software.noisetorch.enable = hostVariables.modules.software.noisetorch;
  modules.software.tmux.enable = hostVariables.modules.software.tmux;
  modules.software.wine.enable = hostVariables.modules.software.wine;
  modules.software.ollama.enable = hostVariables.modules.software.ollama;
  modules.system.bootanimation.enable = hostVariables.modules.systemSettings.bootanimation;
  modules.system.gaming.enable = hostVariables.modules.systemSettings.gaming;
  modules.system.virtualization.enable = hostVariables.modules.systemSettings.virtualization;

  system.activationScripts.script.text = ''
    cp /home/${hostVariables.username}/.dotfiles/assets/donkey.jpg /var/lib/AccountsService/icons/${hostVariables.username}
  '';

  environment.systemPackages =
    (with pkgs; [
      alejandra
    ])
    ++ [
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.junie
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
    ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  programs.nh = {
    enable = true;
    flake = "/home/${hostVariables.username}/.dotfiles";
  };

  programs.nix-ld.enable = true;
}
