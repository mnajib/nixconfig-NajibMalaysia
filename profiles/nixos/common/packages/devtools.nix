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
    cmake libtool expect

    # Version control
    git
    jujutsu

    # Fonts & publishing
    fontforge fontforge-fonttools
    sigil manuskript

    # Code editor
    zed-editor
  ];

  /*
  environment.etc."jj/config.toml".text = ''
    [user]
    name = "Najib Ibrahim"
    email = "mnajib@gmail.com"

    [aliases]
    hist = ["log", "-r", "all()", "--template", 'builtin_log_compact ++ if(remote_bookmarks, "\n  " ++ remote_bookmarks)']
  '';
  */

}

