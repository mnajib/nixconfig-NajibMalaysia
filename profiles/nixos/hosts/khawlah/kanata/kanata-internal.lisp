;; profiles/nixos/hosts/nyxora/kanata/kanata-internal.lisp

(defsrc
  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
  caps a    s    d    f    g    h    j    k    l    ;    '    ret
  lsft z    x    c    v    b    n    m    ,    .    /    rsft
  lctl lmet lalt           spc            ralt rmet rctl
)

;; ============================================================================
;; BASE LAYOUTS (Adjusted to account for XKB's system-level Dvorak mapping)
;; ============================================================================

;; Since XKB is already converting QWERTY to Dvorak, we pass alphas through cleanly.
(deflayer dvorak
  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
  _    _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _    _    _
  @caps-d _ _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _              @spc-d         _    _    _
)

;; To output QWERTY while XKB forces Dvorak, Kanata applies the inverse map.
(deflayer qwerty
  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
  grv  1    2    3    4    5    6    7    8    9    0    '    [    bspc
  tab  x    b    @real-at .  k    g    c    r    l    /    =    ]    \
  @caps-q u  o    e    i    d    h    t    n    s    -    q    ret
  lsft ;    p    j    k    x    f    m    w    v    z    rsft
  lctl lmet lalt           @spc-q         ralt rmet rctl
)

;; Colemak-DH inverted to cancel out XKB's Dvorak conversion
(deflayer colemak_dh
  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
  grv  1    2    3    4    5    6    7    8    9    0    '    [    bspc
  tab  x    b    k    .    g    j    l    c    r    -    =    ]    \
  @caps-c u  p    s    t    d    h    n    e    i    o    q    ret
  lsft ;    z    f    v    x    b    m    w    ,    /    rsft
  lctl lmet lalt           @spc-c         ralt rmet rctl
)

;; Jawi Layout: Must mimic QWERTY footprint to pass clean standard locations to your xkb map
(deflayer msa
  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
  grv  1    2    3    4    5    6    7    8    9    0    '    [    bspc
  tab  x    b    @real-at .  k    g    c    r    l    /    =    ]    \
  @caps-m u  o    e    i    d    h    t    n    s    -    q    ret
  lsft ;    p    j    k    x    f    m    w    v    z    rsft
  lctl lmet lalt           @spc-m         ralt rmet rctl
)

;; ============================================================================
;; HOLD NAVIGATION LAYERS (Always bound to physical QWERTY H J K L spacing)
;; ============================================================================

(deflayer nav_dvorak
  _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    left down up   rght _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _              _              _    _    _
)

(deflayer nav_colemak_dh
  _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    left down up   rght _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _              _              _    _    _
)

(deflayer nav_qwerty
  _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    left down up   rght _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _              _              _    _    _
)

(deflayer nav_msa
  _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    left down up   rght _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _              _              _    _    _
)

;; ============================================================================
;; CONTROL GATEWAY
;; ============================================================================
(deflayer layout_management
  @ctx-q @ctx-d @ctx-c @ctx-m _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _              _              _    _    _
)

;; ============================================================================
;; INTERCEPTION MACHINERY
;; ============================================================================
(defchords navigation_trigger 100
  (caps-d spc-d) @act-nav-dvorak
  (caps-c spc-c) @act-nav-colemak
  (caps-q spc-q) @act-nav-qwerty
  (caps-m spc-m) @act-nav-msa
)

(defalias
  enter-layout-gate (layer-toggle layout_management)

  ctx-q (layer-switch qwerty)
  ctx-d (layer-switch dvorak)
  ctx-c (layer-switch colemak_dh)
  ctx-m (layer-switch msa)

  act-nav-dvorak  (layer-while-held nav_dvorak)
  act-nav-colemak (layer-while-held nav_colemak_dh)
  act-nav-qwerty  (layer-while-held nav_qwerty)
  act-nav-msa     (layer-while-held nav_msa)

  caps-d (tap-dance 200 ((chord navigation_trigger caps-d) @enter-layout-gate))
  spc-d  (chord navigation_trigger spc-d)

  caps-c (tap-dance 200 ((chord navigation_trigger caps-c) @enter-layout-gate))
  spc-c  (chord navigation_trigger spc-c)

  caps-q (tap-dance 200 ((chord navigation_trigger caps-q) @enter-layout-gate))
  spc-q  (chord navigation_trigger spc-q)

  caps-m (tap-dance 200 ((chord navigation_trigger caps-m) @enter-layout-gate))
  spc-m  (chord navigation_trigger spc-m)

  ;; Safely outputs the "@" character by triggering Shift + 2 explicitly
  real-at (macro S-2)
)
