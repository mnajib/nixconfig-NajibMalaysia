# profiles/nixos/hosts/nyxora/kanata/kanata.nix

{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Ensure kernel support for virtual input interception
  boot.kernelModules = [ "uinput" ];
  hardware.uinput.enable = true;

  # Allow Kanata to manage keyboard inputs safely without running as root
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  # 1. Force the Linux virtual console/CLI text mode to use Dvorak immediately on boot
  console.keyMap = lib.mkForce "dvorak";
  # 2. Configure a clean XKB base layer as a pass-through
  services.xserver.xkb = {
    layout = lib.mkForce "us";
    variant = lib.mkForce "dvorak"; # Set standard dvorak as the baseline window environment
    options = lib.mkForce ""; # Clear any conflicting shortcuts
  };

  # Declarative Kanata Service Configuration
  services.kanata = {
    enable = true;
    keyboards = {
      internalEngine = {
        devices = [ ];
        extraDefCfg = "process-unmapped-keys yes";

        # This is where the magic happens: Nix pulls the text file content in at build time
        config = builtins.readFile ./kanata-internal.lisp;
      };
    };
  };
}
