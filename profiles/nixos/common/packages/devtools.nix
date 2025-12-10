{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Debugging
    gdb gdbgui

    # Nix helpers
    direnv nix-top niv npins

    # Languages
    lua python3Minimal

    # Build tools
    git cmake libtool expect

    # Fonts & publishing
    fontforge fontforge-fonttools
    sigil manuskript
  ];
}

