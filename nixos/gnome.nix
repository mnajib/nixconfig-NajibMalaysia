{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    gnome.nautilus
    gnome.sushi
  ];
  services.udev.packages = with pkgs; [
    gnome3.gnome-settings-daemon
  ];
}
