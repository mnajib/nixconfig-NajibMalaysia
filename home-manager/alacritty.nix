{
  pkgs,
  ...
}: {

  fonts.fontconfig.enable = true; # Enable fontconfig if not already

  home.packages = with pkgs; [

    terminus_font  # The classic Terminus (bitmap-friendly)
    # Optional: Terminus Nerd Font if you need symbols
    #(nerdfonts.override { fonts = [ "Terminus" ]; })

    hack-font  # Standard Hack
    # Optional: Hack Nerd Font if you need symbols (e.g., for tmux status line)
    #(nerdfonts.override { fonts = [ "Hack" ]; })

    unifont # another bitmap option, good for legacy displays. Older/low-DPI screens can make small text look blurry or pixelated, even with optimized fonts.

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

      #font.normal.family = "Terminus";  # Not "Terminus (TTF)"!
      #font.size = 8; #10; # Bitmap fonts often need integer sizes
      #font.use_thin_strokes = false;    # Disable anti-aliasing

      # --- Critical settings for small-text clarity ---
      #font.use_thin_strokes = false;  # Disables anti-aliasing (sharper text)
      window = {
        #padding = { x = 2; y = 2; };  # Reduce crowding
        #dynamic_padding = true;        # Adjust padding on resize
        decorations = "none"; # Reduce UI clutter
        padding = { x = 1; y = 1; }; # Minimize padding
        dynamic_padding = false; # Prevents auto-adjustment
      };

      # High-contrast color scheme (recommended)
      colors = {
        primary = {
          background = "0x000000";  # Pure black
          #foreground = "0xFFFFFF";  # Pure white
          foreground = "0xAAAAAA";  # Light gray (softer than pure white)
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
