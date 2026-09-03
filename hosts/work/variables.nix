let
  default = import ./../../variables/defaultVariables.nix;
in
  default
  // {
    host = "work";
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
            display-link = true;
            osu = false;
            zed-editor = true;
            tailscale = true;
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
