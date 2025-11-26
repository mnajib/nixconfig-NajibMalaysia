{
  pkgs,
  config,
  ...
}:
{
  # can also use 'xlsfonts' to see which fonts are available to X.
  # if some fonts appear distorted, e.g. characters are invisible, or not anti-aliases you may need to rebuild the font cache with 'fc-cache --really-force --verbose'.
  # (after rm -vRf ~/.cache/fontconfig)
  #
  # Adding personal fonts to ~/.fonts doesn't work
  # The ~/.fonts directory is being deprecated upstream. It already doesn't work in NixOS.
  # The new preferred location is in $XDG_DATA_HOME/fonts, which for most users will resolve to ~/.local/share/fonts
  # $ ln -s /run/current-system/sw/share/X11/fonts ~/.local/share/fonts
  # $ ln -s ~/.local/share/fonts ~/.fonts
  #
  # Example: Install 'SourceCodePro-Regular':
  #font=$(nix-build --no-out-link '<nixpkgs>' -A source-code-pro)/share/fonts/opentype/SourceCodePro-Regular.otf
  #cp $font ~/.local/share/fonts
  #fc-cache
  # Verify that the font has been installed
  #fc-list -v | grep -i source
  #
  # $ cd /nix/var/nix/profiles/system/sw/share/X11/fonts
  # $ fc-query DejaVuSans.ttf | grep '^\s\+family:' | cut -d'"' -f2
  #
  #
  #==================================================
  # This is working solution as tested on
  # 2022-11-07
  # 2023-04-05
  # 2025-05-04
  # NOTE:
  #   - Must not in zip file, need to extracted
  #   - Can be in subdirectories
  #--------------------------------------------------
  # fc-list -v | grep -i edward
  # ln -s ~/.fonts ~/.local/share/fonts
  #
  # rm -vRf ~/.cache/fontconfig
  # fc-cache --really-force --verbose
  # fc-list -v | grep -i edward
  #==================================================
  #
  #
  fonts = {

    fontconfig.enable = true;
    #
    # System-wide default font(s). Multiple fonts may be listed in case multiple languages must be supported.
    #fontconfig.defaultFonts.serif = [ "DejaVu Serif" ];
    #fontconfig.defaultFonts.emoji = [ "Noto Color Emoji" ];
    #fontconfig.defaultFonts.sansSerif = [ "DejaVu Sans" ];
    #fontconfig.defaultFonts.monospace = [ "DejaVu Sans Mono" ]; # "jetbrains mono"
    #
    fontconfig.defaultFonts.monospace = [
      "Fira Mono for Powerline (Bold)"
      "DejaVu Sans Mono"
      "jetbrains mono"
    ];
    #
    #fontconfig.defaultFonts = {
    #  # --- Prioritize bitmap/monospace fonts ---
    #  monospace = [ "Terminus" "DejaVu Sans Mono" "Liberation Mono" ];  # Fallback chain
    #  sansSerif = [ "DejaVu Sans" "Liberation Sans" ];  # Avoid anti-aliased fonts
    #  serif = [ "DejaVu Serif" "Liberation Serif" ];
    #  #emoji = [];
    #};

    #fontconfig.antialias = false; # Disable anti-aliasing globally
    #fontconfig.hinting = {
    #  enable = true; # Force hinting for sharpness
    #  style = "full"; # Maximum hinting
    #};

    fontDir.enable = true;              # Create a directiry with links to all fonts in /run/current-system/sw/share/X11/fonts

    #enableCoreFonts = true;
    enableGhostscriptFonts = true;
    #fonts = with pkgs; [
    packages = with pkgs; [
      corefonts                         # Microsoft free fonts; Microsoft's TrueType core fonts for the Web
      inconsolata                       # monospaced
      ubuntu_font_family                # ubuntu fonts
      unifont                           # some international languages
      cardo                             # Cardo is a large Unicode font specifically designed for the needs of classicists, Biblical scholars, medievalists, and linguists.
      google-fonts
      tewi-font
      #kochi-substitude-naga10
      anonymousPro
      dejavu_fonts
      noto-fonts #font-droid
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      noto-fonts-monochrome-emoji
      noto-fonts-emoji-blob-bin
      noto-fonts-lgc-plus
      terminus_font_ttf
      source-code-pro                   # monospaced font family for user interface and coding environments
      fira-code                         # suitable for coding
      fira-code-symbols
      cascadia-code                     # Monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal
      #mplus-outline-fonts
      dina-font
      proggyfonts
      freefont_ttf
      liberation_ttf                    # Liberation Fonts, replacements for Times New Roman, Arial, and Courier New
      liberation-sans-narrow            # Liberation Sans Narrow Font Family is a replacement for Arial Narrow
      powerline-fonts
      terminus_font
      ttf_bitstream_vera

      vistafonts                        # Some TrueType fonts from Microsoft Windows Vista (Calibri, Cambria, Candara, Consolas, Constantia, Corbel)
      carlito                           # A sans-serif font, metric-compatible with Microsoft Calibri
      wineWowPackages.fonts             # Microsoft replacement fonts by the Wine project

      amiri
      scheherazade-new

      national-park-typeface

      source-han-sans-japanese
      source-han-sans-korean
      source-han-sans-simplified-chinese
      source-han-sans-traditional-chinese

      iosevka

      #nerdfonts
      #(nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ] })
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts.meslo-lg
      nerd-fonts.sauce-code-pro
      nerd-fonts.terminess-ttf
      nerd-fonts.monoid
      nerd-fonts.noto
      nerd-fonts.iosevka-term
      nerd-fonts._0xproto
      nerd-fonts.jetbrains-mono
      nerd-fonts.ubuntu

      jetbrains-mono # An opensource typeface made for developers. suitable for coding
      mononoki # A font for programming and code review
    ];
  }; # End font = { ... };

}
