# profiles/nixos/hosts/nyxora/services/adminer.nix

{ config, pkgs, lib, ... }:

let
  # 1. Create web root pointing to nixpkgs Adminer package
  adminerWebRoot = pkgs.runCommand "adminer-webroot" {} ''
    mkdir -p $out
    if [ -f "${pkgs.adminer}/share/adminer/index.php" ]; then
      cp ${pkgs.adminer}/share/adminer/index.php $out/index.php
    elif [ -f "${pkgs.adminer}/share/adminer/adminer.php" ]; then
      cp ${pkgs.adminer}/share/adminer/adminer.php $out/index.php
    else
      cp ${pkgs.adminer}/share/adminer/*.php $out/index.php
    fi
  '';

  # 2. Custom PHP environment with database drivers for PostgreSQL & MariaDB/MySQL
  customPhp = pkgs.php84.buildEnv {
    extensions = { enabled, all }: enabled ++ (with all; [
      pdo
      pdo_pgsql
      pdo_mysql
      mysqli
      session
      mbstring
    ]);
  };
in
{
  # 3. Configure PHP-FPM pool for Adminer
  services.phpfpm.pools.adminer = {
    user = "nginx";
    group = "nginx";
    phpPackage = customPhp;
    settings = {
      "listen.owner" = "nginx";
      "listen.group" = "nginx";
      "pm" = "dynamic";
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
    };
  };

  # 4. Systemd ordering and service dependencies
  systemd.services.phpfpm-adminer = {
    after = [ "postgresql.service" "mysql.service" ];
    wants = [ "postgresql.service" "mysql.service" ];
  };

  # 5. Configure Nginx virtual host with localdomain TLD
  services.nginx = {
    enable = true;
    virtualHosts."adminer.localdomain" = {
      root = adminerWebRoot;
      extraConfig = ''
        index index.php;
      '';

      locations."~ \\.php$" = {
        extraConfig = ''
          fastcgi_pass unix:${config.services.phpfpm.pools.adminer.socket};
          fastcgi_index index.php;
          include ${pkgs.nginx}/conf/fastcgi_params;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        '';
      };
    };
  };

  # 6. Set up local DNS resolution for localdomain
  networking.hosts."127.0.0.1" = [ "adminer.localdomain" ];
}
