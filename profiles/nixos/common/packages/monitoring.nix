{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Process/system monitors
    htop glances nload zenith bmon btop
    atop gotop wavemon iotop nethogs
    sysstat # performance monitoring tools (sar, iostat, pidstat)

    # Disk/SMART monitoring
    gsmartcontrol smartmontools lm_sensors

    # Network monitoring
    iperf bandwhich

    # Misc diagnostics
    xmlstarlet inxi dmidecode lshw hwinfo neofetch cpufetch

    # Journal/logs
    gnome-logs
  ];
}

