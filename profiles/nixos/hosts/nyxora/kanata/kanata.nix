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

  # ---------------------------------------------------------------------------
  # Membuka sekatan akses uinput untuk Perkhidmatan Kanata Systemd
  # ---------------------------------------------------------------------------
  systemd.services."kanata-internalEngine" = {
    serviceConfig = {
      # Memaksa systemd menjalankan perkhidmatan ini sebagai root (melangkau sandboxing)
      DynamicUser = lib.mkForce false;

      # Membenarkan perkhidmatan membaca dan menulis ke subsistem peranti uinput
      DeviceAllow = [ "/dev/uinput rw" ];
      # Memastikan Systemd tidak menyekat akses perkakasan maya ini
      PrivateDevices = lib.mkForce false;
      # Menambah kumpulan uinput ke dalam perkhidmatan jika diperlukan
      SupplementaryGroups = [ "uinput" "input" ];
    };
  };

  # Declarative Kanata Service Configuration
  services.kanata = {
    enable = true;
    keyboards = {
      internalEngine = {
        devices = [

          # khawlah
          #"/dev/input/by-path/platform-i8042-serio-0-event-kbd"
          #"/dev/input/by-path/pci-0000:00:14.0-usb-0:2.3.1.2:1.0-event-kbd"

          # nyxora
          "/dev/input/by-path/pci-0000:00:1d.0-usb-0:1.1:1.0-event-kbd"
          "/dev/input/by-path/pci-0000:00:1d.0-usb-0:1.4:1.0-event-kbd"

        ];

        extraDefCfg = "process-unmapped-keys yes";

        # This is where the magic happens: Nix pulls the text file content in at build time
        config = builtins.readFile ./kanata-internal.lisp;
      };
    };
  };
}
