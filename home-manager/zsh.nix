{ pkgs, ... }: {

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      save = 10000;
      size = 10000;
    };
    defaultKeymap = "viins"
    enableAutosuggestions = true;
    enableCompletion = true:
    syntaxHighlighting = {
      enable = true;
    };
    #enableVteIntegration = true;
    #package = pkgs.zsh

    shellAliases = {
      ll = "ls -l";
      ".." = "cd ..";
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
    #initExtra = ''
    #'';

    # Extra commands that should be added to .zlogin
    #loginExtra = ''
    #'';

  }; # End programs.zsh

  #home.file.".tmux.conf".text = ''
  #  setenv TERM screen-256color
  #'';
}
