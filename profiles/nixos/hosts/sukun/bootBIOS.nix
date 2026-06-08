{

  boot.loader = {

    # Disable the modern UEFI boot engine
    systemd-boot.enable = false;

    # Enable and configure legacy GRUB 2 for GPT
    grub = {
      enable = true;
      #version = 2;

      # Target the raw block device, NOT a partition
      device = "/dev/sda";

      # Crucial for LUKS: Ensures GRUB can prompt for decryption passphrase at boot
      enableCryptodisk = true;

      copyKernels = true;

      useOSProber = true;

      # Controls how many historical generations are visible in the grub.cfg file
      #configurationLimit = 10;

    }; # End boot.leador.grub = { ... };

  }; # End boot./oader = { ... };

}
