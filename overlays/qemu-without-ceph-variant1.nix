# ./overlays/qemu-without-ceph.nix
{ inputs, ... }:

final: prev: {
  qemu = prev.qemu.override {
    cephSupport = false;
  };
}
