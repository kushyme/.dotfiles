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

## Desktop environments

`modules.gui.*` picks the desktop per host, and the flags combine freely:

| Flag | What it turns on |
| --- | --- |
| `gnome` | GNOME with GDM, extensions and the dconf settings in `modules/gui/gnome.nix` |
| `umbriel` | [Umbriel](https://github.com/noctalia-dev/umbriel), a wlroots compositor, registered as a session named `Umbriel` |
| `noctalia` | [Noctalia](https://github.com/noctalia-dev/noctalia-shell), the shell and bar; Umbriel autostarts it |
| `noctalia-greeter` | [Noctalia Greeter](https://github.com/noctalia-dev/noctalia-greeter) on greetd, **replacing GDM** |

Leaving `gnome = true` next to the Noctalia stack keeps a GNOME session in the
greeter's session picker, which is a useful fallback while Umbriel is still
young.

Host-level knobs for these live next to `gnome` in `variables.nix`:

```nix
umbriel = {
  terminal = "kgx";
  fileManager = "nautilus";
  autostart = [];                 # extra commands started with the session
  keyboard = { layout = "de"; variant = ""; options = ""; };
  extraSettings = {};             # merged last into ~/.config/umbriel/config.toml
};
noctalia = {
  settings = {};                  # empty keeps Noctalia's settings panel authoritative
};
noctalia-greeter = {
  defaultSession = "Umbriel";     # label from `noctalia-greeter sessions`
  extraSettings = {};             # merged last into /var/lib/noctalia-greeter/greeter.toml
};
```

`extraSettings` is the escape hatch for anything the modules do not model, such
as per-monitor `[output.*]` blocks:

```nix
extraSettings.output."DP-1" = {
  mode = "2560x1440@144";
  scale = 1.0;
};
```

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
      noctalia = false;
      noctalia-greeter = false;
      umbriel = false;
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
