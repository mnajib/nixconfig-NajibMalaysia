{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # CLI editors
    nano
    neovim vimHugeX
    kakoune
    micro
    ed vis jedit

    # GUI editors
    geany notepadqq xfce.mousepad
    enlightenment.ecrire gnome-text-editor
  ];
}

