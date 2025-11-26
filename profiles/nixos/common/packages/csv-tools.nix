{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    csvq
    csvtk
    csvkit
    csview
    csv2md
    csvtool
    csvlens
    csvdiff
    csv2svg
    csv2odf
    csv-tui
    csvquote
    xlsx2csv
    xan   # xsv
    clevercsv
    graph-cli
    zsv
    textql
    tabview
    tidy-viewer
    tabiew
    miller
    json-plot
  ];
}

