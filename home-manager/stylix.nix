{ pkgs, config, ... }:
#let
#  inherit (pkgs.stdenv.hostPlatform) system;
#  nixvim-package = inputs.nixvim-config.packages.${system}.default;
#  extended-nixvim = nixvim-package.extend config.lib.stylix.nixvim.config;
#in
{

  programs.stylix.enable = true;

  #---------------------------------------------------------------------------
  # nix build nixpkgs#base16-schemes
  # cd result
  # nix run nixpkgs#eza -- --tree
  #---------------------------------------------------------------------------
  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
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
  #stylix.cursor.package = pkgs.bibata-cursors;
  #stylix.cursor.name = "Bibata-Modern-Ice";

  # NOTE: https://sourcefoundry.org/hack/playground.html
  #   - Hack
  #   - Liberation Mono
  #   - Ubuntu Mono
  #   - Roboto Mono
  #   - DejaVu Sans Mono
  #---------------------------------------------------------------------------
  #stylix.fonts = {
  #  monospace = {
  #    package = pkgs.nerdfonts.override {fonts = [ "JetBrainsMono" ];};
  #    name = "JetBrainsMono Nerd Font Mono";
  #    #package = pkgs.nerdfonts.override { fonts = [ "FiraMono" ]; };
  #    #name = "Fira Mono for Powerline (Bold)";
  #  };
  #  #monospace = {
  #  #  package = pkgs.dejavu_fonts;
  #  #  name = "DejaVu Sans Mono";
  #  #};
  #  sansSerif = {
  #    package = pkgs.dejavu_fonts;
  #    name = "DejaVu Sans";
  #  };
  #  serif = {
  #    package = pkgs.dejavu_fonts;
  #    name = "DejaVu Serif";
  #  };
  #  emoji = {
  #    package = pkgs.noto-fonts-emoji;
  #    name = "Noto Color Emoji";
  #  };
  #  #serif = config.stylix.fonts.monospace;
  #  #sansSerif = config.stylix.fonts.monospace;
  #  #emoji = config.stylix.fonts.monospace;
  #};
  stylix.fonts = {
    monospace = {
      #package = pkgs.nerdfont;
      #name = "0xProto Nerd Font";
      #name = "EnvyCodeR Nerd Font";
      package = pkgs.bront_fonts;
      name = "Bront Ubuntu Mono";
    };
    serif = {
      #package = pkgs.nerdfont;
      #name = "EnvyCodeR Nerd Font";
      package = pkgs.bront_fonts;
      name = "Bront Ubuntu Mono";
    };
    sansSerif = {
      #package = pkgs.nerdfont;
      #name = "EnvyCodeR Nerd Font";
      package = pkgs.bront_fonts;
      name = "Bront Ubuntu Mono";
    };
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
      #package = pkgs.nerdfont;
      #name = "EnvyCodeR Nerd Font";
      #package = pkgs.bront_fonts;
      #name = "Bront Ubuntu Mono";
    };
  };

  home.packages = with pkgs; [
    nerdfont
    bront_fonts
  ];

  #stylix.fonts.sizes = {
  #  applications = 9;#12; # 1
  #  terminal = 9;#10; # 15;
  #  desktop = 9;#10; # 10;
  #  popups = 9;#10; # 10;
  #};

  #stylix.opacity = {
  #  applications = 1.0;
  #  terminal = 1.0;
  #  desktop = 1.0;
  #  popups = 1.0;
  #};

}
