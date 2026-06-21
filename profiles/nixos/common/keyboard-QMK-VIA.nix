{ config, pkgs, ... }:

{
  # Enable udev rules for QMK and VIA compatible keyboards
  hardware.keyboard.qmk.enable = true;

  environment.systemPackages = with pkgs; [
    via
  ];

  #home.packages = with pkgs; [
  #  via
  #];

  #Enable udev rules for QMK/VIA keyboards
  services.udev.packages = with pkgs; [
    qmk-udev-rules # generic rules
  ];

  services.udev.extraRules = ''
    # VIA/QMK WebHID and Desktop permissions
    #KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", TAG+="uaccess"
    #KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess"
    #KERNEL=="hidraw*", SUBSYSTEM=="hidraw", GROUP="plugdev", MODE="0666", TAG+="uaccess"

    # VIA/QMK Rules for Elecfox Linky87
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="36b0", ATTRS{idProduct}=="3005", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="36b0", ATTRS{idProduct}=="3005", MODE="0666", TAG+="uaccess"
  '';

  # This links the JSON file into your system profile for easy tracking/access
  # It will be accessible at: /etc/via/linky87.json
  #environment.etc."via/linky87pro.json".source = ./linky87pro.json;
  environment.etc."via/linky87pro.json".source = ./../src/etc/via/linky87pro.json;
  #
  # Open usevia.app via web browser or "via" GUI desktop program.
  # Go to the Design Tab.
  # Click Load and navigate to /etc/via/linky87.json to instantly restore your layout definition.
  #

  # Make sure your user is in the 'plugdev' group
  #users.users.naqib.extraGroups = [ "plugdev" ];
  #users.users.najib.extraGroups = [ "plugdev" ];

  #
  # Unplug your keyboard and plug it back in
  # or run:
  #   sudo udevadm control --reload-rules && sudo udevadm trigger
  #

}
