# profiles/nixos/hosts/printer2/configuration.nix

{
  config, pkgs, lib,
  ...
}:
let
  hostName = "printer2";
  #hostId = "";
  stateVersion = "26.05";
  commonDir = "../../common";
  hmDir = "../../../home-manager/users";
in
{

  imports = let
    fromCommon = name: ./. + "/${toString commonDir}/${name}";
  in [
    ./disko-sdcard.nix # mount filesystems
    #./hardware-configuration.nix # --no-filesystems
    ./raspberrypi2b.nix

    #../modules/print-scan-server.nix
    ./print-scan-server.nix

    (fromCommon "users-najib.nix")

    (fromCommon "console-keyboard-dvorak.nix")
    (fromCommon "keyboard-with-msa.nix")             # keyboard layout for graphical environment

  ];

  nixpkgs.buildPlatform = "x86_64-linux";

  # Explicitly declares the hardware architecture for Nixpkgs cross-evaluation
  nixpkgs.hostPlatform = "armv7l-linux";
  #nixpkgs.hostPlatform = nixpkgs.lib.systems.examples.armv7l-hf-multiplatform;

  networking.hostName = "${hostName}";
  networking.useDHCP = lib.mkDefault true;

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  services.openssh.enable = true;

  users.users.najib = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "lpadmin"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBq4RIXcuNoy8dHPy0WPu/dPcHOwcsRR/xNAwS4LKQCk najib@nyxora.localdomain"
    ];
  };

  security.sudo.wheelNeedsPassword = false;
  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "${stateVersion}";
}
