{
  pkgs,
  ...
}: {

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
  # :show-options -g
  # :show-options
  # :list-options -g
  # :list-options
  # :show <option-name>
  # :show default-terminal
  # :show terminal-overrides
  # :show terminal-features
  #

  #programs.fzf.tmux.enableShellIntegration = true;

  programs.tmux = {
    enable = true;
    #packages =  pkgs.tumx;
    clock24 = true;
    newSession = false; # Automatically spawn a session if trying to attach and none are running.
    mouse = true; # Default: false

    resizeAmount = 1;
    baseIndex = 1;
    escapeTime = 10;  # 0 # use '0' to zero-out escape time delay
    historyLimit = 10000; # 1000000
    keyMode = "vi";
    #terminal = "screen-256color";

    prefix = "C-b";
    #shortcut = "b";                                        # Default is "b".

    # Store tmux socket under /run, which is more secure than /tmp, but as a
    # downside it doesn’t survive user logout.
    secureSocket = false;
    #
    # Default is 'true'. Whether to enable libutempter for tmux. This is
    # required so that tmux can write to /var/run/utmp (which can be queried
    # with who to display currently connected user sessions). Note, this will
    # add a guid wrapper for the group utmp!
    #withUtempter = true;

    #focusEvents = true;

    aggressiveResize = true;

    sensibleOnTop = false; # Run the sensible plugin at the top of the configuration. It is possible to override the sensible settings using the programs.tmux.extraConfig option.

    extraConfig = ''
      #set -g mouse-select-window on
      #set -g mouse-select-pane on
      #set -g mouse-resize-pane on
      set -g mouse on                                       # Tmux 2.1 and above, need only this one line

      # NOTES:
      #   'Tc' is true-colors
      #    'RGB' is color codes for true-colors
      #
      # Check if running in a graphical environment
      #if-shell '[[ $TERM == screen-256color || $TERM == *xterm* || $TERM == *-256color ]]' {
      if-shell '[[ $TERM == linux ]]' { # if in console terminal
        set -g default-terminal "screen"
        #set-option -ga terminal-overrides ",screen:Tc"
        #set-option -sa terminal-features ",screen:RGB"
      } { # if in terminal emulator, if-shell '[ "$TERM" != "linux" ]'
        set -g default-terminal "screen-256color"
        #set-option -ga terminal-overrides ",screen-256color:Tc"
        #set-option -sa terminal-features ",screen-256color:RGB"
        set-option -ga terminal-overrides ",screen*:Tc"
        set-option -ga terminal-overrides ",xterm*:Tc"
        set-option -sa terminal-features ",screen*:RGB"
        set-option -sa terminal-features ",xterm*:RGB"
      }

      set -g detach-on-destroy off  # Do not exit from tmux when closing a session
      set -g renumber-windows on # renumber all windows when any window is closed
      set -g set-clipboard on # use system clipboard
      #set -g default-terminal "$\{TERM}"

      #set -g bell-action none

      # '<c-b>:resize-window -a' will resize to the smallest session.
      # '<c-b>:resize-window -A' will set it to 'manual'.
      # '<c-b>:attach-session -d' will redraw the tmux window ???.
      #set -g window-size smallest # 'largest' 'manual' 'latest'.
      #
      #setw -g aggressive-resive on
      #set-window-option -g aggressive-resize
      #
      # By default, when multiple clients (e.g., 2 terminals) are attached to the same session, tmux will choose the smallest client size as the window size.
      # To change this:
      # Automatically resize window to match the current client size
      #set-window-option -g aggressive-resize on
      # This is useful when:
      #   You use tmux attach from many devices with different terminal sizes (e.g., laptop vs desktop).
      #   You want the current terminal to always get the best experience.
      #
      # NOTE: should use the aggressiveResize option provided by Home Manager's programs.tmux module.

      # Sano split commands: Split panes using | and -
      bind | split-window -h
      bind - split-window -v
      #unbind '"'
      #unbind %

      # Easy config reloads: reload config file with 'C-b r'
      #bind r source-file ~/.config/tmux/tmux.conf
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

      # Cycle Through Windows: Cycle through your open windows without having to manually select them by number.
      # This lets you switch between windows using Ctrl+l and Ctrl+h for next and previous windows, respectively.
      bind C-l next-window
      bind C-h previous-window

      # Jump to Last Active Window. Quickly switch to the last active window (useful when you're flipping between two tasks).
      # Now, pressing prefix + Tab will jump to the most recently active window.
      bind Tab last-window

      ## Join windows: <prefix> s, <prefix> j
      #bind-key j command-prompt -p "join pane from:"  "join-pane -s '%%'"
      #bind-key s command-prompt -p "send pane to:"  "join-pane -t '%%'"
      # Change to '<prefix> Shift-j' and '<prefix> Shift-s'
      bind-key S-j command-prompt -p "join pane from:"  "join-pane -s '%%'"
      bind-key S-s command-prompt -p "send pane to:"  "join-pane -t '%%'"

      # Fast pane-switching / switch focus to another pane : switch panes using Alt-arrow without prefix
      bind -n M-Up select-pane -U                           # Alt-Up
      bind -n M-Right select-pane -R                        # Alt-Right
      bind -n M-Left select-pane -L                         # Alt-Left
      bind -n M-Down select-pane -D                         # Alt-Down

      # Flipping the orientation (horizontal <-> vertical ???) of the current pane with the pane using Shift-arrow without prefix
      bind -n S-Up move-pane -h -t '.{up-of}'               # S-Up
      bind -n S-Right move-pane -t '.{right-of}'            # S-Right
      bind -n S-Left move-pane -t '.{left-of}'              # S-Left
      bind -n S-down move-pane -h -t '.{down-of}'           # S-Down

      # Resizing Panes with Easy Key Bindings
      # You can create custom key bindings to quickly resize panes in all directions. This can save time compared to manually resizing panes.
      # Before this, resize pane using '<prefix> <arrow>'
      bind -r C-Up resize-pane -U 1    #5
      bind -r C-Down resize-pane -D 1  #5
      bind -r C-Left resize-pane -L 1  #5
      bind -r C-Right resize-pane -R 1 #5

      # Synchronize Panes
      # Sometimes you want to run the same command in all panes simultaneously. This setting lets you do that.
      # Press prefix + s to toggle synchronized input to all panes.
      #bind s setw synchronize-panes

      # ctrl-r to search the zsh-history in reverse, like emacs style
      #bind-key '^R' history-incremental-search-backward

      # Copy Mode Improvements. Enhance tmux copy mode (especially if you're using Vim keybindings) by setting up a more Vim-like behavior for selecting and copying text.
      #setw -g mode-keys vi   # Enable vim keybindings for copy mode
      #bind -T copy-mode-vi v send-keys -X begin-selection  # Start selection with 'v'
      #bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"  # Yank text with 'y'
      # Now you can use v to start selection and y to copy to the system clipboard using xclip. You can change xclip to wl-copy if you're on Wayland.

      # Change background color of pane; differenciate background color between non-active-pane and active-pane.
      #COLOR1=color233                   # light-black / dark-grey
      #COLOR2=black                      # black
      #COLOR3=color252                   # white
      #set -g pane-border-style bg=$COLOR1,fg=$COLOR3 # 'fg=brightblack,bg=default'
      #set -g pane-active-border-style bg=$COLOR1,fg=$COLOR3 # 'fg=magenta,bg=default'
      #set -g window-style bg=$COLOR1
      #set -g window-active-style bg=$COLOR2
      #
      set -g pane-border-style 'bg=black,fg=white'
      set -g pane-active-border-style 'bg=black,fg=magenta'
      set -g window-style  'bg=black,fg=default'
      set -g window-active-style 'bg=black,fg=default'

      # Change colors to easier to see how many windows have open and which one is active
      set -g status-bg cyan                                 # Change the status bar background color
      set -g status-fg black                                # Change the status bar fg
      set -g status-position bottom                         # top
      set -g status-style 'bg=#1e1e2e'                      # transparent
      set -g status-justify left


      # ===========================================================
      # NOTES:
      # -----------------------------------------------------------
      # To query tmux's environment variables from inside tmux:
      #   :display-message -p '#{status-left}'
      #   :display-message -p '#{status-right}'
      # To query tmux's environment variables from outside tmux:
      #   $ tmux display-message -p '#{status-left}'
      #   $ tmux display-message -p '#{status-right}'
      # -----------------------------------------------------------


      # ===========================================================
      # Left Status
      # -----------------------------------------------------------
      set -g status-left-length 200 #

      #set -g status-left "#{?client_prefix,#[bg=#ff0000],} #{session_name} "

      # Turns status-left
      #   blue if the window is zoomed,
      #   pink if the prefix is active, and
      #   yellow in copy mode.
      set -g status-left "\
      #[bg=cyan] \
      #[bg=cyan,fg=black]\
      #{?window_zoomed_flag,#[bg=blue],}\
      #{?client_prefix,#[bg=red],}\
      #{?pane_in_mode,#[bg=yellow],}\
       \
      [#{session_name}]\
       \
      #[default] "

      # tmux #{session_id}:#{session_name}
      # tmux #(echo #{session_id} | sed 's/^\\$//'):#{session_name}


      # ===========================================================
      # Center Status
      # -----------------------------------------------------------
      set -g window-status-format "#I:#W#{?window_flags,#{window_flags}, }"
      set -g window-status-current-format "#I:#W#{?window_flags,#{window_flags}, }"
      #
      # NOTE: Press prefix-l (Ctrl-b l) to toggle between the active window and the last active window;
      #       or use ':last-window'.
      #set -g window-status-style         bg=green,fg=brightblack
      #set -g window-status-last-style    bg=green,fg=brightwhite
      #set -g window-status-current-style bg=green,fg=black
      set -g window-status-style          bg=green,fg=brightblack
      #set -g window-status-last-style     bg=green,fg=brightblue
      set -g window-status-last-style     bg=green,fg=black
      set -g window-status-current-style  bg=green,fg=black

      # set it same with window-status-style do make it look the same as no changes/activity
      #set -g window-status-activity-style          bg=green,fg=brightblack
      # or/and just turn-off the function
      set -g monitor-activity off
      # ===========================================================


      # ===========================================================
      # Right Status
      # -----------------------------------------------------------
      # Change date and time formating
      set -g status-right ""
      set -g status-right-length 200 # 60 # 200
      #
      #set -g status-right " \"#{client_user}@#{host_short}\" %A %Y-%m-%d %H:%M:%S "
      set -g status-right " #[bg=white,fg=black]#P:#{pane_title}#[default] #[bg=yellow,fg=black]\"#{client_user}@#{host_short}\"#[default] %A %Y-%m-%d %H:%M:%S "
      #set -g status-right " #{prefix_highlight} \"#{client_user}@#{host_short}\" %A %Y-%m-%d %H:%M:%S "
      # ===========================================================


      # Advanced Status Bar Customization
      # Display network statistics, memory usage, or other system info in the status bar. Here's an example for network bandwidth and free memory:
      # This adds download/upload speeds and memory usage to the status bar, making it easy to monitor system performance at a glance.
      #set -g status-right "#(ifstat -i eth0 0.1 1 | tail -1 | awk '{print \"DL: \" $1 \" KB/s UL: \" $2 \" KB/s\"}') | RAM: #(free -h | grep Mem | awk '{print $3 \"/\" $2}') | %H:%M %d-%b-%Y"

      # Display Active Processes in Status Bar
      # You can also display the current top active processes or track resource-heavy commands:
      # This shows the most CPU-intensive process in real-time on the right side of the status bar.
      #set -g status-right "#(ps --no-headers -eo comm,%cpu --sort=-%cpu | head -n 1) | %H:%M %d-%b-%Y"

      # Status bar with system info
      #set -g status-interval 5
      #set -g status-right "#(ps --no-headers -eo comm,%cpu --sort=-%cpu | head -n 1) | DL: #(ifstat -i eth0 0.1 1 | tail -1 | awk '{print $1 \" KB/s\"}') | RAM: #(free -h | grep Mem | awk '{print $3 \"/\" $2}') | %H:%M %d-%b-%Y"

      ##set-option -g automatic-rename off
      ##set-option -g automatic-rename on
      #set-option -g automatic-rename-format ...
      # Do not rename tmux windows automatically, I like to give my tmux windows custom names using the , key.
      # Allow programs in the pane to change the window name using a terminal escape sequence (\ek...\e\\).
      #set-option -g allow-rename off
      set-option -g allow-rename on                   # 'on' to allow tmux receives title from bash (I configured bash will sent new title at each prompt)
      # but how to make command that currently run (in bash) as 'tmux pane title'?

      # Allow programs in the pane (for example, bash shell) to change the title (title of the tmux pane) using the terminal escape sequences (\e]2;...\e\\ or \e]0;...\e\\). 
      #set-option -g allow-set-title off
      set-option -g allow-set-title on

      # Set tmux to forward the window title to the outer terminal emulator
      set -g set-titles on                            # To make tmux set (window) title to the outer (terminal emulator)
      #set -g set-titles-string "#P: #W (#S)"          # Default?
      #set -g set-titles-string "#S: #W (#P)"          # Session name, Window name, Pane name
      #set -g set-titles-string "#S: #W: #P: (#F)"          # Session name, Window name, Pane name, Current command
      #set -g set-titles-string "#S: #W: #P: (#T)"          # Session name, Window name, Pane name, Pane title
      set -g set-titles-string "#T"          # Session name, Window name, Pane name, Pane title
      #set -ga terminal-overrides ',*:set-titles:a'
      #set -ga terminal-overrides ',*:set-titles-string:a "#S: #W"'
    '';

    #tmuxinator.enable = true;

    plugins = with pkgs; [
      # ??? To install plugin in tmux using tmux-plugin-manager (TPM)? : prefix + I

      #--------------------------------
      # cpu
      #--------------------------------
      tmuxPlugins.cpu

      #--------------------------------
      # resurrect
      #--------------------------------
      {
        # To manually save session, press: prefix + Ctrl+s
        # To manually restore session, press: prefix + Ctrl+r
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-save-layouts 'on'
        '';
      }

      #--------------------------------
      # continuum
      #--------------------------------
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          #set -g @continuum-boot 'on' # Not sure this will work in NixOS.
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '0' # '5' to save every 5 minutes. '0' to disable autosave.
        '';
      }

      #--------------------------------
      # tmux-fzf
      #--------------------------------
      {
        plugin = tmuxPlugins.tmux-fzf;
      }

      #--------------------------------
      # fzf-tmux-url
      #--------------------------------
      {
        plugin = tmuxPlugins.fzf-tmux-url;
      }

    ];
  };

  #home.file.".tmux.conf".text = ''
  #  setenv TERM screen-256color
  #'';
}
