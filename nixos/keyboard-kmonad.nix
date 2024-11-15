{
  config,
  pkgs,
  ...
}:
{
  # References:
  #   https://github.com/kmonad/kmonad/blob/master/doc/installation.md#nixos
  #   https://github.com/kmonad/kmonad/blob/master/nix/nixos-module.nix
  #   https://www.youtube.com/watch?v=Dhj1eauljwU
  #

  #services.xserver.layout = "us,us,msa,msa";
  #services.xserver.xkbVariant = "dvorak,,najib,macnajib";
  #services.xserver.xkbOptions = "";

  services.xserver.xkb = {

    layout = "us,us,msa";
    variant = "dvorak,,najib";
    options = "grp:shift_caps_toggle";
    #
    #layout = "us";
    #options = "compose:ralt";

    extraLayouts = {
      msa = {
        description = "Arabic-Jawi Najib";
        languages = [ "msa" ];
        keycodesFile = ./xkb/keycodes/msa;
        typesFile = ./xkb/types/msa;
        compatFile = ./xkb/compat/msa;
        symbolsFile = ./xkb/symbols/msa;
        #geometryFile = ./xkb/geometry/msa; # irrelevant
      };
    };
  }; # End services.xserver.xkb

  #services.kmonad = {
  #  #enable = true;
  #  enable = false;
  #
  #  keyboards = {
  #    myKMonadOutput = {
  #      #device = "/dev/input/by-id/my-keyboard-kbd";
  #      #config = builtins.readFile ~/.config/kmonad/config.kbd;
  #      device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
  #      #config = builtins.readFile "${config.users.users.username.home}/.config/kmonad/config.kbd";
  #    };
  #  };
  #};
  # NOTE:
  # If you just enable the service and don't specify a keyboard, you may have to add
  #   users.users.«userName».extraGroups = [ "input" "uinput" ];
  # to your configuration.

  #users.groups.uinput = {};
  #users.users.${config.users.users.username}.extraGroups = [ "input" "uinput" ];
  #users.groups.uinput.members = [ naim naqib nurnasuha ];

  hardware.uinput.enable = true;

  #environment.systemPackages = [ pkgs.kmonad ];
  environment.systemPackages = with pkgs; [ kmonad ];
}
