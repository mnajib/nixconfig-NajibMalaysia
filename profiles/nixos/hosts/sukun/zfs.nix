
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

  boot.initrd.kernelModules = [ "zfs" ];
  boot.initrd.supportedFilesystems = [ "zfs" ];

  boot.supportedFilesystems = [ "zfs" ];

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
     interval = "03:00";
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


}
