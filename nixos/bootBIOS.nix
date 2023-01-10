{
    boot.loader.grub = {
        enable = true;
        version = 2;
        device = "/dev/sda";

	enableCryptodisk = true;
	copyKernels = true;

        useOSProber = true;
    };
}
