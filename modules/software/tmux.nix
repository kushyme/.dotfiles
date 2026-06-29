{
  config,
  pkgs,
  lib,
  hostVariables,
  ...
}: {
  options.modules.software.tmux = {
    enable = lib.mkEnableOption "tmux";
  };

  config = lib.mkIf config.modules.software.tmux.enable {
    environment.systemPackages = [
      pkgs.tmux
    ];

    home-manager.users.${hostVariables.username} = {
      programs.tmux = {
        enable = true;
        package = pkgs.tmux;
        extraConfig = ''
          set -g prefix C-Space
          unbind C-b
          bind C-Space send-prefix

          set -g default-terminal "tmux-256color"
          set -ga terminal-overrides ",*:RGB"
          set -g base-index 1
          setw -g pane-base-index 1
          set -g renumber-windows on
          set -g mouse on
          set -g history-limit 100000
          set -g escape-time 10
          setw -g mode-keys vi

          unbind '"'
          unbind %
          bind s split-window -v
          bind v split-window -h
          bind n next-window
          bind b previous-window
          bind p paste-buffer

          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

          bind H resize-pane -L 5
          bind J resize-pane -D 5
          bind K resize-pane -U 5
          bind L resize-pane -R 5

          bind e copy-mode
          bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux config reloaded"
          bind -T copy-mode-vi v send -X begin-selection
          bind -T copy-mode-vi y send -X copy-selection-and-cancel
        '';
      };
    };
  };
}
