let
  default = import ./../../variables/defaultVariables.nix;
in
  default
  // {
    host = "home-pc";
    modules =
      default.modules
      // {
        gui =
          default.modules.gui
          // {
            gnome = true;
            noctalia = true;
            noctalia-greeter = true;
            umbriel = true;
          };
        driver =
          default.modules.driver
          // {
            nvidia = true;
          };
        software =
          default.modules.software
          // {
            comfyui = true;
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
    umbriel =
      default.umbriel
      // {
        keyboard =
          default.umbriel.keyboard
          // {
            layout = "de";
          };
        # Keyed by monitor (make model serial) so the order survives connector
        # renumbering. ViewSonic ultrawide is the main monitor, on the left;
        # the Samsung sits to its right.
        extraSettings.output = {
          "ViewSonic Corporation VG3456 WFN211300150" = {
            mode = "3440x1440@75";
            position = [0 0];
          };
          "Samsung Electric Company S24D330 0x5A5A5131" = {
            mode = "1920x1080@60";
            position = [3440 0];
          };
        };
      };
    noctalia-greeter =
      default.noctalia-greeter
      // {
        extraSettings = {
          keyboard.layout = "de";
        };
      };
  }
