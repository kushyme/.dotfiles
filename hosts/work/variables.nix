let
  default = import ./../../variables/defaultVariables.nix;
  # Single source for every cursor size setting on this host (umbriel, the
  # greeter, XCURSOR_SIZE and gsettings).
  cursorSize = 24;
in
  default
  // {
    host = "work";
    inherit cursorSize;
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
        # Keyed by monitor (make model serial) so the order survives connector
        # renumbering. Laptop panel left, then the two HP E27k side by side.
        # The 27" 4K panels run at 1.5, so each is 2560 logical pixels wide.
        extraSettings.output = {
          "Chimei Innolux Corporation 0x1538 Unknown".position = [0 0];
          "HP Inc. HP E27k G5 CNK50201KV" = {
            position = [1920 0];
            scale = 1.5;
          };
          "HP Inc. HP E27k G5 CNK43620YT" = {
            position = [4480 0];
            scale = 1.5;
          };
        };
        # umbriel ignores XCURSOR_SIZE and defaults to 24, so mirror it here.
        extraSettings.input.cursor.size = cursorSize;
      };
    noctalia-greeter =
      default.noctalia-greeter
      // {
        extraSettings = {
          cursor.size = cursorSize;
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
