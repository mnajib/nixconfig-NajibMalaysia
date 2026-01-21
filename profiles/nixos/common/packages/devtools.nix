{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Debugging
    gdb gdbgui

    # Nix helpers
    direnv nix-top niv npins
    devenv

    # Languages
    lua python3Minimal
    nixd

    # Build tools
    git cmake libtool expect

    # Fonts & publishing
    fontforge fontforge-fonttools
    sigil manuskript

    # Code editor
    zed-editor
  ];
}

