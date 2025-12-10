{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Office suite
    libreoffice scribus

    # Typesetting
    texlive.combined.scheme-full texstudio texmaker lyx tikzit tectonic pandoc

    # Notes/journals
    gnote cherrytree xournalpp rednotebook gnome-notes

    # Finance
    gnucash homebank
  ];
}

