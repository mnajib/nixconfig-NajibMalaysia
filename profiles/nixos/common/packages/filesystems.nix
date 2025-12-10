{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Partitioning & FS tools
    gptfdisk efibootmgr btrfs-progs btrbk exfat fatresize

    # Disk usage analyzers
    ncdu dua dust duf gdu godu duc
    baobab k4dirstat qdirstat jdiskreport gnome-disk-utility

    # Duplicate file finders
    jdupes fdupes fclones fclones-gui

    # Encryption & cloning
    cryptsetup partclone hdparm lsscsi

    # Misc disk tools
    diskus dfc btdu
  ];
}

