{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xfe
    pcmanfm
    worker
    enlightenment.ephoto
    gtkimageview
    gthumb
    eog
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

    #clipgrab # use/require qtwebengine

    koreader
    #alexandria # marked as broken

    foliate
    #bookworm # marked as broken
    koodo-reader
    hakuneko
  ];
}

