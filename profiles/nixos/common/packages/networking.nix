{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Networking basics
    socat redis mtr iproute2 sshfs

    # Sync/backup
    rsync grsync zsync luckybackup rclone

    # Torrent clients
    transmission_4-gtk rtorrent qbittorrent deluge-gtk

    # Streaming
    popcorntime

    # File transfer
    filezilla

    # DNS tools
    drill bind
  ];
}

