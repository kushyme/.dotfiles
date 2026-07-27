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
            zed-editor = true;
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
        fav-icon = [
          "org.gnome.Nautilus.desktop"
          "discord.desktop"
          "brave-browser.desktop"
          "spotify.desktop"
          "dev.zed.Zed.desktop"
          "bruno.desktop"
          "org.keepassxc.KeePassXC.desktop"
          "obsidian.desktop"
          "org.gnome.Console.desktop"
        ];
        idle-delay = 300;
      };
  }
