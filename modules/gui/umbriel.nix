{
  config,
  lib,
  pkgs,
  inputs,
  hostVariables,
  ...
}: let
  cfg = config.modules.gui.umbriel;
  vars = hostVariables.umbriel;

  settings =
    lib.recursiveUpdate {
      general = {
        autostart =
          lib.optional config.modules.gui.noctalia.enable "noctalia"
          ++ vars.autostart;
        xwayland = true; # xwayland-satellite ships inside the umbriel package
        show_cheatsheet = true;
        focus_on_activate = false;
      };

      input = {
        keyboard = {
          inherit (vars.keyboard) layout variant options;
          repeat_rate = 25;
          repeat_delay = 600;
          numlock_toggle = true;
        };
        touchpad = {
          tap = true;
          natural_scroll = true;
        };
        focus.follows_mouse = false;
        # umbriel never reads XCURSOR_THEME: an empty theme makes wlroots look
        # for a "default" theme and fall back to its tiny built-in cursor, which
        # ignores the size. XCURSOR_SIZE is ignored too (it defaults to 24), so
        # hosts set input.cursor.size through extraSettings.
        cursor.theme = "Adwaita";
      };

      layout = {
        mode = "scrolling";
        gap = 8;
        width_presets = [0.333 0.5 0.667];
      };

      appearance = {
        prefer_no_csd = true;
        border_width = 2;
        corner_radius = 10;
        blur.enabled = true;
        shadow.enabled = true;
      };

      # A config file *replaces* the built-in keybind set, so every chord that
      # should stay reachable has to be spelled out here.
      keybinds =
        {
          # Applications and session
          "Mod+Return" = "spawn:${vars.terminal}";
          "Mod+E" = "spawn:${vars.fileManager}";
          "Mod+Q" = "window-close";
          "Mod+Escape" = "session-quit";

          # Focus navigation
          "Mod+Left" = "window-focus-left";
          "Mod+Down" = "window-focus-down";
          "Mod+Up" = "window-focus-up";
          "Mod+Right" = "window-focus-right";
          "Mod+H" = "window-focus-left";
          "Mod+J" = "window-focus-down";
          "Mod+K" = "window-focus-up";
          # Mod+L locks the session (see the noctalia binds below).
          "Mod+F1" = "window-focus-next";
          "Mod+WheelUp" = "window-focus-left";
          "Mod+WheelDown" = "window-focus-right";

          # Moving windows and columns
          "Mod+Shift+Left" = "column-move-left";
          "Mod+Shift+Down" = "window-move-down";
          "Mod+Shift+Up" = "window-move-up";
          "Mod+Shift+Right" = "column-move-right";
          "Mod+Comma" = "window-consume-left";
          "Mod+Period" = "window-consume-right";

          # Window state and layout
          "Mod+T" = "window-toggle-floating";
          "Mod+Shift+T" = "window-focus-switch-floating";
          "Mod+P" = "window-toggle-pinned";
          "Mod+M" = "window-toggle-maximize-to-edges";
          "Mod+F" = "window-toggle-fullscreen";
          "Mod+Ctrl+F" = "window-toggle-maximize";
          "Mod+R" = "window-cycle-width";
          "Mod+Shift+R" = "window-cycle-width-back";

          # Overview
          "Mod+O" = {
            action = "overview-toggle";
            repeat = false;
          };

          # Scratchpads (implicit `default` scratchpad)
          "Mod+Shift+Space" = "window-move-to-scratchpad";
          "Mod+Space" = "scratchpad-toggle";
          "Mod+Ctrl+Space" = "window-restore-from-scratchpad";
          "Mod+Tab" = "scratchpad-focus-next";

          # Media and brightness
          "XF86AudioRaiseVolume" = "spawn:wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" = "spawn:wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute" = "spawn:wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioPlay" = "spawn:playerctl play-pause";
          "XF86AudioNext" = "spawn:playerctl next";
          "XF86AudioPrev" = "spawn:playerctl previous";
          "XF86MonBrightnessDown" = {
            action = "spawn:brightnessctl set 10%-";
            allow_when_locked = true;
          };
          "XF86MonBrightnessUp" = {
            action = "spawn:brightnessctl set 10%+";
            allow_when_locked = true;
          };
        }
        # Workspace switching and moving, Mod+<n> / Mod+Shift+<n>.
        // lib.listToAttrs (lib.concatMap (n: [
            (lib.nameValuePair "Mod+${toString n}" "workspace-switch:${toString n}")
            (lib.nameValuePair "Mod+Shift+${toString n}" "window-move-to-workspace:${toString n}")
          ])
          (lib.range 1 9))
        // lib.optionalAttrs config.modules.gui.noctalia.enable {
          "Mod" = "spawn:noctalia msg panel-toggle launcher";
          "Mod+C" = "spawn:noctalia msg panel-toggle control-center";
          "Mod+V" = "spawn:noctalia msg panel-toggle clipboard";
          "Print" = "spawn:noctalia msg screenshot-region";
          "Mod+L" = {
            action = "spawn:noctalia msg session lock";
            repeat = false;
          };
        };

      window_rule = [
        # Selectorless, so later rules can still override individual blur keys.
        # blur_optimized stays at its default (true): unoptimized blur recomputes
        # per window every frame and drops frames on the iGPU at 2x 4K.
        {
          blur = true;
        }
        {
          match.app_id = "^dev.noctalia.Noctalia$";
          default_floating = true;
          default_size = [1020 900];
        }
        {
          match.app_id = "^dev.noctalia.UmbrielSharePicker$";
          default_floating = true;
          default_size = [800 600];
        }
        {
          match.title = "^(Picture-in-Picture|Picture in picture)$";
          default_floating = true;
          default_maximize = false;
          default_position = {
            x = 20;
            y = 20;
            anchor = "bottom_right";
          };
        }
      ];
    }
    vars.extraSettings;
in {
  imports = [
    inputs.umbriel.nixosModules.default
  ];

  options.modules.gui.umbriel = {
    enable = lib.mkEnableOption "umbriel";
  };

  config = lib.mkMerge [
    # See the note in noctalia.nix: unconditional import, conditional config.
    {
      home-manager.users.${hostVariables.username}.imports = [
        inputs.umbriel.homeModules.default
      ];
    }

    (lib.mkIf cfg.enable {
      programs.umbriel.enable = true;

      environment.systemPackages = with pkgs; [
        adwaita-icon-theme # backs input.cursor.theme
        brightnessctl
        gnome-console # Mod+Return
        libnotify
        nautilus # Mod+E
        playerctl
        wl-clipboard
      ];

      home-manager.users.${hostVariables.username} = {
        programs.umbriel = {
          enable = true;
          inherit settings;
        };
      };
    })
  ];
}
