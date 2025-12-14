# overlays/proxmox-nixos.nix
# ==========================
# Overlay untuk expose Proxmox-NixOS packages ke nixpkgs

{
  inputs,
  ...
}:

final: prev: {

  # Method 1: Expose default package
  # ---------------------------------
  #proxmox-nixos = inputs.proxmox-nixos.packages.${final.system}.default;

  # Method 2: Expose multiple packages (jika ada)
  # ----------------------------------------------
  # proxmox-qemu-server = inputs.proxmox-nixos.packages.${final.system}.qemu-server;
  # proxmox-backup-client = inputs.proxmox-nixos.packages.${final.system}.backup-client;

  # Method 3: Expose semua packages dalam namespace
  # ------------------------------------------------
  # Ini lebih bersih jika banyak packages
  proxmoxPackages = inputs.proxmox-nixos.packages.${final.system};

  # Method 4: Override existing nixpkgs package
  # --------------------------------------------
  # Jika nixpkgs sudah ada proxmox packages, tapi anda nak versi dari input
  # qemu = inputs.proxmox-nixos.packages.${final.system}.qemu-proxmox;
}
