{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #qemu_full
    qemu
    qemu_kvm
    qemu-utils

    virt-viewer libvirt virt-manager bridge-utils vde2
    # virtualbox (optional)
  ];
}

