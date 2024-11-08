{
  pkgs,
  config,
  ...
}:
let
  #c_brightyellow = "\[\033[1;93m\]";
  #c_brightgreen = "\[\033[1;92m\]";
  #c_brightcyan = "\[\033[1;96m\]";
  #c_brightblack = "\[\033[1;90m\]";
  #c_black = "\[\033[1;30m\]";
  #c_default = "\[\033[0m\]";
  #var3 = var1 + " " + var2;
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
    #   export PS1='[\u@\h \W] [$(date +"%Y-%m-%d %H:%M:%S")] \$ '
    #   export PS1='\n[$(date +"%Y-%m-%d %H:%M:%S")] \[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\] '
    #   export PS1='\n\[\033[1;93m\][$(date +"%Y-%m-%d %H:%M:%S")] \[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\] '
    #   export PS1='\[\033[1;93m\][$(date +"%Y-%m-%d %H:%M:%S")] \[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\] '
    #   export PS1='\[\033[1;93m\][$(date +"%Y-%m-%d %H:%M:%S")] \[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\] '
    #   export PS1='${toString c_brightyellow}[$(date +"%Y-%m-%d %H:%M:%S")] ${toString c_brightgreen}[\[\e]0;\u@\h: \w\a\]\u@\h:${toString c_brightyan}\w${toString c_brightgreen}]\$${toString c_default} '
    #   export PS1='${toString c_brightyellow}[$(date +"%Y-%m-%d %H:%M:%S")] ${toString c_brightgreen}[${toString c_brightcyan}\[\e]0;\u@\h \w\a\]\u@\h${toString c_brightgreen}:${toString c_brightgreen}\w${toString c_brightgreen}]\$${toString c_default} '
    #   export PS1='\[\033[1;93m\][$(date +"%Y-%m-%d %H:%M:%S")] \[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\] '
    #   export PS1='\[\033[1;93m\][$(date +"%Y-%m-%d %H:%M:%S")] \[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\[\033[1;96m\]\u\[\033[1;92m\]@\[\033[1;96m\]\h\[\033[1;92m\]:\w]\$\[\033[0m\] '
    #   export PS1='\[\033[1;93m\][$(date +"%Y-%m-%d %H:%M:%S")] \[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\[\033[1;96m\]\u@\h\[\033[1;92m\]:\w]\$\[\033[0m\] '
    initExtra = ''
      export PS1='\a\[\033[1;93m\][$(date +"%Y-%m-%d %H:%M:%S")] \[\033[1;32m\][\[\033[1;96m\]\u@\h\[\033[1;92m\]:\w]\$\[\033[0m\] '
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
