{
  inputs,
  outputs,
  #lib,
  config,
  pkgs,
  ...
}:
#let
#in
{
  #imports = [
  #];

  home.packages = with pkgs; [
    gimp3-with-plugins
    flameshot # A powerful yet simple to use screenshot software

    # Web browser
    #firefox
    librewolf

    # Create a pdf
    rst2pdf
    python313Packages.reportlab
    typst # markup-based typesetting system that is powerful and easy to learn
    typstyle # Format your typst source code
    python313Packages.weasyprint # Converts web documents to PDF

    # Create a presentation
    typstPackages.polylux # a package for the typesetting system Typst to create presentation slides
    typstwriter # GUI tool / text editor to help writing typs document
    polylux2pdfpc # convert polylux to pdfpc

    # Do a presentatation
    pdfpc # presentation from PDF file

    # Messenger
    #nheko # a desktop client for the Matrix protocol
    #element-desktop # A feature-rich client for Matrix.org
    #fluffychat # Chat with your friends (matrix client)
    teams-for-linux # Unofficial Microsoft Teams client for Linux
    vesktop # Alternate client for Discord with Vencord built-in

    anki # Spaced repetition flashcard program
    code-cursor # AI-powered code editor built on vscode. unfree
    obsidian # Powerful knowledge base that works on top of a local folder of plain text Markdown files. unfree

    imv # Command line image viewer for tiling window managers
    bemoji # Emoji picker with support for bemenu/wofi/rofi/dmenu and wayland/X11
    nix-prefetch-scripts # Collection of all the nix-prefetch-* scripts which may be used to obtain source hashes
  ];

}
