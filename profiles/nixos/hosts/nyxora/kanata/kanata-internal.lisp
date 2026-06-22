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

;; Since XKB converts QWERTY to Dvorak, we pass alphas through cleanly.
(deflayer dvorak
  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
  _    _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _    _    _
  @caps-d   _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _              spc            _    _    _
)

;; Lapisan QWERTY Terbalik (Memaksa isyarat mentah keluar sebagai susunan QWERTY)
;;(deflayer qwerty
;;  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
;;  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
;;  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
;;  @caps-q a    s    d    f    g    h    j    k    l    ;    '    ret
;;  lsft z    x    c    v    b    n    m    ,    .    /    rsft
;;  lctl lmet lalt           spc            ralt rmet rctl
;;)
(deflayer qwerty
  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
  grv  1    2    3    4    5    6    7    8    9    0    [    ]    bspc
  tab  x    ,    d    o    k    t    f    g    s    r    /    =    \
  @caps-q a ;   h    y    u    j    c    v    p    z    i    ret
  lsft b    i    .    n    l    m    w    e    [    _    rsft
  lctl lmet lalt           spc            ralt rmet rctl
)

;; Lapisan Colemak-DH Terbalik (Disesuaikan khusus untuk menterjemah kedudukan Colemak ke OS Dvorak)
;;(deflayer colemak_dh
;;  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
;;  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
;;  tab  q    w    f    p    b    j    l    u    y    ;    [    ]    \
;;  @caps-c a    r    s    t    g    m    n    e    i    o    '    ret
;;  lsft z    x    c    d    v    k    h    ,    .    /    rsft
;;  lctl lmet lalt           spc            ralt rmet rctl
;;)
;; Lapisan Colemak-DH Terbalik (Disesuaikan khusus untuk menterjemah kedudukan Colemak ke OS Dvorak)
(deflayer colemak_dh
  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
  tab  x    ,    y    r    n    c    p    f    t    z    [    ]    \
  @caps-c a o   ;    k    u    m    l    d    g    s    i    ret
  lsft b    i    h    .    /    v    j    w    e    [    rsft
  lctl lmet lalt           spc            ralt rmet rctl
)

;; Lapisan MSA Terbalik (Sama dengan susunan QWERTY kerana enjin XKB msa anda membaca input fonetik QWERTY)
;;(deflayer msa
;;  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
;;  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
;;  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
;;  @caps-m a    s    d    f    g    h    j    k    l    ;    '    ret
;;  lsft z    x    c    v    b    n    m    ,    .    /    rsft
;;  lctl lmet lalt           spc            ralt rmet rctl
;;)
;; Lapisan MSA Terbalik (Sama dengan susunan QWERTY kerana enjin XKB msa anda membaca input fonetik QWERTY)
(deflayer msa
  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
  grv  1    2    3    4    5    6    7    8    9    0    [    ]    bspc
  tab  x    ,    d    o    k    t    f    g    s    r    /    =    \
  @caps-m a ;   h    y    u    j    c    v    p    z    i    ret
  lsft b    i    .    n    l    m    w    e    [    _    rsft
  lctl lmet lalt           spc            ralt rmet rctl
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
;; CONTROL GATEWAY (Switches layouts using safe Number Keys 1, 2, 3, 4)
;; ============================================================================
;;(deflayer layout_management
;;  _    _      _      _      _      _    _    _    _    _    _    _    _
;;  lrld @ctx-q @ctx-d @ctx-c @ctx-m _    _    _    _    _    _    _    _    _
;;  _    _      _      _      _      _    _    _    _    _    _    _    _    _
;;  _    _      _      _      _      _    _    _    _    _    _    _    _
;;  _    _      _      _      _      _    _    _    _    _    _    _
;;  _    _      _              _              _    _    _
;;)
;;
;; 1. Pengurusan semasa anda sedang aktif di Dvorak (Lompat ke Qwerty jika tekan `)
(deflayer mgmt_from_dvorak
  _    _      _      _      _      _    _    _    _    _    _    _    _
  @rot-to-qwerty @ctx-q @ctx-d @ctx-c @ctx-m _    _    _    _    _    _    _    _    _
  _    _      _      _      _      _    _    _    _    _    _    _    _    _
  _    _      _      _      _      _    _    _    _    _    _    _    _
  _    _      _      _      _      _    _    _    _    _    _    _
  _    _      _              _              _    _    _
)

;; 2. Pengurusan semasa anda sedang aktif di Qwerty (Lompat ke Colemak jika tekan `)
(deflayer mgmt_from_qwerty
  _    _      _      _      _      _    _    _    _    _    _    _    _
  @rot-to-colemak @ctx-q @ctx-d @ctx-c @ctx-m _    _    _    _    _    _    _    _    _
  _    _      _      _      _      _    _    _    _    _    _    _    _    _
  _    _      _      _      _      _    _    _    _    _    _    _    _
  _    _      _      _      _      _    _    _    _    _    _    _
  _    _      _              _              _    _    _
)

;; 3. Pengurusan semasa anda sedang aktif di Colemak (Lompat ke MSA jika tekan `)
(deflayer mgmt_from_colemak
  _    _      _      _      _      _    _    _    _    _    _    _    _
  @rot-to-msa    @ctx-q @ctx-d @ctx-c @ctx-m _    _    _    _    _    _    _    _    _
  _    _      _      _      _      _    _    _    _    _    _    _    _    _
  _    _      _      _      _      _    _    _    _    _    _    _    _
  _    _      _      _      _      _    _    _    _    _    _    _
  _    _      _              _              _    _    _
)

;; 4. Pengurusan semasa anda sedang aktif di MSA (Lompat kembali ke Dvorak jika tekan `)
(deflayer mgmt_from_msa
  _    _      _      _      _      _    _    _    _    _    _    _    _
  @rot-to-dvorak @ctx-q @ctx-d @ctx-c @ctx-m _    _    _    _    _    _    _    _    _
  _    _      _      _      _      _    _    _    _    _    _    _    _    _
  _    _      _      _      _      _    _    _    _    _    _    _    _
  _    _      _      _      _      _    _    _    _    _    _    _
  _    _      _              _              _    _    _
)

;; ============================================================================
;; INTERCEPTION MACHINERY (Stabilized Tap-Hold Architecture)
;; ============================================================================
(defalias
  ;; Pintasan terus menggunakan nombor 1, 2, 3, 4
  ctx-q (layer-switch qwerty)
  ctx-d (layer-switch dvorak)
  ctx-c (layer-switch colemak_dh)
  ctx-m (layer-switch msa)

  ;; Takrifan real-at untuk menghasilkan '@' dengan betul di bawah sistem Dvorak
  ;;real-at S-'

  ;; Rantaian Kitaran (Rotation Chain) untuk kekunci Grave (`)
  rot-to-qwerty     (layer-switch qwerty)
  rot-to-colemak    (layer-switch colemak_dh)
  rot-to-msa        (layer-switch msa)
  rot-to-dvorak     (layer-switch dvorak)

  ;; Teras Utama Caps Lock Mengikut Konteks Lapisan
  caps-d (tap-hold 200 200 caps (layer-while-held mgmt_from_dvorak))
  caps-q (tap-hold 200 200 caps (layer-while-held mgmt_from_qwerty))
  caps-c (tap-hold 200 200 caps (layer-while-held mgmt_from_colemak))
  caps-m (tap-hold 200 200 caps (layer-while-held mgmt_from_msa))
)
