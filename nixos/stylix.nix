{ pkgs, ... }:
{

  stylix.enable = true;

  #---------------------------------------------------------------------------
  # nix build nixpkgs#base16-schemes
  # cd result
  # nix run nixpkgs#eza -- --tree
  #---------------------------------------------------------------------------
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  #
  # OR
  #
  #stylix.base16Scheme = {
  #  base00 = "282828";
  #  base01 = "3c3836";
  #  #...
  #};
  #
  # OR
  #
  # Auto-generate from wallpaper
  #stylix.image = ./my-cool-wallpaper.png;
  #stylix.image = ../pictures/wallpaper-beautiful-and-minimalist.jpg;
  stylix.image = pkgs.fetchurl {
    url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
  };
  #stylix.polarity = "dark"; # "light", "dark', or "either"

  #---------------------------------------------------------------------------
  # nix build nixpkgs#bibata-cursors
  # cd result
  # nix run nixpkgs#eza -- --tree --level 3
  #---------------------------------------------------------------------------
  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.name = "Bibata-Modern-Ice";

  #---------------------------------------------------------------------------
  stylix.fonts = {
    monospace = {
      package = pkgs.nerdfonts.override {fonts = [ "JetBrainsMono" ];};
      name = "JetBrainsMono Nerd Font Mono";
    };
    #monospace = {
    #  package = pkgs.dejavu_fonts;
    #  name = "DejaVu Sans Mono";
    #};
    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
    #serif = config.stylix.fonts.monospace;
    #sansSerif = config.stylix.fonts.monospace;
    #emoji = config.stylix.fonts.monospace;
  };

  stylix.fonts.sizes = {
    applications = 12; # 1
    terminal = 10; # 15;
    desktop = 10; # 10;
    popups = 10; # 10;
  };

  #stylix.opacity = {
  #  applications = 1.0;
  #  terminal = 1.0;
  #  desktop = 1.0;
  #  popups = 1.0;
  #};

}
