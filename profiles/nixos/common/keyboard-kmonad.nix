{
  config,
  pkgs,
  lib,
  ...
}:

let
  # ---------------------------------------------------------
  # EDIT THIS: your actual keyboard device path
  # Find using: ls -l /dev/input/by-path | grep kbd
  # ---------------------------------------------------------
  keyboardDevice = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";

in
{
  #################################################################
  ## XKB LAYOUTS (OS-level)
  ##
  ## KMonad handles Dvorak now, so we remove XKB Dvorak.
  ## Layout switching order:
  ##   1. US (QWERTY as fallback)
  ##   2. US (QWERTY)
  ##   3. MSA Najib (Arabic/Jawi custom)
  #################################################################
  services.xserver.xkb = {
    layout = "us,us,msa";
    variant = ",,najib";  # removed XKB Dvorak
    options = "grp:shift_caps_toggle";

    extraLayouts = {
      msa = {
        description = "Arabic-Jawi Najib";
        languages = [ "msa" ];
        keycodesFile = ./xkb/keycodes/msa;
        typesFile    = ./xkb/types/msa;
        compatFile   = ./xkb/compat/msa;
        symbolsFile  = ./xkb/symbols/msa;
      };
    };
  };

  #################################################################
  ## INPUT subsystems
  #################################################################
  hardware.uinput.enable = true;

  environment.systemPackages = with pkgs; [
    kmonad
  ];

  #################################################################
  ## KMONAD CONFIG (system-wide, runs as root)
  #################################################################
  services.kmonad = {
    enable = true;

    keyboards = {
      dvorakWithLayers = {
        device = keyboardDevice;

        config = ''
          (defcfg
            input  (device-file "${keyboardDevice}")
            output (uinput-sink "kmonad-output")
            fallthrough true
            allow-cmd false
          )

          (defsrc
            esc f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12
            prtsc scroll pause
            grave 1 2 3 4 5 6 7 8 9 0 minus equal bs

            tab q w e r t y u i o p lbracket rbracket backslash

            caps a s d f g h j k l semicolon quote enter

            lshift z x c v b n m comma dot slash rshift

            lctrl lmeta lalt space ralt rmeta menu rctrl
          )

          ;; BASE LAYER = Dvorak + CapsModTap + SpaceFN
          (deflayer base
            esc f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12
            prtsc scroll pause
            grave 1 2 3 4 5 6 7 8 9 0 minus equal bs

            tab
              quote comma dot p y f g c r l
              slash equal backslash

            (caps (tap-hold-next lctrl caps))
              a o e u i d h t n s
              minus enter

            lshift
              semicolon q j k x b m w v z
            rshift

            lctrl lmeta lalt (space (tap-hold-next space fn))
                   ralt rmeta menu rctrl
          )

          ;; FN LAYER (SpaceFN)
          (deflayer fn
            esc f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12
            prtsc scroll pause
            grave 1 2 3 4 5 6 7 8 9 0 minus equal bs

            tab
              left up down right home pgup pgdn end
              left up down right home pgup pgdn end

            caps
              left up down right home pgup pgdn end
              left up down right home pgup pgdn end

            lshift
              left up down right home pgup pgdn end
              left up down right home pgup pgdn end

            lctrl lmeta lalt space ralt rmeta menu rctrl
          )
        '';
      };
    };
  };

}

