
#
# References:
#   - https://yomaq.github.io/posts/zfs-encryption-backups-and-convenience/
#   - https://github.com/jimsalterjrs/sanoid
#   - https://search.nixos.org/options?channel=24.11&size=50&sort=relevance&type=packages&query=syncoid
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
  #boot.kernelPackages = lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;

  #config = mkIf cfg.zfs.enable {
  #  environment.systemPackages = [ pkgs.zfs-prune-snapshots];
  #};

  boot.kernelParams = [
    "nohibernate"
    #"zfs.zfs_arc_max=17179869184"
  ];

  boot.supportedFilesystems = [ "vfat" "zfs" ];

  environment.systemPackages = with pkgs; [
    #zfs-prune-snapshots
    sanoid
  ];

  # ---------------------------------------------------------------------------------------
  services.zfs = {

   # Enable and start snapshot timers as needed:
   #   systemctl enable zfs-auto-snapshot-daily.timer
   # available intervals: frequent, hourly, daily, weekly, monthly
   #
   # Recursively (-r) list available snapshots:
   #   zfs list -t snap -r pool/dataset
   #
   # You can set properties on pools/datasets to enable/disable
   # specific snapshots (if unset, then it evaluates to "true"):
   #   zfs set com.sun:auto-snapshot=true pool/dataset
   #   zfs set com.sun:auto-snapshot:hourly=false pool/dataset
   #   zfs get com.sun:auto-snapshot
   #   zfs get com.sun:auto-snapshot:hourly
   autoSnapshot = {
     enable = true;

     monthly = 12;
     weekly = 4;
     daily = 7;
     hourly = 24;
     frequent = 4;

     #flags = "-k -p";
   };

   autoReplication = {
     enable = false;
   };

   trim = {
     enable = true;
     interval = "weekly";
     #interval = "3weeks";            # Every 3 weeks interval.
     #timer = "";
   };

   autoScrub = {
     enable = true;                  # false is the default.

     # work
     #interval = "Sun, 02:00";            # "Sun, 02:00" is the default. See systemd.time(7) for formatting.
     #interval = "Wed,Sat *-*-* 02:00";
     interval = "Thu,Sun *-*-* 02:00";

     # test
     #interval = "daily";            # "Sun, 02:00" is the default. See systemd.time(7) for formatting.
     #interval = "weekly";            # "Sun, 02:00" is the default. See systemd.time(7) for formatting.

     # not work
     #interval = "4days, 02:00";      # Every 3 days interval, at 02:00.
     #interval = "2days, 02:00";      # Every 3 days interval, at 02:00.
     #interval = "3d 02:00";            # "Sun, 02:00" is the default. See systemd.time(7) for formatting.

     #timer = "";

     #pools = [];                    # If empty, all pools will be scrubbed, empty is default.
   };

  }; # End services.zfs

  # ---------------------------------------------------------------------------------------
  #systemd.services.zfs-prune = {
  #  description = "ZFS Prune Snapshots";
  #  script = ''
  #    ${pkgs.zfs-prune-snapshots}/bin/zfs-prune-snapshots --keep hourly=24,daily=7,weekly=4,monthly=6 MyPool/MyDataset
  #  '';
  #  startAt = "03:00";
  #  serviceConfig = {
  #    Type = "oneshot";
  #  };
  #};

  # ---------------------------------------------------------------------------------------
  # Sanoid is used to create and destroy ZFS snapshots. It is pretty simple to configure.
  # You can adjust retention durations for the snapshots easily, and pick which datasets you want to snapshot.

  services.sanoid = {
    #enable = true; # Default is "false"
    interval = "hourly"; # Run this hourly, run syncoid daily to prune ok

    templates = {
      default = {
        autosnap = true;
        autoprune = true;
        hourly = 8;
        daily = 1;
        monthly = 1;
        yearly = 1;
      };
    };

    datasets = {
      "zroot/persist".useTemplate = [ "default" ];
      "zroot/persistSave".useTemplate = [ "default" ];
    };

  }; # End services.sanoid

  # ---------------------------------------------------------------------------------------
  # Syncoid simply transfers datasets from one location to another.

  services.syncoid = {
    #enable = true; # Default is 'false'
    interval = "daily"; # important that syncoid runs less often than sanoid
  };

}
