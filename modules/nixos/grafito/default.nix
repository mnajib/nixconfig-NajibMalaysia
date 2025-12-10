{ config, lib, pkgs, ... }:

let
  cfg = config.services.grafito;
in {
  options.services.grafito = {
    enable = lib.mkEnableOption "Grafito journald log viewer";

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Bind address for Grafito (0.0.0.0 for all interfaces).";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port to listen on.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for Grafito.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "grafito";
      description = "System user that runs the Grafito service.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "grafito";
      description = "Primary group for the Grafito service.";
    };

    uid = lib.mkOption {
      type = lib.types.int;
      default = 961;
      description = "User ID for Grafito service account.";
    };

    gid = lib.mkOption {
      type = lib.types.int;
      default = 961;
      description = "Group ID for Grafito service account.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.grafito ];

    users.groups.${cfg.group} = {
      gid = cfg.gid;
    };

    users.users.${cfg.user} = {
      isSystemUser = true;
      uid = cfg.uid;
      group = cfg.group;
      extraGroups = [ "systemd-journal" ];
      home = "/var/lib/${cfg.user}";
    };

    systemd.services.grafito = {
      description = "Grafito journald log viewer";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.grafito}/bin/grafito --bind ${cfg.host} --port ${toString cfg.port}";
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
      };
    };

    networking.firewall.allowedTCPPorts =
      lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}

