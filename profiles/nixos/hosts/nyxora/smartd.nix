#
#
#

{
  pkgs,
  config,
  lib,
  ...
}:
let
  thisHost = config.networking.hostname;
in
{

  environment.systemPackages = with pkgs; [
    #sanoid
  ];

  services.smartd = {
    enable = true;

    # Apply to all devices by default, but be more lenient with sda
    #defaults.autodetect = "-a -d sat -o on -S on";
    #defaults.monitored = "-a -d sat -o on -S on";
    #defaults.monitor = "-m <nomailer> -M exec /run/current-system/sw/bin/true"; # disable broadcast messages
    defaults.monitored = "-a -d sat -o on -S on -m <nomailer> -M exec /run/current-system/sw/bin/true";

    # Disable the 'wall' terminal spam
    #notifications.wall.enable = false;

    devices = [

      {
        #device = "/dev/sda";
        # Explicitly handling the "noisy" drive by ID
        device = "/dev/disk/by-id/ata-ST3500413AS_Z2ALGCNL";

        # We combine the flag into the -m directive
        # Format: -m <address> -M <directive>
        # 'noselftest' is technically a modifier for the -m flag in many versions
        options = "-a -d sat -n standby -m none,noselftest";
      }

    ];
  };

}
