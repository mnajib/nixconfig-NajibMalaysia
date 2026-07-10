{
  config,
  pkgs,
  ...
}:
{

  # Force-load the kernel module for synthetic user input devices
  boot.kernelModules = [ "uinput" ];

  # Define hardware rules allowing members of the "input" group to use uinput
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input"
  '';

  # Declaratively register the XWayland autostart profile for all users
  environment.etc."xdg/autostart/onboard.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Onboard Virtual Keyboard
    Exec=env GDK_BACKEND=x11 onboard
    Hidden=false
    NoDisplay=false
    X-KDE-autostart-after=panel
  '';

  # Forces the Wayland compositor to activate the on-screen keyboard layer on the lock screen
  #environment.variables = {
  #  QT_IM_MODULE = "maliit";
  #};

  # Lock Screen OSK configuration (Maliit framework engine)
  environment.sessionVariables = {
    QT_IM_MODULE = "maliit";
  };

  #i18n.inputMethod = {
  #  enable = true;
  #  type = "ibus";
  #};

  # Enables hardware (orientation) sensor sensing for automatic screen rotation
  hardware.sensor.iio.enable = true;

  # This is the cleanest approach. Nix looks at gnomeExtensions first. If you
  # list improved-osk, it finds it there. If you were to list git, Nix wouldn't
  # find it in gnomeExtensions, so it would fall back to checking pkgs.
  #environment.systemPackages = with pkgs; with gnomeExtensions; [
  #
  # The inherit Approach (Alternative)
  environment.systemPackages = with pkgs; [

    onboard # virtual keyboard package

    # Required specifically to drive input on the desktop screen lock layer
    maliit-keyboard
    maliit-framework
    kdePackages.plasma-keyboard

  ];

  services.displayManager.enable = true;

  # Force SDDM Wayland and expose the Input Method Modules
  services.displayManager.sddm = {
    # Ensure SDDM logs in natively using Wayland protocols
    wayland.enable = true; #

    # Forcefully spawn Onboard right into the greeter context window
    setupScript = ''
      ${pkgs.onboard}/bin/onboard &
    ''; #

    # Include the required layout libraries directly in the display manager layer
    extraPackages = with pkgs; [
      kdePackages.qtvirtualkeyboard #
      kdePackages.qtwayland
      kdePackages.qtsvg # Required to render the default visual key assets
      kdePackages.layer-shell-qt # REQUIRED: Allows SDDM to render OSK layers over Wayland shells
      kdePackages.plasma-keyboard # Ensures layout engines are bound to sddm shell
    ];

    settings = {

      /*
      General = {
        InputMethod = "qtvirtualkeyboard"; #

        # Instructs the login window shell to integrate cleanly with Wayland overlays
        #GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
      };

      # FORCE KWIN WAYLAND COMPOSITOR TO RUN THE INTERACTIVE KEYBOARD BACKEND
      Wayland = {
        CompositorCommand = "${pkgs.kdePackages.kwin}/bin/kwin_wayland --no-lockscreen --no-global-shortcuts --inputmethod qtvirtualkeyboard --locale1";
      };
      */

    };
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "najib"; # Automatically logs directly into your safe user namespace
  };

  # CRUCIAL FIX: Inject the layout variables directly into the systemd environment loop
  systemd.services.display-manager.environment = {
    QT_IM_MODULE = "qtvirtualkeyboard";
    QT_VIRTUALKEYBOARD_DESKTOP_DISABLE = "0"; # Forces it to run on standard desktop screens
  };

  # 7. Reset systemd service environment blocks
  systemd.services.display-manager.environment = {};

  # Explicitly clean out the system-level dconf profile leftover from GNOME
  programs.dconf.profiles.user.databases = [];

  users.users.najib.extraGroups = [
    "input" # This handles the required permissions perfectly
  ];

}
