{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xfe
    clipgrab
    pcmanfm
    worker
    enlightenment.ephoto
    gtkimageview
    gthumb
    eog
    hakuneko
    mc
    fff
    nnn
    clifm
    sfm
    clex
    ranger
    deer
    joshuto
    lf
    vifm-full vimPlugins.vifm-vim
    trash-cli
    sxiv
    feh
    koodo-reader
    bookworm
    foliate
    alexandria
    koreader
  ];
}

