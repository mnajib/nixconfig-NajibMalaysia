{

  services = {
    zfs = {

      autoSnapshot = {
        enable = true;

        weekly = 4;
        monthly = 12;
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
        enable = false;
      };

    };
  };

}
