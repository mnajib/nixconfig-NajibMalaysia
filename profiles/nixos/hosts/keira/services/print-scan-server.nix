# profile/nixos/hosts/keira/services/print-scan-server.nix

{ config, pkgs, ... }:

let

  commonDir = "../../../common";

  # Single source of truth: every name the CUPS web UI should answer to.
  cupsServerAliases = [ "printer2.localdomain" ];

in
{

  imports = let
    fromCommon = name: ./. + "/${toString commonDir}/${name}";
  in [
    (fromCommon "hardware-printer.nix")
  ];

  services.printing.listenAddresses = [
    "*:443"                             # Listen on all interfaces, not only localhost
  ];

  services.printing.extraConf = ''
    # Require TLS for authenticated requests (admin login).
    DefaultEncryption Required

    # Accept our hostname(s) in the browser Host: header
    ServerAlias ${builtins.concatStringsSep " " cupsServerAliases}
  '';

  networking.firewall.allowedTCPPorts = [
    443   # CUPS over standard HTTPS port
  ];

}
