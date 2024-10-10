{ config, pkgs, ... }:
let
  #color = pkgs.writeText "color.vim" (import ./theme.nix config.colorscheme);
in
{
  #imports = [
  #  ./ui.nix
  #];
  #home.sessionVariables.EDITOR = "nvim";

  home.packages = with pkgs; [
    evince
  ];

  xdg.desktopEntries = {

    # This will create evince.desktop ???
    evince = {
      name = "Evince";
      genericName = "Document Viewer";
      comment = "Viewer for PDF, PS, EPS, XPS, DjVu, TIFF, DVI(with SyncTeX), and Comic Books archives (CBR, CBT, CBZ, CB7).";
      exec = "evince %F";
      icon = "evince";
      mimeType = [
        "application/pdf"
        "application/postscript"
        "application/x-djvu"
        "application/x-ps"
        "application/x-postscript"
        "image/vnd.djvu"
        "image/vnd.djvu+multipage"
      ];
      terminal = false;
      type = "Application";
      categories = [ "Utility" "DocumentViewer" ];
    };
  };

  xdg.mimeApps = {

    # Whether to manage $XDG_CONFIG_HOME/mimeapps.list.
    # The generated file is read-only.
    enable = false;

    # Defines additional associations of applications with mimetypes, as if the .desktop file was listing this mimetype in the first place.
    associations.added = {
      #"mimetype1" = [ "foo1.desktop" "foo2.desktop" "foo3.desktop" ];
      #"mimetype2" = "foo4.desktop";
      "application/pdf" = "evince.desktop";
    };
  };
}
