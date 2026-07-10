{
  config,
  pkgs,
  ...
}:
{


  # Via Home-Manager
  /*
  dconf.settings = {
    "org/gnome/desktop/a11y/applications" = {
      screen-keyboard-enabled = true;
    };
  };

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Settings.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
  };

  home.packages = with pkgs; [
    gnomeExtensions.improved-osk
  ];
  */


  #programs.dconf.enable = true;
  # Note: Defining dconf settings at the system level requires configuring a user profile database.

  /*
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/a11y/applications" = {
          screen-keyboard-enabled = true;
        };
        #"org/gnome/shell" = {
        #  favorite-apps = [
        #    "org.gnome.Settings.desktop"
        #    "org.gnome.Nautilus.desktop"
        #  ];
        #};
      };
    }
  ];
  */
  # Explicitly clean out the system-level dconf profile leftover from GNOME
  programs.dconf.profiles.user.databases = [];

  #i18n.inputMethod = {
  #  enable = true;
  #  type = "ibus";
  #};

  # Enables hardware (orientation) sensor sensing for automatic screen rotation
  hardware.sensor.iio.enable = true;

  # Enable the Maliit Input Method Framework
  #programs.maliit.enable = true;

  # This is the cleanest approach. Nix looks at gnomeExtensions first. If you
  # list improved-osk, it finds it there. If you were to list git, Nix wouldn't
  # find it in gnomeExtensions, so it would fall back to checking pkgs.
  #environment.systemPackages = with pkgs; with gnomeExtensions; [
  #
  # The inherit Approach (Alternative)
  environment.systemPackages = with pkgs; [

    # From pkgs
    #git
    #curl
    #gnomeExtensions.improved-osk
    #gnomeExtensions.keyboard-toggle
    #gnomeExtensions.al-hijri-date

    # From pkgs.gnomeExtensions
    #improved-onscreen-keyboard
    #im-panel-integrated-with-osk
    #touchup
    #kmonad-toggle
    #keyboard-toggle

    maliit-keyboard
    maliit-framework
    kdePackages.plasma-keyboard

    #awesome-tiles

    #al-hijri-date
    #better-desktop-zoom
    #battery-time-with-percentage

    # GNOME Extensions extracted from pkgs.gnomeExtensions
    /*
    (with gnomeExtensions; [
      improved-osk
      keyboard-toggle
      al-hijri-date
    ])
    */

  ];

}
