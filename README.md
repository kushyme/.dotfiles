# NixOS Multi-Host Configuration

This is my personal NixOS configuration. It's modular and uses [Nix Flakes](https://nixos.wiki/wiki/Flakes) and [Home Manager](https://nix-community.github.io/home-manager/).

## Features

- Reproducible setup using Flakes
- Modular structure that works across different hosts
- Integrated Home Manager for user configuration
- A central `variables.nix` file to manage system flags and modules
- KVM/libvirt virtualization support with virt-manager for Windows VMs

---

## Getting Started

### 1. Clone the repository

```bash
Make sure you are in your home directory
git clone https://github.com/kushyme/.dotfiles ~/.dotfiles
cd ~/.dotfiles
```

### 2. Set up a host

Edit:

```nix
./hosts/{work,home-pc}/variables.nix
```

Then run:

```bash
sudo nixos-rebuild switch --flake ~/.dotfiles#work
```

For later rebuilds:

```bash
rebuild
```

or 
```bash
switch
```

> `rebuild` and `switch` are aliases for `nixos-rebuild` with predefined arguments.

---

## Adding a New Host

1. Create a new folder in `./hosts/`, e.g. `home-pc`
2. Add these files:
    - `configuration.nix`
    - `default.nix`
    - `hardware-configuration.nix`
    - `variables.nix`

3. Your `variables.nix` should follow this structure:

```nix
{
  username = "Erik";
  host = "default";
  system = "x86_64-linux";
  stateVersion = "26.05";
  modules = {
    console = {
      fish = false;
      zsh = true;
    };
    driver = {
      nvidia = false;
      amdgpu = false;
    };
    gui = {
      gnome = true;
    };
    software = {
      display-link = false;
      docker = true;
      flatpak = false;
      git = true;
      noisetorch = true;
      wine = false;
      vscode = true;
    };
    systemSettings = {
      bootanimation = true;
      gaming = false;
      printer = true;
      virtualization = false;
    };
  };
  git = {
    lfs = true;
    extraConfig = {
      defaultBranch = "main";
      credential-helper = "store";
    };
    credentials = {
      email = "159010501+kushyme@users.noreply.github.com";
      name = "kushyme";
    };
    includes = [];
  };
  gnome = {
    fav-icon = [
    ];
  };
}
```

4. Finally, register the host in your `flake.nix`:

```nix
nixosConfigurations = {
  home-pc = mkNixosConfiguration {
    modules = [ ./hosts/home-pc ];
    hostVariables = import ./hosts/home-pc/variables.nix;
  };
};
```

---

## Troubleshooting

### Missing attributes

Ensure that your `variables.nix` file contains all required attributes. Use a central default like:

```nix
let default = import ../../variables/defaultVariables.nix; in
default // { ... }
```

This ensures every module gets all expected keys.



### Module flags aren't working

Make sure you're not accidentally shadowing or omitting expected fields:

- Use `default.modules // { ... }` instead of `{}` when overriding
- Use `lib.attrByPath` or `lib.getAttrFromPath` for optional flags

---

### Issues with flake updates

Run:

```bash
nix flake update
rebuild switch --flake .#your-host
```

If you're using `nix-direnv`, reload the shell with `direnv reload`.

---
