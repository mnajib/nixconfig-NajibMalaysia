{
  config,
  pkgs,
  ...
}:
let

  myGnomeExtensionPackages = with pkgs.gnomeExtensions; [
    #improved-onscreen-keyboard
    im-panel-integrated-with-osk
    keyboard-toggle
    #kmonad-toggle
    gjs-osk

    touchup
    #touch-x

    al-hijri-date

    awesome-tiles
    forge
    gtile
    paperwm
    mosaic

    ordo
    zen
    argos
    cmud
    tophat
    apps
    timer
    blocker
    copyous
    net-speed
  ];

in
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

  # XXX: Force-load the kernel module for synthetic user input devices
  boot.kernelModules = [
    "uinput"
    "iio_st_accel" # Depending on tablet's accelerometer chip (e.g., STMicroelectronics)
  ];

  programs.dconf.enable = true;
  # Note: Defining dconf settings at the system level requires configuring a user profile database.

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/a11y/applications" = {
          screen-keyboard-enabled = true;
        };
        "org/gnome/shell" = {
          favorite-apps = [
            "org.gnome.Settings.desktop"
            "org.gnome.Nautilus.desktop"
          ];
        };
      };
    }
  ];

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
  };

  # Enables hardware (orientation) sensor sensing for automatic screen rotation
  hardware.sensor.iio.enable = true;

  # This is the cleanest approach. Nix looks at gnomeExtensions first. If you
  # list improved-osk, it finds it there. If you were to list git, Nix wouldn't
  # find it in gnomeExtensions, so it would fall back to checking pkgs.
  #environment.systemPackages = with pkgs; with gnomeExtensions; [
  #
  # The inherit Approach (Alternative)
  environment.systemPackages = with pkgs; [
    #git
    #curl

    iio-sensor-proxy # Utility tools for debugging sensor data
    onboard
  ] ++ myGnomeExtensionPackages;

}
