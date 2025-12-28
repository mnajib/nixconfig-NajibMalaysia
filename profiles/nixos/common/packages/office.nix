{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Office suite
    libreoffice hyphen hunspell hunspellDicts.en_US google-fonts
    scribus

    # Typesetting
    texlive.combined.scheme-full texstudio texmaker lyx tikzit tectonic pandoc

    # Notes/journals
    gnote cherrytree xournalpp rednotebook gnome-notes

    # Finance
    gnucash homebank
  ];
}

