{
  pkgs,
  config,
  lib,
  ...
}:
let

  #c_brightyellow = "\[\e[93m\]";
  #c_brightgreen = "\[\e[92m\]";
  #c_brightcyan = "\[\e[96m\]";
  #c_brightblack = "\[\e[90m\]";
  #c_black = "\[\e[30m\]";
  #c_default = "\[\e[0m\]";
  #c_title = "\[\e]0;\u@\h: \w\a''\'''\'\$\]";
  #c_bell = "\\[\\a\\]";
  #c_date = "\$(date +'%Y-%m-%d %H:%M:%S')";
  #c_ps1 = lib.concatStrings [
  #c_ps1 = ""
  #  c_bell
  #  c_brightblack
  #  "[" c_date "]"
  #  c_brightgreen "[" c_title
  #  c_brightcyan "\u@\h"
  #  c_brightgreen ":\w]\$"
  #  c_default
  #c_ps1 = ''
  #'';

  #myInitCommands = ''
  #  c_ps1
  #'';
  #myInitCommands = ''
    #c_brightyellow='\[\e[93m\]'
    #c_brightgreen='\[\e[92m\]'
    #c_brightcyan='\[\e[96m\]'
    #c_brightblack='\[\e[90m\]'
    #c_black='\[\e[30m\]'
    #c_default='\[\e[0m\]'
    #c_title='\[\e]0;\u@\h: \w\a$\]'
    #c_bell='\[\a\]'
    #c_date=$(date +'%Y-%m-%d %H:%M:%S')
    #export PS1="$\{c_bell\}$\{c_brightyellow\}[$\{c_date\}] $\{c_brightgreen\}[$\{c_title\}$\{c_brightcyan\}\u@\h$\{c_brightgreen\}:\w]\$ $\{c_default\}"
    #export PS1="$\{c_bell\}$\{c_brightyellow\}[$\{c_date\}] $\{c_brightgreen\}[$\{c_title\}$\{c_brightcyan\}\u@\h$\{c_brightgreen\}:\w]\$ $\{c_default\}"
  #'';
in
{

  # SessionPath and sessionVariables creates a hm-session file that must be sourced:
  # Beware, it puts it in .profile, not in the .bashrc!
  programs.bash = {
    enable = true;
    enableCompletion = true;

    # Default:
    #   PS1='\n\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\] '
    # Change to:
    initExtra = ''
      # Common variables
      c_brightyellow='\[\e[1;93m\]'
      c_brightgreen='\[\e[1;92m\]'
      c_brightcyan='\[\e[1;96m\]'
      c_brightblack='\[\e[1;90m\]'
      c_black='\[\e[1;30m\]'
      c_default='\[\e[0m\]'
      c_title='\[\e]0;\u@\h: \w\a\]'
      c_bell='\[\a\]'
      c_date='\D{%Y-%m-%d} \t'

      # Root user (red prompt)
      if [ "$(id -u)" -eq 0 ]; then
        c_red='\[\e[1;31m\]'
        export PS1="''\${c_bell}''\${c_red}[''\${c_date}] [''\${c_title}''\${c_red}\u@\h:\w]\''\$ ''\${c_default}"
      else
        # Normal user (original colorful prompt)
        export PS1="''\${c_bell}''\${c_brightyellow}[''\${c_date}] ''\${c_brightgreen}[''\${c_title}''\${c_brightcyan}\u@\h''\${c_brightgreen}:\w]\''\$ ''\${c_default}"
      fi
    '';

    #shellOptions = [
    #];

    # Environment variable t...
    #sessionVariables = {
    #};

    shellAliases = {
      aoeu = "setxkbmap us";
      asdf = "setxkbmap dvorak";
      oeu = "loadkeys us";
      sdf = "loadkeys dvorak";
      l = "ls -alhF";
      #ll = "ls --color=tty -Filah";
      j = "jobs";
      s = "sync";
      #emacs = "emacs -nw";
      #la = "ls -Fa";
      p = "pwd";
      a = "alias";
      yi = "yi -k vim";
      grep = "grep --color";
    };

    # Extra commands that should be run when initializing a login shell.
    # This will append to ~/.profile
    profileExtra = ''
      umask 0002
    '';

    # Extra commands that should be run when initializing an interactive shell.
    #initExtra = ''
      #umask 0002
      #"$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    #'';

    # Extra commands that should be placed in ~/.bashrc.
    # Note that these commands will be run even in non-interactive shells.
    bashrcExtra = ''
      umask 0002
    '';
      #. ~/.bashrc
      #eval "$(direnv hook bash)"
      #colorscript random

      #if [[ -n "$CUSTOM_PS1" ]]; then
      #  #PS1='$CUSTOM_PS1 $PS1'
      #  PS1="$CUSTOM_PS1"
      #fi
    #'';

    #logoutExtra = ''
    #'';
  };
}
