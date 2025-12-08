#
# NOTE:
#
# Best recommendded one-liner method to force your own builder list
# The format is:
#   [protocol://][user@]hostname[:port]  systems  [max-jobs] [speed-factor] [supported-features,…] [mandatory-features,…]
# Example:
#   sudo nixos-rebuild switch \
#     --builders 'ssh-ng://nix@fastarm aarch64-linux,x86_64-linux - 64 10 kvm,benchmark' \
#     --builders 'ssh-ng://nix@m2mac aarch64-darwin,x86_64-darwin - 12 5 big-parallel'
# or to completely disable remote building for one rebuild:
#   sudo nixos-rebuild switch --flake . --builders '' --max-jobs auto --verbose --show-trace
#   sudo nixos-rebuild switch --flake . --builders '' --max-jobs 1 --verbose --show-trace
#
# or override the NixOS option with --override-flags
#   sudo nixos-rebuild switch \
#     --override-flags nix.buildMachines '[
#       { hostName = "myfastbuilder";
#         sshUser = "nix";
#         sshKey = "/root/.ssh/id_ed25519";
#         systems = [ "x86_64-linux" "aarch64-linux" ];
#         maxJobs = 32;
#         speedFactor = 10;
#         supportedFeatures = [ "kvm" "big-parallel" ];
#       }
#     ]'
# or disable all remote builders with --override-flags with empty list
#   sudo nixos-rebuild switch --override-flags nix.buildMachines '[]'
#
# or
#   sudo nixos-rebuild switch --flake . --verbose --show-trace --build-host najib@nyxora --use-remote-root
#

{
  pkgs, config,
  lib,
  inputs, outputs, # need for home-manager
  ...
}:
{

  nix = {
    distributedBuilds = true;
    #package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8

    #extraOptions = ''
    #    builders-use-substitutes = true
    #'';

    settings = {
      trusted-users = [
        "root" "najib"
      ];
      #max-jobs = 2;
      max-jobs = 0;
      #max-jobs = "auto";
      fallback = true;
      builders-use-substitutes = true;
    };

    buildMachines = [
      {
        hostName = "nyxora";  # e.g., builder
        #system = "x86_64-linux";  # Match your arch; use ["x86_64-linux" "aarch64-linux"] for multi-arch
        systems = [
          "x86_64-linux"
          "i686-linux"
        ];
        protocol = "ssh-ng";  # Modern SSH protocol (fallback to "ssh" if needed)
        sshUser = "najib";
        maxJobs = 14; #4;  # Parallel jobs on remote (match its CPU cores)
        speedFactor = 1; #2;  # Prioritize this builder (higher = faster perceived)
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];  # Adjust based on remote capabilities (see table below)
        mandatoryFeatures = [];  # Enforce none unless required
        #notes.memoryPerJob  "=3 GB";
        #notes.totalRAM = "64 GB";
      }
      {
        hostName = "sumayah";  # e.g., builder
        #system = "x86_64-linux";  # Match your arch; use ["x86_64-linux" "aarch64-linux"] for multi-arch
        systems = [
          "x86_64-linux"
          "i686-linux"
        ];
        protocol = "ssh-ng";  # Modern SSH protocol (fallback to "ssh" if needed)
        sshUser = "najib";
        maxJobs = 6; #4;  # Parallel jobs on remote (match its CPU cores)
        speedFactor = 2;  # Prioritize this builder (higher = faster perceived)
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];  # Adjust based on remote capabilities (see table below)
        mandatoryFeatures = [];  # Enforce none unless required
        #notes.memoryPerJob = "=2 GB";
        #notes.totalRAM = "16 GB";
      }
    ];

    #max-jobs = 0; # Disable (never build on local machine, even when connecting to remote builders fails) building on local machine; only build on remote builders.
  };

  #imports = let
  #  fromCommon = name: ./. + "/${toString commonDir}/${name}";
  #in [
  #  ./hardware-configuration.nix
  #];

  #networking.firewall = {
  #  allowedTCPPorts = [
  #    # 22  # ssh
  #  ];
  #  allowedUDPPorts = [
  #    # 1110                              # NFS client
  #    # 4045                              # NFS lock manager
  #    #{ from = 4000; to = 4007; }
  #    #{ from = 8000; to = 8010; }
  #  ];
  #};

  #environment.systemPackages = with pkgs; [
  #  tmux
  #  file
  #  gnumake
  #  gcc
  #];

  services.openssh = {
    enable = true;
    #settings = {
    #  PermitRootLogin = "yes";
    #};
  };

}
