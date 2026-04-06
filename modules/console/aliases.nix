{hostVariables, ...}: {
  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake /home/${hostVariables.username}/.dotfiles#${hostVariables.host}";
    update = "nix flake update --flake /home/${hostVariables.username}/.dotfiles";
    switchnix = "nh os switch -H ${hostVariables.host} /home/${hostVariables.username}/.dotfiles";
    nixfmt = "alejandra ./";
    wg-up = "sudo wg-quick up /etc/wireguard/wg_config.conf";
    wg-down = "sudo wg-quick down /etc/wireguard/wg_config.conf";
    restart = "systemctl reboot";
    shutdown = "systemctl poweroff";
    randomizer = "bash /home/${hostVariables.host}/Documents/poke_randomizer/launcher_UNIX.sh";
  };
}
