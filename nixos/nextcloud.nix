{
    services.nextcloud = {
        enable = false; #true;
        hostName = "tv.desktop.local";
        nginx.enable = true;
        config = {
            dbtype = "pgsql";
            dbuser = "nextcloud";
            dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
            dbname = "nextcloud";
            adminpassFile = "/root/nextcloud-adminpassFile";
            adminuser = "root";
            };
        #autoUpdateApps = true;
        };

    services.postgresql = {
        enable = false; #true;
        ensureDatabases = [ "nextcloud" ];
        ensureUsers = [{
        name = "nextcloud";
            ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
            }];
        };

    # ensure that postgres is running *before* running the setup
    systemd.services."nextcloud-setup" = {
        requires = ["postgresql.service"];
        after = ["postgresql.service"];
        };
}
