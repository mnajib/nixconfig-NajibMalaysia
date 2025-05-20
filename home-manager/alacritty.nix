{
  pkgs,
  ...
}: {

  fonts.fontconfig.enable = true; # Enable fontconfig if not already

  home.packages = with pkgs; [

    terminus_font  # The classic Terminus (bitmap-friendly)
    # Optional: Terminus Nerd Font if you need symbols
    (nerdfonts.override { fonts = [ "Terminus" ]; })

    hack-font  # Standard Hack
    # Optional: Hack Nerd Font if you need symbols (e.g., for tmux status line)
    (nerdfonts.override { fonts = [ "Hack" ]; })

  ];

  programs.alacritty = {
    enable = true;

    settings = {
      #font = {
      #  normal = {
      #    family = "Hack Nerd Font";  # or "Hack" if not using Nerd Fonts
      #    style = "Regular";
      #  };
      #  bold = {
      #    family = "Hack Nerd Font";
      #    style = "Bold";
      #  };
      #  italic = {
      #    family = "Hack Nerd Font";
      #    style = "Italic";
      #  };
      #  size = 8; #9.0;  # Adjust to your preferred small size (e.g., 8-10pt)
      #};

      # --- Critical settings for small-text clarity ---
      #font.use_thin_strokes = false;  # Disables anti-aliasing (sharper text)
      window = {
        padding = { x = 2; y = 2; };  # Reduce crowding
        dynamic_padding = true;        # Adjust padding on resize
      };

      # High-contrast color scheme (recommended)
      colors = {
        primary = {
          background = "0x000000";  # Pure black
          foreground = "0xFFFFFF";  # Pure white
        };
        cursor = {
          text = "0x000000";
          cursor = "0xFFFFFF";
        };
      };

      # Optional: Adjust glyph offset if characters feel cramped
      font.offset = { x = 0; y = 0; };
      font.glyph_offset = { x = 0; y = 0; };
    }; # End programs.alacritty.settings

  };

  #home.file.".tmux.conf".text = ''
  #  setenv TERM screen-256color
  #'';
}
