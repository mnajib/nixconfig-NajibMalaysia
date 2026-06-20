# Alternative ./overlays/qemu-without-ceph-variant2.nix
{ inputs, final, prev }:

prev.qemu.override {
  cephSupport = false;
}
