
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
  #boot.kernelPackages = pkgs.linuxPackages_6_18;
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  #config = mkIf cfg.zfs.enable {
  #  environment.systemPackages = [ pkgs.zfs-prune-snapshots];
  #};

  boot.initrd.availableKernelModules = [
    "zfs"
  ];

  boot.initrd.kernelModules = {
    zfs = true;
  };

  #boot.initrd.supportedFileSystems = {
  #  zfs = true;
  #};

  boot.supportedFilesystems = {
    zfs = true;
  };

  boot.kernelParams = [
    "nohibernate"
    #"zfs.zfs_arc_max=17179869184"
  ];

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
   # To list all systemd time:
   #   systemctl list-timers
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

   #
   # To list all in systemd timer:
   #   systemctl list-timers
   #
   autoScrub = {
     enable = true;                  # false is the default.
     #pools = [];                    # If empty, all pools will be scrubbed, empty is default.
     #interval = "daily";            # "Sun, 02:00" is the default. See systemd.time(7) for formatting.
     #interval = "03:00";
     interval = "2days, 02:00";      # Every 3 days interval, at 02:00.
     #interval = "4days, 02:00";      # Every 3 days interval, at 02:00.
     #interval = "weekly";            # "Sun, 02:00" is the default. See systemd.time(7) for formatting.
     #interval = "Sun, 02:00";            # "Sun, 02:00" is the default. See systemd.time(7) for formatting.
     #timer = "";
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

  #services.sanoid = {
  #  #enable = true; # Default is "false"
  #
  #  templates = {
  #    default = {
  #      autosnap = true;
  #      autoprune = true;
  #      hourly = 8;
  #      daily = 1;
  #      monthly = 1;
  #      yearly = 1;
  #    };
  #  };
  #
  #  datasets = {
  #    "zroot/persist".useTemplate = [ "default" ];
  #    "zroot/persistSave".useTemplate = [ "default" ];
  #  } // lib.optionalAttrs (config.yomaq.disks.zfs.storage.enable && !config.yomaq.disks.amReinstalling) {
  #  # This is for the additional zstorage pool I configure in my flake
  #  # we'll come back to the "amReinstalling" option later on
  #    "zstorage/storage".useTemplate = [ "default" ];
  #    "zstorage/persistSave".useTemplate = [ "default" ];
  #  };
  #
  #}; # End services.sanoid

  # ---------------------------------------------------------------------------------------
  # Syncoid simply transfers datasets from one location to another.

  #services.syncoid = {
  #  #enable = true; # Default is 'false'
  #};

}
