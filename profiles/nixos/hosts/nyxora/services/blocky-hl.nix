# ./profile/nixos/hosts/nyxora/services/blocky-hl.nix
#
# Installs the `blocky-hl` command. The script itself lives in blocky-hl.sh
# (single source of truth); this file only wraps it with its dependencies.

{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "blocky-hl";
      runtimeInputs = with pkgs; [
        systemd      # journalctl
        gnugrep      # grep
        gnused       # sed
        gawk         # awk
        coreutils    # cat, cut, sort, uniq
      ];
      text = builtins.readFile ./blocky-hl.sh;
    })
  ];
}
