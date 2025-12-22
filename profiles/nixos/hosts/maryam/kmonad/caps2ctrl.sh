#!/usr/bin/env bash
#KEYBOARD="/dev/input/by-id/$(ls /dev/input/by-id/ | grep -i "kbd" | head -n1)"
KEYBOARD=/dev/input/by-path/platform-i8042-serio-0-event-kbd
sudo kmonad - <<EOF
(defcfg
  input  (device-file "$KEYBOARD")
  output (uinput-sink "kmonad output")
  fallthrough true
)
(defsrc
  esc f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12
  grave 1 2 3 4 5 6 7 8 9 0 minus equal
  q w e r t y u i o p lbrace rbrace bslash
  a s d f g h j k l semicolon quote
  z x c v b n m comma dot slash
  space tab capslock lshift lctrl lalt lmeta rshift rctrl ralt rmeta
)
(deflayer main
  capslock (tap-hold 200 lctrl capslock)
)
EOF

