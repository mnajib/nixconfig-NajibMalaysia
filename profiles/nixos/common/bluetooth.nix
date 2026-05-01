{
  pkgs,
  config,
  ...
}:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Helps with some flaky controllers
        Experimental = true;
      };
    };
  };

  # 3. Kernel Tweaks for Realtek Stability
  # This prevents the kernel from 'sleeping' the USB dongle,
  # which often causes the disconnects seen in your logs.
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  environment.systemPackages = with pkgs; [
    #blueman
  ];

  services.blueman = {
    enable = true;
  };
}
