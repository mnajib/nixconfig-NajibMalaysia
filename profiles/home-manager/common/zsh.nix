{ pkgs, ... }: {

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      save = 10000;
      size = 10000;
    };
    defaultKeymap = "emacs"; #"viins";
    autosuggestion.enable = true; #enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
    };
    #enableVteIntegration = true;
    #package = pkgs.zsh

    shellAliases = {
      ll = "ls -l";
      ".." = "cd ..";
      j = "jobs";
      s = "sync";
      echod = "echo $DISPLAY";
      exportd = "export DISPLAY=:0";
    };

    #plugins = [
    #  {
    #    #name = "";
    #  };
    #
    #  #{};
    #];

    # Extra commands that should be added to .zshenv
    #envExtra = ''
    #'';

    # Extra commands that should be added to .zshrc
    initExtra = ''
      # Enable prompt expansion
      setopt PROMPT_SUBST

      # Colors
      autoload -U colors && colors

      # Left prompt
      #PROMPT='%F{yellow}[%D{%Y-%m-%d} %*]%f %F{cyan}%n@%m%f:%F{green}%~%f %# '
      PROMPT='%B%F{yellow}[%D{%Y-%m-%d} %*]%f %F{cyan}%n@%m%f:%F{green}%~%f %#%b '

      # Optional right prompt (example: exit code)
      # RPROMPT='%F{red}%?%f'

      # switch to vi-mode
      #bindkey -v
      export KEYTIMEOUT=1
      # make Alt+. work in insert mode
      bindkey -M viins '^[.' insert-last-word

      # Quick toggle between emacs-mode and vi-mode
      #bindkey '^E' bindkey -e   # example: Ctrl+E switches to emacs-mode
      #bindkey '^V' bindkey -v   # Ctrl+V switches back to vi-mode
    '';

    # Extra commands that should be added to .zlogin
    #loginExtra = ''
    #'';

  }; # End programs.zsh

  #home.file.".tmux.conf".text = ''
  #  setenv TERM screen-256color
  #'';
}
