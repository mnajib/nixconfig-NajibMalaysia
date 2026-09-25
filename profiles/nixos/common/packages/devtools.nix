{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Debugging
    gdb gdbgui

    # Nix helpers
    direnv nix-top niv npins
    devenv
    nix-direnv

    # Languages
    lua
    python3Minimal
    python313Packages.pip
    nixd

    # language servers
    nixd                                                    # Nix
    rust-analyzer                                           # Rust
    pyright                                                 # Python
    gopls                                                   # Go
    #
    vim-language-server
    vimdoc-language-server
    simple-completion-language-server
    lua-language-server                                     # Lua
    nginx-language-server
    postgres-language-server
    arduino-language-server
    autotools-language-server
    cmake-language-server
    typescript-language-server                 #
    #vscode-langservers-extracted               # For HTML/CSS/JSON
    systemd-language-server
    tailwindcss-language-server                             # Tailwind CSS
    css-variables-language-server
    yaml-language-server                                    # YAML
    docker-language-server          # Docker
    dockerfile-language-server
    dot-language-server
    haskell-language-server
    java-language-server
    jdt-language-server
    kotlin-language-server
    bash-language-server                       # Bash
    awk-language-server

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

