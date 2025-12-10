{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Android tools
    android-tools adbfs-rootless android-file-transfer adb-sync

    # Boot/image tools
    abootimg imgpatchtools apktool cargo-apk
    android-backup-extractor
  ];
}

