# profiles/home-manager/users/najib/khawlah/hyprland.nix

{ inputs, outputs, lib, config, pkgs, ... }:
#let
  #username = "najib";
  #hostname = "khawlah";
  #commonDir = "../../../common";
  #stateVersion = "25.05";
#in
{

  home.packages = with pkgs; [
    noctalia-shell   # Complete desktop shell layer (bar, launcher, notifications)
    pcmanfm-qt       # Graphical file manager
    pavucontrol      # Audio control GUI
    wdisplays        # Display layout tool
  ];

  #wayland.windowManager.hyprland = {
  #  enable = true;
  #  #extraConfig = builtins.readFile ./hyprland-extraconfig.conf;
  #};

  # Autostart Noctalia instead of sfwbar/mako
  xdg.configFile."labwc/autostart".text = ''
    noctalia-shell &
    nm-applet --indicator &
  '';

  # Labwc window action overrides (optional UI tuning)
  #xdg.configFile."labwc/rc.xml".text = ''
  #  <?xml version="1.0" encoding="UTF-8"?>
  #  <labwc_config>
  #    <theme>
  #      <cornerRadius>6</cornerRadius>
  #    </theme>
  #  </labwc_config>
  #'';

}
