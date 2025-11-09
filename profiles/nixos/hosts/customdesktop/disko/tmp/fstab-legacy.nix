# ./profiles/nixos/hosts/customdesktop/disko/fstab-legacy.nix

{ config, lib, ... }:

let
  pool = "Riyadh2";
  datasets = [ "root" "nix" "home" "rootuser" "persist" ];
  mountBase = "/";
in {
  fileSystems = lib.listToAttrs (map (name:
    let
      mountPath = if name == "root" then mountBase else "${mountBase}${name}";
    in {
      name = mountPath;
      value = {
        device = "zfs://${pool}/${name}";
        fsType = "zfs";
        options = [ "defaults" ];
      };
    }
  ) datasets);
}

