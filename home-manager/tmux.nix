{ pkgs, ... }: {

  #home.packages = [ pkgs.tmux ];

  #
  # NOTES:
  # -----
  #
  # Defult:
  #
  #   C-b q                                             Display pane-id-number.
  #   C-b {                                             Switch current-pane position with previous-pane position.
  #   C-b }                                             Switch current-pane position with next-pane position.
  #   C-b !                                             Break-pane: Move current-pane into new window.
  #   C-b :move-pane -t :3.2                            Split 'window-3,pane-2', and then move the current-pane there.
  #   C-b :source ~/.config/tmux/tmux.conf              # To reload tmux configuration
  #
  # Custom:
  #
  #   C-b j                                             Move (join) pane from ... (existing window) to this current-window ???. "get the pane from there and bring it here"
  #   C-b s                                             Move (sent) current-pane to ... (existing window) ???. "take this current pane and send it there"
  #
  # It's worth noting that you target a pane using the following format:
  # "mysession:mywindow.mypane" (if in a different session),
  # and
  # "mywindow.mypane" (if in the same session).
  # You can also use
  # "mysession:progname" if the program running in that pane is unique
  #
  programs.tmux = {
    enable = true;
    #packages =  pkgs.tumx;
    clock24 = true;
    newSession = false;                                     # Automatically spawn a session if trying to attach and none are running.

    resizeAmount = 1;
    baseIndex = 1;
    escapeTime = 10;
    historyLimit = 10000;
    keyMode = "vi";
    terminal = "screen-256color";

    prefix = "C-b";
    #shortcut = "b";                                        # Default is "b".

    #withUtempter = true;                                   # Default is 'true'. Whether to enable libutempter for tmux. This is required so that tmux can write to /var/run/utmp (which can be queried with who to display currently connected user sessions). Note, this will add a guid wrapper for the group utmp!
    secureSocket = false;                                   # Store tmux socket under /run, which is more secure than /tmp, but as a downside it doesn’t survive user logout.

    extraConfig = ''
      #set -g mouse-select-window on
      #set -g mouse-select-pane on
      #set -g mouse-resize-pane on
      set -g mouse on                                       # Tmux 2.1 and above, need only this one line

      set -g default-terminal "screen-256color"

      #set -g bell-action none

      # Sano split commands: Split panes using | and -
      bind | split-window -h
      bind - split-window -v
      #unbind '"'
      #unbind %

      # Easy config reloads: reload config file with 'C-b r'
      bind r source-file ~/.config/tmux/tmux.conf

      ## Join windows: <prefix> s, <prefix> j
      #bind-key j command-prompt -p "join pane from:"  "join-pane -s '%%'"
      #bind-key s command-prompt -p "send pane to:"  "join-pane -t '%%'"
      # Change to '<prefix> Shift-j' and '<prefix> Shift-s'
      bind-key S-j command-prompt -p "join pane from:"  "join-pane -s '%%'"
      bind-key S-s command-prompt -p "send pane to:"  "join-pane -t '%%'"

      # Fast pane-switching: switch panes using Alt-arrow without prefix
      bind -n M-Up select-pane -U                           # Alt-Up
      bind -n M-Right select-pane -R                        # Alt-Right
      bind -n M-Left select-pane -L                         # Alt-Left
      bind -n M-Down select-pane -D                         # Alt-Down

      # Flipping the orientation of the current pane with the pane using Shift-arrow without prefix
      bind -n S-Up move-pane -h -t '.{up-of}'               # S-Up
      bind -n S-Right move-pane -t '.{right-of}'            # S-Right
      bind -n S-Left move-pane -t '.{left-of}'              # S-Left
      bind -n S-down move-pane -h -t '.{down-of}'           # S-Down

      # Do not rename windows automatically, I like to give my tmux windows custom names using the , key.
      set-option -g allow-rename off

      # Change background color of pane; differenciate background color between non-active-pane and active-pane.
      COLOR1=color233                   # light-black / dark-grey
      COLOR2=black                      # black
      COLOR3=color252                   # white
      set -g pane-border-style bg=$COLOR1,fg=$COLOR3
      set -g pane-active-border-style bg=$COLOR1,fg=$COLOR3
      set -g window-style bg=$COLOR1
      set -g window-active-style bg=$COLOR2

      # Change colors to easier to see how many windows have open and which one is active
      set -g status-bg cyan                                 # Change the status bar background color
      set -g window-status-style bg=yellow                  # Change inactive window color
      set -g window-status-current-style bg=green,fg=black  # Change active window color

      # Change date and time formating
      set -g status-right ""
      set -g status-right-length 60
      set -g status-right " \"#{client_user}@#{host_short}\" %A %Y-%m-%d %H:%M:%S "

      # ctrl-r to search the zsh-history in reverse, like emacs style
      #bind-key '^R' history-incremental-search-backward
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
          set -g @continuum-save-interval '5' # in minutes
        '';
      }
    ];
  };

  #home.file.".tmux.conf".text = ''
  #  setenv TERM screen-256color
  #'';
}
