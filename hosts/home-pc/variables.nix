let
  default = import ./../../variables/defaultVariables.nix;
in
  default
  // {
    host = "home-pc";
    modules =
      default.modules
      // {
        driver =
          default.modules.driver
          // {
            nvidia = true;
          };
        software =
          default.modules.software
          // {
            display-link = false;
            noisetorch = false;
            osu = true;
            tailscale = true;
            zed-editor = true;
          };
        systemSettings =
          default.modules.systemSettings
          // {
            gaming = true;
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
    gnome =
      default.gnome
      // {
        fav-icon = [
          "org.gnome.Nautilus.desktop"
          "discord.desktop"
          "brave-browser.desktop"
          "spotify.desktop"
          "steam.desktop"
          "dev.zed.Zed.desktop"
          "SourceGit.desktop"
          "bruno.desktop"
          "org.keepassxc.KeePassXC.desktop"
          "obsidian.desktop"
          "org.gnome.Console.desktop"
          "org.gnome.Geary.desktop"
        ];
        idle-delay = 300;
      };
  }
