{ config, ... }:
{
  boot.loader = {
    systemd-boot.enable = true;

    #grub = {
    #  efiSupport = true;
    #  #useOSProber = true;
    #  #efiInstallAsRemovable = true;
    #};

    efi = {
      canTouchEfiVariables = true; # Must be disabled if efiInstallAsRemovable=true ?
      #efiSysMountPoint = "/boot/efi";
      #efiSysMountPoint = "/boot"; # Default
    };

  };

  #mirroredBoots = [
  #    {
  #        devices = [ "nodev" ];
  #        path = "/boot";
  #    }
  #    {
  #        devices = [ "nodev" ];
  #        path = "/boot2";
  #    }
  #];
  
  # For zfs
  #zfsSupport = true;
  #copyKernels = true;

}
