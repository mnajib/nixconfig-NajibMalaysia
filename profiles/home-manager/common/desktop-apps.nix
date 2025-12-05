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
  ];

}
