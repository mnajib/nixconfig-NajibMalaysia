===============================================================================
                       NIXOS KANATA KEYBOARD LAYOUT ENGINE
===============================================================================

1. INTRODUCTION & ARCHITECTURE OVERVIEW
---------------------------------------
This workspace manages a unified, kernel-level, multi-layout keyboard system on
NixOS utilizing the Kanata advanced software extraction engine.

To bypass regional configuration drift and guarantee absolute consistency across
all execution environments—including X11 graphical sessions, Wayland compositors,
and low-level Linux Virtual TTY Consoles—the entire architecture relies on a
technique called "Inverse Mapping" (Nested Translation Matrix).

Instead of cycling multiple independent layout indexes via traditional X11/XKB
shortcuts, the configuration implements a static processing pipeline:

   [ Physical Keyboard Input (Standard US QWERTY Spec) ]
                         │
                         ▼
   [ Stage 1: Kanata Kernel-Level Interception Layer ]
     - Handles ergonomic hold-to-navigate chord mappings.
     - Performs dynamic inverse scancode translations to simulate alternative
       layout geometries.
                         │
                         ▼
   [ Stage 2: System-Level Layout Engine (Xorg / XKB) ]
     - Hardcoded permanently to a baseline of "US Dvorak".
                         │
                         ▼
   [ Final Output Displayed on Screen ]

By hardcoding the system layout layer to US Dvorak downstream, Kanata can modify
the scancodes it outputs upstream depending on your chosen layer profile. For
example, if you choose the QWERTY layer profile, Kanata actively alters the codes
it feeds to Xorg so that when Xorg applies its Dvorak transformation, the final
output lands precisely on standard QWERTY characters.


2. COMPONENT FILES & THEIR RESPONSIBILITIES
--------------------------------------------
The configuration workspace is modularly segmented into three critical files:

A. kanata.nix
   - Location: /etc/nixos/hosts/nyxora/kanata/kanata.nix
   - Responsibility: System-level hardware configuration service module. It ensures
     kernel module support for virtual input generation ('uinput'), creates secure,
     non-root udev rules for input tracking, forces early-boot virtual consoles
     to initiate using a native Dvorak layout template, and binds the master
     kanata.service system background daemon to compile the core Lisp logic.

B. keyboard-with-msa.nix
   - Location: /etc/nixos/hosts/nyxora/kanata/keyboard-with-msa.nix
   - Responsibility: XKB localization profile provider. It sets the immutable X11
     baseline mapping coordinates (`layout = "us"`, `variant = "dvorak"`) and clears
     any traditional desktop keyboard shortcuts. It also handles the declarative
     injection of custom Arabic-Jawi ('msa') typing symbols.

C. kanata-internal.lisp
   - Location: /etc/nixos/hosts/nyxora/kanata/kanata-internal.lisp
   - Responsibility: The primary behavioral translation table. This file houses
     the physical key dimension mapping arrays (`defsrc`), defines the active alpha
     layers ('dvorak', 'qwerty', 'colemak_dh', 'msa'), holds the simultaneous-press
     chord activation sequences for cursor control navigation, and houses macro paths
     to bypass structural character execution blocks (such as the '@' symbol).


3. OPERATIONAL MODES & LAYOUT REVENUE DICTIONARY
------------------------------------------------
The keyboard engine supports four core runtime layout profiles. Because the downstream
system translates keys into Dvorak by default, the layers are built as follows:

- dvorak (System Default Baseline Layout)
  Acts as a transparent pass-through schema (`_`). Since XKB is already converting
  QWERTY inputs into Dvorak, Kanata allows the letters to cross unaltered.

- qwerty (Standard US QWERTY Target)
  Applies an inverse scancode matrix map to deceive XKB's lookup tables, resetting
  your screen printing output to traditional QWERTY geometries.

- colemak_dh (Ergonomic Colemak-DH Target)
  Executes a double-nested lookup script. It alters Colemak-DH positions down into
  an inverse-Dvorak template format to yield true Colemak-DH text output.

- msa (Arabic-Jawi Custom Layout Target)
  Maps out a QWERTY footprint matrix to cleanly route standard scancode locations
  into your declared XKB symbols template file, unblocking phonetically grouped
  Jawi script processing.


4. USER MANUAL: HOW TO OPERATE THE SYSTEM
-----------------------------------------

4.1 SWITCHING BETWEEN LAYOUT PROFILES
    Your layout selection engine is managed directly via a kernel gateway. To shift
    your active keyboard typing profile:

    1. Double-tap the physical [Caps Lock] key on your keyboard. This temporarily
       suspends normal typing and engages the Layout Management Router.
    2. Within 200ms, press one of the four assignment keys on your function row:
       - Press [F1] -> Instantly switches the system into QWERTY mode.
       - Press [F2] -> Instantly restores the system to default DVORAK mode.
       - Press [F3] -> Instantly switches the system into COLEMAK-DH mode.
       - Press [F4] -> Instantly switches the system into JAWI-MALAY (MSA) mode.

4.2 THE INTEGRATED SIMULTANEOUS CHORD NAVIGATION
    No matter which alpha layout layer is actively selected, ergonomic text cursor navigation
    is bound directly to the physical home-row area (the QWERTY H J K L position space).

    To use directional controls without moving your hands away from your home row:
    - Press and Hold [Caps Lock] + [Spacebar] simultaneously with your left hand.
    - While held, use your resting right hand on the home row to control navigation:
      * Physical [H] -> Move Cursor LEFT
      * Physical [J] -> Move Cursor DOWN
      * Physical [K] -> Move Cursor UP
      * Physical [L] -> Move Cursor RIGHT
    - Release either activation key to return to typing letters instantaneously.


5. DISASTER SHELL & EARLY SYSTEM BOOT EXPECTATIONS
---------------------------------------------------
Due to the sequence of the Linux system lifecycle initialization pipeline, input parsing
varies across the following specific booting phases:

- Stage 1: The GRUB Bootloader Menu Screen
  The keyboard operates strictly on original hardware firmware defaults (US QWERTY).
  Hard drive decryption passwords or kernel boot adjustments must be entered via a
  QWERTY layout mindset.

- Stage 2: Early Boot Virtual Console / TTY Login Screen
  Once the kernel boots, the explicit declarative line `console.keyMap = "dvorak"`
  is executed. Emergency recovery prompts, maintenance shells, and raw text logins
  initialize natively using standard Dvorak.

- Stage 3: Operational Runtime Environment
  As soon as NixOS initializes background services, the Kanata daemon intercepts
  the hardware layer. Dvorak persists as your default master baseline layout, and the
  layout-switching router and hold-to-navigate chords become fully active.
===============================================================================
