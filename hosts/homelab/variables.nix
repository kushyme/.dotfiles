let
  default = import ./../../variables/defaultVariables.nix;
in
  default
  // {
    host = "homelab";
    modules =
      default.modules
      // {
        gui =
          default.modules.gui
          // {
            gnome = false;
          };
        homelab =
          default.modules.homelab
          // {
            couchdb = true;
            opencloud = true;
          };
        software =
          default.modules.software
          // {
            display-link = false;
            docker = true;
            flatpak = false;
            git = true;
            noisetorch = false;
            tailscale = true;
            tmux = true;
            wine = false;
            ollama = false;
          };
        systemSettings =
          default.modules.systemSettings
          // {
            gaming = false;
            virtualization = true;
          };
      };
    git =
      default.git
      // {
        includes = [
          {
            path = "~/Dev/.gitconfig";
            condition = "gitdir:~/Dev/";
          }
        ];
      };
    tailscale =
      default.tailscale
      // {
        client =
          default.tailscale.client
          // {
            servePorts = [443];
          };
      };
    opencloud =
      default.opencloud
      // {
        url = "https://homelab.tailf15ea4.ts.net";
      };
  }
