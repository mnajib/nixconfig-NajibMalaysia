{ pkgs, config, lib, ... }:

let
  pmaVersion = "5.2.3";

  # 1. Fetch & verify phpMyAdmin archive directly from source
  phpMyAdminSource = pkgs.fetchzip {
    url = "https://files.phpmyadmin.net/phpMyAdmin/${pmaVersion}/phpMyAdmin-${pmaVersion}-all-languages.zip";
    hash = "sha256-qmyjvZdcH7iw3A7L0+811d491vgoMDXyPsCgiRE1VQA=";
    stripRoot = true;
  };

  # 2. Inject config.inc.php into the fetched source tree
  phpMyAdminConfigured = pkgs.runCommand "phpmyadmin-configured" {} ''
    cp -r ${phpMyAdminSource} $out
    chmod -R +w $out
    cat << 'EOF' > $out/config.inc.php
<?php
/* Server 1: System MariaDB */
$i = 1;
$cfg['Servers'][$i]['verbose'] = 'System MariaDB (Port 3306)';
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['host'] = '127.0.0.1';
$cfg['Servers'][$i]['port'] = 3306;
$cfg['Servers'][$i]['AllowNoPassword'] = true;

/* Server 2: Devenv MariaDB */
$i++;
$cfg['Servers'][$i]['verbose'] = 'Devenv MariaDB (Port 33067)';
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['host'] = '127.0.0.1';
$cfg['Servers'][$i]['port'] = 33067;
$cfg['Servers'][$i]['AllowNoPassword'] = true;
EOF
  '';

  # 3. Custom PHP environment with required database extensions
  customPhp = pkgs.php84.buildEnv {
    extensions = { enabled, all }: enabled ++ (with all; [
      mysqli
      pdo_mysql
      mbstring
      zip
      gd
    ]);
  };
in
{
  # 4. Configure PHP-FPM pool using custom PHP build
  services.phpfpm.pools.phpmyadmin = {
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

  # 5. Systemd ordering and dependency rules
  systemd.services.phpfpm-phpmyadmin = {
    after = [ "mysql.service" ];
    wants = [ "mysql.service" ];
  };

  # 6. Configure Nginx virtual host with localdomain TLD
  services.nginx = {
    enable = true;
    virtualHosts."phpmyadmin.localdomain" = {
      root = phpMyAdminConfigured;
      extraConfig = ''
        index index.php;
      '';

      locations."~ \\.php$" = {
        extraConfig = ''
          fastcgi_pass unix:${config.services.phpfpm.pools.phpmyadmin.socket};
          fastcgi_index index.php;
          include ${pkgs.nginx}/conf/fastcgi_params;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        '';
      };
    };
  };

  # 7. Set up local DNS resolution for localdomain
  networking.hosts."127.0.0.1" = [ "phpmyadmin.localdomain" ];
}
