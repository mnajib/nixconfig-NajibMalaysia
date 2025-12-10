
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

  environment.systemPackages = with pkgs; [
    snapper
    snapper-gui
    #timeshift-minimal
    timeshift
  ];

  #
  # NOTE: To list all systemd timer:
  #   systemctl list-timers
  #
  services.btrfs.autoScrub = {
    enable = lib.mkDefault true;
    #interval = "daily"; #"weekly"; # Default: "weekly"
    #interval = "*-*-* 03:00:00"; # Daily, start at 03:00:00
    interval = lib.mkDefault "02:00";
    #fileSystems = [ "/" "/mnt/data" ]; # Specific Btrfs mounts (default: all)
    #startAt = "Mon 02:00"; # Start Monday at 2:00 AM
  };

}
