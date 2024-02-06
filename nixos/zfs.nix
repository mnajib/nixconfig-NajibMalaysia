{

  services = {
    zfs = {

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
      };

      autoScrub = {
        enable = true;                # false is the default
        #pools = [];                  # If empty, all pools will be scrubbed, empty is default
        #interval = "daily"           # "Sun, 02:00" is the default. See systemd.time(7) for formatting
      };

    };
  };

}
