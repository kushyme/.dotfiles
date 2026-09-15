let
  default = import ./../../variables/defaultVariables.nix;
in
  default
  // {
    host = "work";
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
            display-link = true;
            osu = false;
            zed-editor = true;
            tailscale = true;
          };
        systemSettings =
          default.modules.systemSettings
          // {
            gaming = false;
            virtualization = false;
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
    umbriel =
      default.umbriel
      // {
        keyboard =
          default.umbriel.keyboard
          // {
            layout = "de";
          };
      };
    noctalia-greeter =
      default.noctalia-greeter
      // {
        extraSettings = {
          cursor.size = 48; # matches XCURSOR_SIZE from the host configuration
          keyboard.layout = "de";
        };
      };
    gnome =
      default.gnome
      // {
        fav-icon = [
          "org.gnome.Nautilus.desktop"
          "brave-browser.desktop"
          "brave-pjibgclleladliembfgfagdaldikeohf-Default.desktop"
          "brave-cifhbcnohmdccbgoicgdjpfamggdegmo-Default.desktop"
          "brave-faolnafnngnfdaknnbpnkhgohbobgegn-Default.desktop"
          "dev.zed.Zed.desktop"
          "SourceGit.desktop"
          "bruno.desktop"
          "org.keepassxc.KeePassXC.desktop"
          "obsidian.desktop"
          "org.gnome.Console.desktop"
        ];
        idle-delay = 300;
      };
  }
