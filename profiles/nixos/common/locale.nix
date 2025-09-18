{
  config,
  pkgs,
  lib,
  ...
}:

#let
#
#in
{

  # Ref.:
  #   https://lh.2xlibre.net/locale/en_GB/
  #   https://lh.2xlibre.net/locale/en_GB/glibc/
  #   https://askubuntu.com/questions/21316/how-can-i-customize-a-system-locale#162714
  #
  i18n.defaultLocale = "en_US.UTF-8";
  #i18n.defaultLocale = "en_GB.UTF-8";
  #i18n.defaultLocale = "en_GB.UTF-8/UTF-8";
  i18n.supportedLocales = [
    "all"
    #"en_GB.UTF-8/UTF-8"
    #"en_US.UTF-8/UTF-8"
    #"ms_MY.UTF-8/UTF-8"
    #"ms_MY/ISO-8859-1"
  ];
  i18n.extraLocaleSettings = {
    d_fmt="%F";
    t_fmt="%T";
    d_t_fmt="%F %T %A %Z";
    date_fmt="%F %T %A %Z";

    LC_MESSAGES = "en_GB.UTF-8";
    LC_ADDRESS = "ms_MY.UTF-8";
    LC_IDENTIFICATION = "ms_MY.UTF-8";
    #LC_MEASUREMENT = "ms_MY.UTF-8";
    LC_MONETARY = "ms_MY.UTF-8";
    LC_NAME = "ms_MY.UTF-8";
    #LC_NUMERIC = "ms_MY.UTF-8";
    LC_PAPER = "ms_MY.UTF-8";
    LC_TELEPHONE = "ms_MY.UTF-8";
    LC_TIME = "en_GB.UTF-8";
    #LC_TIME = "ms_MY.UTF-8";
  };

  time.timeZone = "Asia/Kuala_Lumpur";
  time.hardwareClockInLocalTime = true;
  #networking.timeServers = [ "mst.sirim.my" "my.pool.ntp.org" "0.asia.pool.ntp.org" "1.asia.pool.ntp.org" "2.asia.pool.ntp.org" "3.asia.ntp.org" ];
  services.timesyncd = {
    enable = true;
    servers = [ "mst.sirim.my" "my.pool.ntp.org" "0.asia.pool.ntp.org" "1.asia.pool.ntp.org" "2.asia.pool.ntp.org" "3.asia.ntp.org" ];
  };
  #services.ntp = {
  #  enable = true;
  #  servers = [ "mst.sirim.my" "my.pool.ntp.org" "0.asia.pool.ntp.org" "1.asia.pool.ntp.org" "2.asia.pool.ntp.org" "3.asia.ntp.org" ];
  #};

}
