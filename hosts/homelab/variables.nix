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
        software =
          default.modules.software
          // {
            display-link = false;
            docker = true;
            flatpak = false;
            git = true;
            noisetorch = false;
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
  }
