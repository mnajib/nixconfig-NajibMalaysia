
#
# References:
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
    #"nohibernate"
  ];

  boot.initrd.kernelModules = [ "btrfs" ];
  boot.initrd.supportedFilesystems = [ "btrfs" ];

  boot.supportedFilesystems = [ "btrfs" ];

  environment.systemPackages = with pkgs; [
    #zfs-prune-snapshots
    #sanoid
  ];

  # ---------------------------------------------------------------------------------------
  # btrfs
  # ---------------------------------------------------------------------------------------
  services.btrfs.autoScrub.enable = true;

  # ---------------------------------------------------------------------------------------
  # systemd btrfs
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
