{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    qemu qemu_kvm qemu-utils qemu_full
    virt-viewer libvirt virt-manager bridge-utils vde2
    # virtualbox (optional)
  ];
}

