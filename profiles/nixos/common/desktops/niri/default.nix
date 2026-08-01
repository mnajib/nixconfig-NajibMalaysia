{ config, pkgs, lib, ... }:

{
  # 1. Ensure required packages are globally available or handled via your profile
  environment.systemPackages = with pkgs; [
    waybar
    niri
    swayidle
    jq
    bash
  ];

  # 2. Enable and configure Niri compositor on NixOS
  programs.niri.enable = true;

  # 3. Configure Waybar instances and automatically deploy config/script files via XDG/Home-Manager or Nix mechanisms
  # (If you use Home Manager, adapt the xdg.configFile paths below into your home.nix)
  #xdg.configFile."waybar/config-top.jsonc".text = builtins.toJSON {
  #  layer = "top";
  #  position = "top";
  #  height = 28;
  #  modules-center = [ "custom/waktusolat" ];
  #  "custom/waktusolat" = {
  #    format = "{}";
  #    return-type = "json";
  #    interval = 2;
  #    exec = "\${HOME}/.config/waybar/scripts/waktusolat.sh";
  #    escape = false;
  #  };
  #};
  xdg.configFile."waybar/config-top.jsonc" = {
    source = ./waybar/config-top.jsonc;
  };

  #xdg.configFile."waybar/config-bottom.jsonc".text = builtins.toJSON {
  #  layer = "top";
  #  position = "bottom";
  #  height = 28;
  #  modules-left = [ "niri/workspaces" ];
  #  modules-center = [ "clock" ];
  #  modules-right = [ "tray", "battery" ];
  #  "niri/workspaces" = {
  #    format = "{index}";
  #    all-outputs = true;
  #    disable-scroll = true;
  #  };
  #  clock = {
  #    format = "{:%Y-%m-%d %H:%M}";
  #  };
  #};
  xdg.configFile."waybar/config-bottom.jsonc" = {
    source = ./waybar/config-bottom.jsonc;
  };


  # 4. Deploy your helper script directly from your repository source
  xdg.configFile."waybar/scripts/waktusolat.sh" = {
    source = ./waybar/scripts/waktusolat.sh; # Place waktusolat.sh in the same directory as this nix file
    executable = true;
  };

  # 5. Configure Niri startup behavior inside its KDL definition or via a managed file block
  # Alternatively, place this block in your ~/.config/niri/config.kdl:
  /*
    spawn-at-startup "waybar" "-c" "/home/najib/.config/waybar/config-top.jsonc"
    spawn-at-startup "waybar" "-c" "/home/niri/.config/waybar/config-bottom.jsonc"
    spawn-at-startup "swayidle" "-w" "timeout" "300" "swaylock -f"
  */
}
