let
  default = import ./../../variables/defaultVariables.nix;
in
  default
  // {
    host = "laptop";
    modules =
      default.modules
      // {
        driver =
          default.modules.driver
          // {
            nvidia = false;
          };
        software =
          default.modules.software
          // {
            display-link = false;
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
    gnome =
      default.gnome
      // {
        idle-delay = 300;
      };
  }
