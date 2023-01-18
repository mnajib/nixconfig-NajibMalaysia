{
        seaweedfs.nixosModules.seaweedfs


            # services.seaweedfs = {
            #   master = {
            #     enable = true;
            #     openIface = "enp1s0";
            #     settings = {
            #       sequencer = {
            #         type = "snowflake";
            #         sequencer_snowflake_id = 1;
            #       };
            #       # maintenance = {
            #       #   sleep_minutes = 47;
            #       #   scripts = ''
            #       #     lock
            #       #     ec.encode -fullPercent=95 -quietFor=1h
            #       #     ec.rebuild -force
            #       #     ec.balance -force
            #       #     volume.balance -force
            #       #     unlock
            #       #   '';
            #       # };
            #     };
            #     defaultReplication = "001";
            #     mdir = "/data/ssd/weed/mdir";
            #     peers = weedMasters;
            #     volumeSizeLimitMB = 1024;
            #     volumePreallocate = true;
            #   };
            #   volume = {
            #     enable = true;
            #     stores.disk0 = {
            #       dir = "/data/disk0/weed";
            #       server = weedMasters;
            #       maxVolumes = 18432;
            #     };
            #   };
            #   filer.enable = true;
            #   iam.enable = true;
            #   # s3.enable = true;
            #   webdav.enable = true;
            #   staticUser.enable = true;
            # };

}
