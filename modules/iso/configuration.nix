{ config, pkgs, ... }:
let
  #pubKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCl1r2eksJXO02QkuGbjVly38MhG9MpDfvQRPABWJLGfFIBQFNkCvvJffV1UEUpcRNNaAmle1DFS1CtvATZSr/UpTgzsAYu9X+gd0/5OB/WlWHJaC/j0H2LahtiUPKZ2d4/cLkKPQqP6HZdmOXrsHZR1I9bxjhqyNWhwxNLMCK/8995hKNWOYamMagJloHUTRLFQaor/WoFDqjfW8EKo09OxKnXtFFcj6CmXwsu1RWfFY/P/wsADL+8B2/P4CmqqwuLxQknbA0WZ2zWSj13tf24H7BORAkMAeK5249GuLd5SlnnvmHJLiF1OCIkSOZJMcyrNCCvBRavGLcPoKQbtHw7";
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    kernelParams = [
      "boot.shell_on_fail"
      "iomem=relaxed"
      "intel-spi.writeable=1"
    ];
    supportedFilesystems = [
      "zfs"
      "xfs"
      "btrfs"
      "ext4" "ext3" "ext2"
    ];
    loader = {
      grub = {
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
      };
    };
    kernel.sysctl = {
      # We want sysrq functions to work if there is an issue
      "kernel.sysrq" = 1;
      # Be kind(er) to low memory systems
      "vm.overcommit_memory" = "1";
    };
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call chipsec zfs ];
  };

  networking.firewall.enable = false;

  environment = {
    variables = {
      # Since we have no swap, have the heap be a bit less extreme
      GC_INITIAL_HEAP_SIZE = "1M";
    };
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

  #users.users.root.openssh.authorizedKeys.keys = [ pubKey ];

  users.mutableUsers = false;

  nix = {
    #package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system.stateVersion = "22.05";

  # Generated stuff goes here...
}
