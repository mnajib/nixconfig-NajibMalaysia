{ pkgs, ... }: {

  #home.packages = [ pkgs.tmux ];

  programs.tmux = {
    enable = true;
    #packages =  pkgs.tumx;
    clock24 = true;
    escapeTime = 10;
    historyLimit = 10000;
    keyMode = "vi";
    terminal = "screen-256color";

    extraConfig = ''
      set -g mouse on
      #set -g mouse-select-pane on
      set -g default-terminal "screen-256color"
    '';

    #tmuxinator.enable = true;

    plugins = with pkgs; [
      tmuxPlugins.cpu
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
    ];
  };

  #home.file.".tmux.conf".text = ''
  #  setenv TERM screen-256color
  #'';
}
