# flake.nix

#
# NOTE:
#
#   nix flake metadata
# Kira semua versi nixpkgs yang dimuat turun
#   nix flake metadata 2>&1 | grep -E "nixpkgs.*github:NixOS" | sort -u | wc -l
#
# To view what this flake outputs:
#   nix flake show
#

{
  description = "My NixOS Config";

  nixConfig = {
    #extra-substituters = [
    #  "https://nix-community.cachix.org"
    #];
    #extra-trusted-public-keys = [
    #  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #];

    # sudo nixos-rebuild switch --flake .   --option extra-substituters "ssh-ng://192.168.0.21"   --option require-sigs false
  };

  inputs = {

    #------------------------------------------------------
    # nixpkgs
    #------------------------------------------------------
    #nixpkgs-nixos.url       = "github:nixos/nixpkgs/nixos-25.05";
    #nixpkgs-stable.url      = "github:nixos/nixpkgs/nixos-25.05";
    #nixpkgs-release.url     = "github:nixos/nixpkgs/release-25.05";
    nixpkgs-stable.url      = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-release.url     = "github:nixos/nixpkgs/release-25.11";
    nixpkgs-unstable.url   = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs-unstable.url    = "github:NixOS/nixpkgs/nixpkgs-unstable";
    #nixpkgs-master.url      = "github:nixos/nixpkgs/master";

    #nixpkgs.url            = "github:nixos/nixpkgs/nixos-25.05";
    #nixpkgs.url      = "github:nixos/nixpkgs/nixos-25.11";
    #nixpkgs.follows         = "nixpkgs-stable"; # Make 'nixpkgs' point to nixpkgs-stable as default.
    nixpkgs.follows         = "nixpkgs-release"; # Make 'nixpkgs' point to nixpkgs-stable as default.
    #nixpkgs.follows         = "nixpkgs-unstable"; # Make 'nixpkgs' point to nixpkgs-stable as default.
    #nixpkgs.url    = "github:NixOS/nixpkgs/nixpkgs-unstable";
    #nixpkgs.url     = "github:nixos/nixpkgs/release-25.11";
    #------------------------------------------------------


    #------------------------------------------------------
    # home-manager
    #------------------------------------------------------
    home-manager.follows = "home-manager-stable";
    #home-manager.follows = home-manager-version;

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable = {
      #url = "github:nix-community/home-manager/release-25.05";
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #
    #home-manager = {
    #  #url = "github:nix-community/home-manager/release-25.05";
    #  url = "github:nix-community/home-manager/release-25.11";
    #  #url = "github:nix-community/home-manager";
    #  #inputs.nixpkgs.follows = "nixpkgs-unstable";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #  #inputs.nixpkgs.follows = "nixpkgs-stable";
    #  #inputs.nixpkgs.follows = "nixpkgs-release";
    #};

    # Automatically match home-manager release to nixpkgs-stable
    #home-manager = {
    #  url = "github:nix-community/home-manager/${builtins.replaceStrings ["nixos-"] ["release-"] "nixos-25.05"}";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #home-manager-25_05 = {
    #  url = "github:nix-community/home-manager/release-25.05";
    #  inputs.nixpkgs.follows = "nixpkgs-stable";
    #};
    #------------------------------------------------------


    flake-parts.url = "github:hercules-ci/flake-parts";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.nixpkgs.follows = "nixpkgs-stable";
      #inputs.nixpkgs.follows = "nixpkgs-release";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.nixpkgs.follows = "nixpkgs-stable";
      #inputs.nixpkgs.follows = "nixpkgs-release";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hardware.url = "github:NixOS/nixos-hardware/master";

    #nixvim = {
    #  url = "github:nix-community/nixvim";
    #  #inputs.nixpkgs.follows = "nixpkgs-unstable";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #neovim-config-NajibMalaysia.url = "github:mnajib/neovim-config-NajibMalaysia";

    #nur.url = "github:nix-community/NUR";

    impermanence.url = "github:nix-community/impermanence";

    nix-colors.url = "github:misterio77/nix-colors";

    #stylix.url = "github:danth/stylix/release-25.05";
    stylix = {
      #url = "github:danth/stylix";
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.nixpkgs.follows = "nixpkgs-stable";
      #inputs.nixpkgs.follows = "nixpkgs-release";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprland.follows = "hyprland-git";

    hyprland-stable = {
      url = "github:hyprwm/Hyprland/v0.44.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-git = {
      url = "git+https://github.com/hyprwm/hyprland?submodules=1";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.nixpkgs.follows = "nixpkgs-stable";
      #inputs.nixpkgs.follows = "nixpkgs-release";
    };

    hyprwn-contrib = {
      url = "github:hyprwm/contrib";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.nixpkgs.follows = "nixpkgs-stable";
      #inputs.nixpkgs.follows = "nixpkgs-release";
    };

    hyprkeys = {
      url = "github:hyprland-community/hyprkeys";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.nixpkgs.follows = "nixpkgs-stable";
      #inputs.nixpkgs.follows = "nixpkgs-release";
    };

    nh = {
      url = "github:viperML/nh?ref=fe4a96a0b0b0662dba7c186b4a1746c70bbcad03";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.nixpkgs.follows = "nixpkgs-stable";
      #inputs.nixpkgs.follows = "nixpkgs-release";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.nixpkgs.follows = "nixpkgs-stable";
      #inputs.nixpkgs.follows = "nixpkgs-release";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.nixpkgs.follows = "nixpkgs-stable";
      #inputs.nixpkgs.follows = "nixpkgs-release";
    };

    dnsblacklist = {
      url = "github:notracking/hosts-blocklists";
      flake = false;
    };

    #seaweedfs.url = "github:/mitchty/nixos-seaweedfs/wip";

    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.nixpkgs.follows = "nixpkgs-stable";
      #inputs.nixpkgs.follows = "nixpkgs-release";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zfs-snapshot-manager.url = "github:/keithm999/zfs-tools";

    #proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";

  }; # End of 'inputs = { ... };'

  outputs = inputs@{ flake-parts, self, ... }:
  #outputs = top@{ flake-parts, self, ... }:
  #outputs = top@inputs@{ flake-parts, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      #------------------------------------------------------------------------
      # 1. flake-parts.lib.mkFlake.imports
      #------------------------------------------------------------------------
      imports = [
        #inputs.stylix.flakeModule
        #inputs.hyprland.flakeModule
      ];

      #------------------------------------------------------------------------
      # 2. flake-parts.lib.mkFlake.systems
      #------------------------------------------------------------------------
      systems = [ "x86_64-linux" "aarch64-linux" ];

      #------------------------------------------------------------------------
      # 3. flake-parts.lib.mkFlake.perSystem
      #------------------------------------------------------------------------
      perSystem = { config, self, pkgs, system, inputs, outputs, ... }:
        let
          inherit (self) outputs;
          #pkgs = import nixpkgs { inherit system; };
          #pkgsStable = import nixpkgs-stable { inherit system; };
          #pkgsUnstable = import nixpkgs-unstable { inherit system; };
          #pkgsMaster = import nixpkgs-master { inherit system; };
          #inherit (inputs.nixpkgs.lib) mapAttrs attrValues length unique concatStringsSep filterAttrs count;
        in
        {
          #------------------------------------------------
          # 3.1 flake-parts.lib.mkFlake.perSystem.packages
          #       will help generate flake output:
          #         packages.${system}.default
          #         packages.${system}.mangayomi
          #         packages.${system}....
          #------------------------------------------------
          packages = {
            default = pkgs.hello;

            # To use:
            #   nix shell .#mangayomi
            #   nix run .#mangayomi
            mangayomi = pkgs.mangayomi;
          };

          #------------------------------------------------
          # 3.2 flake-parts.lib.mkFlake.perSystem.devShells
          #       will help generate flake output:
          #         devShells.${system}.default
          #         devShells.${system}....
          #------------------------------------------------
          devShells.default = import ./shell.nix { inherit pkgs; };

          #------------------------------------------------
          # 3.3 flake-parts.lib.mkFlake.perSystem.formatter
          #       will help generate flake output:
          #         formatter.${system}...
          #------------------------------------------------
          formatter = pkgs.alejandra;

          #------------------------------------------------
          # 3.4 flake-parts.lib.mkFlake.perSystem.checks
          #       will help generate
          #         ???
          #------------------------------------------------

          #checks.hostIdUniqueness =
          #  let
          #    lib = inputs.nixpkgs.lib;
          #    #hostIds = lib.mapAttrs (_: h: h.config.networking.hostId or null) top.nixosConfigurations;
          #    hostIds = lib.mapAttrs (_: h: h.config.networking.hostId or null) self.nixosConfigurations;
          #    missingHosts = lib.attrNames (lib.filterAttrs (_: v: v == null) hostIds);
          #    dupes = lib.filterAttrs (_: hs: lib.length hs > 1)
          #      (lib.mapAttrs (id: _: lib.attrValues (lib.filterAttrs (_: v: v == id) hostIds)) hostIds);
          #  in
          #  pkgs.runCommand "check-hostId-uniqueness" { } ''
          #    if [ -n "${lib.concatStringsSep " " missingHosts}" ]; then
          #      echo "Missing hostId in: ${lib.concatStringsSep " " missingHosts}"
          #      exit 1
          #    fi
          #    if [ -n "${lib.concatStringsSep " " (lib.attrValues dupes)}" ]; then
          #      echo "Duplicate hostIds: ${lib.concatStringsSep " " (lib.attrValues dupes)}"
          #      exit 1
          #    fi
          #    touch $out
          #  '';

          #------------------------------------------------
          # 3.5 flake-parts.lib.mkFlake.perSystem.apps
          #       will help generate
          #         flake.${system}.apps
          #------------------------------------------------

#         #
#         # Usage:
#         #
#         #   To Dry-run with only drive3
#         #     nix run .#disko-nyxora-dry -- --enableDrive3
#         #
#         #   Dry-run with drive2 and drive3
#         #     nix run .#disko-nyxora-dry -- --enableDrive2 --enableDrive3
#         #
#         #   Dry-run with all (3) drives
#         #     nix run .#disko-nyxora-dry -- --enableDrive1 --enableDrive2 --enableDrive3
#         #   or
#         #     nix run .#disko-nyxora-dry
#         #
#         apps.disko-nyxora-dry = {
#           type = "app";
#           program = toString (pkgs.writeShellScript "disko-nyxora-dry" ''
#             ${pkgs.nixos-install-tools}/bin/disko \
#               --dry-run \
#               --mode disko \
#               --devices "$(${pkgs.nix}/bin/nix eval --raw .#nixosConfigurations.nyxora.config.disko.devices)"
#           '');
#         }; # End apps.disko-nyxora-dry = { ... };

#         apps.disko-nyxora-dry2 = {
#           type = "app";
#           program = toString (pkgs.writeShellScript "disko-nyxora-dry2" ''
#             set -e

#             enableDrive1=false
#             enableDrive2=false
#             enableDrive3=false
#             anyFlag=false

#             # Parse CLI args
#             while [[ $# -gt 0 ]]; do
#               case "$1" in
#                 --enableDrive1) enableDrive1=true; anyFlag=true ;;
#                 --enableDrive2) enableDrive2=true; anyFlag=true ;;
#                 --enableDrive3) enableDrive3=true; anyFlag=true ;;
#                 *) echo "Unknown option: $1" >&2; exit 1 ;;
#               esac
#               shift
#             done

#             # If no flags given, enable all drives
#             if [[ "$anyFlag" == "false" ]]; then
#               enableDrive1=true
#               enableDrive2=true
#               enableDrive3=true
#             fi

#             # Run disko in dry-run mode with selected drives
#             nix run ".#nixosConfigurations.nyxora.config.system.build.diskoScript" -- \
#               --arg devices "(
#                 import ./profiles/nixos/hosts/nyxora/disko/default.nix {
#                   lib = import <nixpkgs/lib>;
#                   enableDrive1 = ''${enableDrive1};
#                   enableDrive2 = ''${enableDrive2};
#                   enableDrive3 = ''${enableDrive3};
#                 }
#               )" \
#               --dry-run
#           '');
#         }; # End apps.disko-nyxora-dry2 = { ... };

#         apps.disko-nyxora-dry3 = {
#           type = "app";
#           program = toString (pkgs.writeShellScript "disko-nyxora-dry3" ''
#             set -euo pipefail

#             enableDrive1=false
#             enableDrive2=false
#             enableDrive3=false
#             anyFlag=false

#             # Parse CLI args
#             while [[ $# -gt 0 ]]; do
#               case "$1" in
#                 --enableDrive1) enableDrive1=true; anyFlag=true ;;
#                 --enableDrive2) enableDrive2=true; anyFlag=true ;;
#                 --enableDrive3) enableDrive3=true; anyFlag=true ;;
#                 *) echo "Unknown option: $1" >&2; exit 1 ;;
#               esac
#               shift
#             done

#             # If no flags given, enable all drives
#             if [[ "$anyFlag" == "false" ]]; then
#               enableDrive1=true
#               enableDrive2=true
#               enableDrive3=true
#             fi

#             # Convert bash bools to Nix bools
#             nixBool() {
#               if [[ "$1" == "true" ]]; then
#                 echo "true"
#               else
#                 echo "false"
#               fi
#             }

#             #diskoTarget=$(
#             #  nix eval --raw .#nixosConfigurations.nyxora.config.system.build \
#             #    | grep -q diskoScript && echo diskoScript || echo disko
#             #)

#             #nix run ".#nixosConfigurations.nyxora.config.system.build.$diskoTarget" -- \
#             nix run ".#nixosConfigurations.nyxora.config.system.build.diskoScript" -- \
#               --arg devices "(
#                   import ./profiles/nixos/hosts/nyxora/disko/default.nix {
#                     lib = import ${pkgs.path + "/lib"};
#                     enableDrive1 = $(nixBool "$enableDrive1");
#                     enableDrive2 = $(nixBool "$enableDrive2");
#                     enableDrive3 = $(nixBool "$enableDrive3");
#                   }
#               )" \
#               --dry-run
#           '');
#         }; # End apps.disko-nyxora-dry3 = { ... };


        }; # End perSystem = {}: let .. in { ... };

      #------------------------------------------------------------------------
      # 4. flake-parts.lib.mkFlake.flake
      #------------------------------------------------------------------------
      # Put your original flake attributes here.
      # Most probably flake-parts not help anything in here, only do "pass-through".
      #
      flake = let

        inherit (self) outputs;

        # Shared helper to create consistent pkgs set and stays DRY (Don't Repeat Yourself)
        mkPkgsCommon = { system, pkgsInput, self, extraConfig ? {} }:
          let
            baseConfig = {
              allowUnfree = true;
              android_sdk.accept_license = true;
              nvidia.acceptLicense = true;
              pulseaudio = true;
              xsane.libusb = true;
            };

            # merge user overrides with default config
            finalConfig = pkgsInput.lib.recursiveUpdate baseConfig extraConfig;
          in
            import pkgsInput {
              inherit system;
              overlays = builtins.attrValues self.overlays;
              config = finalConfig;
            };

        #mkNixos = system: modules:
        #mkNixos = { system, modules, pkgsInput ? inputs.nixpkgs-stable, extraConfig ? {} }:
        #mkNixos = { system, modules, pkgsInput ? inputs.nixpkgs-release, extraConfig ? {} }:
        #mkNixos = { system, modules, pkgsInput ? inputs.nixpkgs-unstable, extraConfig ? {} }:
        mkNixos = { system, modules, pkgsInput ? inputs.nixpkgs, extraConfig ? {} }:
          #inputs.nixpkgs.lib.nixosSystem { # <-- Use inputs.nixpkgs
          pkgsInput.lib.nixosSystem { # <-- Use inputs.nixpkgs
          #inputs.nixpkgs-unstable.lib.nixosSystem { # <-- Use inputs.nixpkgs-unstable
            inherit system modules;
            specialArgs = { inherit inputs outputs; };

            # Apply your overlays and config to the pkgs used by NixOS modules
            #pkgs = import inputs.nixpkgs {
            #pkgs = import pkgsInput {
            #  inherit system;
            #  overlays = builtins.attrValues self.overlays;
            #  config = {
            #    allowUnfree = true;
            #    android_sdk.accept_license = true;
            #    nvidia.acceptLicense = true;
            #    pulseaudio = true;
            #    xsane.libusb = true;
            #  };
            #};
            pkgs = mkPkgsCommon {
              inherit system pkgsInput self; # system, pkgsInput, and self come from the current mkNixos scope via inherit
              extraConfig = extraConfig;     # explicitly rebinds the outer mkNixos.extraConfig to the inner mkPkgsCommon.extraConfig
            };

          };

        #mkHome = { system, modules, pkgsInput ? inputs.nixpkgs-stable }:
        #mkHome = { system, modules, pkgsInput ? inputs.nixpkgs-unstable }: # nixpkgs-unstable as default
        #mkHome = { system, modules, pkgsInput ? inputs.nixpkgs-unstable, extraConfig ? {} }: # nixpkgs-unstable as default
        #mkHome = { system, modules, pkgsInput ? inputs.nixpkgs-stable, extraConfig ? {} }: # nixpkgs-stable as default
        #mkHome = { system, modules, pkgsInput ? inputs.nixpkgs-release, hmInput ? inputs.home-manager-release, extraConfig ? {} }: # nixpkgs-stable as default
        #mkHome = { system, modules, pkgsInput ? inputs.nixpkgs-release, hmInput ? inputs.home-manager, extraConfig ? {} }: # nixpkgs-stable as default
        mkHome = { system, modules, pkgsInput ? inputs.nixpkgs, hmInput ? inputs.home-manager, extraConfig ? {} }: # nixpkgs-stable as default
          #inputs.home-manager.lib.homeManagerConfiguration {
          hmInput.lib.homeManagerConfiguration {
            pkgs = mkPkgsCommon {
              inherit system pkgsInput self;
              extraConfig = extraConfig;
            };
            inherit modules;
            extraSpecialArgs = { inherit inputs outputs; };
          };

      in {
        #--------------------------------------------------
        # flake-parts.lib.mkFlake.flake.overlays
        #   will pass as
        #     flake ouputs: overlays
        #--------------------------------------------------
        #overlays = import ./overlays { inherit inputs outputs; };
        overlays = import ./overlays { inherit inputs; };

        nixosModules = import ./modules/nixos;

        homeManagerModules = import ./modules/home-manager;

        #templates....

        #pkgsRelease = inputs.nixpkgs-release;
        #pkgsStable   = inputs.nixpkgs-stable;
        #pkgsUnstable   = inputs.nixpkgs-unstable;

        #--------------------------------------------------
        # flake-parts.lib.mkFlake.flake.nixosConfigurations
        #   will pass as
        #     flake ouputs: nixConfigurations
        #--------------------------------------------------
        nixosConfigurations = {
          # NOTE:
          # To test / dry-build nixos for host 'khawlah':
          #   nixos-rebuild dry-build --flake .#khawlah
          #
          # To regenerate hardware-configuration.nix and then install remote host:
          #   rm ./profiles/nixos/hosts/khawlah/hardware-configuration.nix
          #   nix run nixpkgs#nixos-anywhere -- --flake .#khawlah  --generate-hardware-config nixos-generate-config ./profiles/nixos/hosts/khawlah/hardware-configuration.nix root@nixos
          # OR
          # To install remote host (without regenerate hardware-configuration.nix):
          #   nix run nixpkgs#nixos-anywhere -- --flake .#khawlah root@nixos
          #

          khawlah = mkNixos {
            system = "x86_64-linux";
            modules = [
              ./profiles/nixos/hosts/khawlah/configuration.nix
              inputs.home-manager.nixosModules.home-manager
              inputs.hardware.nixosModules.lenovo-thinkpad
              inputs.hardware.nixosModules.common-cpu-intel
              inputs.hardware.nixosModules.common-pc-laptop-ssd
              inputs.stylix.nixosModules.stylix
              inputs.disko.nixosModules.disko
            ];
            #pkgsInput = inputs.nixpkgs-release; # override
            #pkgsInput = inputs.nixpkgs-unstable; # override
          };

          #khadijah = mkNixos "x86_64-linux" [
          #  inputs.nix-ld.nixosModules.nix-ld
          #  { programs.nix-ld.dev.enable = true; }
          #  ./profiles/nixos/hosts/khadijah/host-khadijah-Wayland-nauveau.nix
          #  #./profiles/nixos/hosts/khadijah/configuration.nix
          #  inputs.stylix.nixosModules.stylix
          #];

          raudah = mkNixos {
            system = "x86_64-linux";
            modules = [
              ./profiles/nixos/hosts/raudah/configuration.nix
              inputs.home-manager.nixosModules.home-manager
              inputs.hardware.nixosModules.lenovo-thinkpad
              inputs.hardware.nixosModules.common-cpu-intel
              inputs.hardware.nixosModules.common-pc-laptop-ssd
              inputs.stylix.nixosModules.stylix
              #inputs.disko.nixosModules.disko
            ];
            #pkgsInput = inputs.nixpkgs-unstable; # override
          };

          nyxora = let
            # Toggle these to true/false before running nixos-rebuild or nix run
            # Only enabled drive will be process
            #enableDrive1 = false;
            #enableDrive2 = false;
            #enableDrive3 = true;
          in mkNixos {
            system = "x86_64-linux";
            modules = [
              # To test build
              #   nixos-rebuild dry-build --flake .#nyxora
              # To build and apply
              #   nixos-rebuild switch --flake .#nyxora
              ./profiles/nixos/hosts/nyxora/configuration.nix

              # Pass proxmox-nixos to modules
              #{ _module.args.proxmox-nixos = inputs.proxmox-nixos; }
              #
              # NixOS module: Enables and configures Proxmox services (services.proxmox-ve.*)
              #inputs.proxmox-nixos.nixosModules.proxmox-ve
            ];
            #pkgsInput = inputs.nixpkgs-unstable; # override
          };
  #
  #           inputs.disko.nixosModules.disko
  #
  #           (import ./profiles/nixos/hosts/nyxora/disko/default.nix {
  #             #lib = nixpkgs.lib;
  #             lib = inputs.nixpkgs.lib;
  #
  #             # enable (enable = true) to let disko apply the config to the drive.
  #             # disable (enable = false) to let disko ignore/do nothing to the drive.
  #             #
  #             # To dry-run:
  #             #   nix run .#nixosConfigurations.nyxora.config.system.build.disko -- \
  #             #     --arg devices "(import ./profiles/nixos/hosts/nyxora/disko/default.nix { lib = import <nixpkgs/lib>; enableDrive1 = true; enableDrive2 = false; enableDrive3 = true; })" \
  #             #     --dry-run
  #             # or use shortcut as defined in apps.x86_64-linux.disko-nyxora-dry.
  #             enableDrive1 = false;
  #             enableDrive2 = false;
  #             enableDrive3 = true;
  #           })

              # To apply disko
              #   nix run 3#nixosConfigurations.nyxora.config.system.build.disko
              # 'nixos-rebuild' will ignore the partitioning (by 'disko') step by default.
              #{ disko.devices = import ./profile/nixos/hosts/nyxora/disko-GCNL.nix {}; }

              #{
              #  disko.devices = inputs.nixpkgs.lib.mkMerge (
              #    []
              #    ++ inputs.nixpkgs.lib.optional enableDrive1 (import ./profiles/nixos/hosts/nyxora/disko-7G9F.nix { })
              #    ++ inputs.nixpkgs.lib.optional enableDrive2 (import ./profiles/nixos/hosts/nyxora/disko-4S78.nix { })
              #    ++ inputs.nixpkgs.lib.optional enableDrive3 (import ./profiles/nixos/hosts/nyxora/disko-GCNL.nix { })
              #  );
              #}
  #        ];

          customdesktop = mkNixos {
            system = "x86_64-linux";
            modules = [
              ./profiles/nixos/hosts/customdesktop/configuration.nix
              inputs.sops-nix.nixosModules.sops
              inputs.disko.nixosModules.disko
              inputs.zfs-snapshot-manager.nixosModules.default
            ];
            #pkgsInput = inputs.nixpkgs-unstable; # override
          };

          durian = mkNixos {
            system = "x86_64-linux";
            modules = [
              ./profiles/nixos/hosts/durian/configuration.nix
              inputs.sops-nix.nixosModules.sops
              inputs.disko.nixosModules.disko
              inputs.zfs-snapshot-manager.nixosModules.default
            ];
            #pkgsInput = inputs.nixpkgs-unstable; # override
          };

          #asmak = mkNixos "x86_64-linux" [
          #  ./profiles/nixos/hosts/asmak/configuration.nix
          #  inputs.stylix.nixosModules.stylix
          #];
          asmak = mkNixos {
            system = "x86_64-linux";
            modules = [
              ./profiles/nixos/hosts/asmak/configuration.nix
              inputs.home-manager.nixosModules.home-manager
              inputs.hardware.nixosModules.lenovo-thinkpad
              inputs.hardware.nixosModules.common-cpu-intel
              inputs.hardware.nixosModules.common-pc-laptop-ssd
              inputs.stylix.nixosModules.stylix
              inputs.disko.nixosModules.disko
            ];
            #pkgsInput = inputs.nixpkgs-release; # override
            #pkgsInput = inputs.nixpkgs-unstable; # override
          };

          #
          ##nix run nixpkgs#nixos-anywhere -- --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix root@nixos
          # nix run nixpkgs#nixos-anywhere -- --flake .#zahrah  --generate-hardware-config nixos-generate-config ./hardware-configuration.nix root@nixos
          #
          zahrah = mkNixos {
            system = "x86_64-linux";
            modules = [
              ./profiles/nixos/hosts/zahrah/configuration.nix
              inputs.home-manager.nixosModules.home-manager
              inputs.hardware.nixosModules.lenovo-thinkpad
              inputs.hardware.nixosModules.common-cpu-intel
              inputs.hardware.nixosModules.common-pc-laptop-ssd
              inputs.stylix.nixosModules.stylix
              inputs.disko.nixosModules.disko
            ];
            #pkgsInput = inputs.nixpkgs-unstable; # override
            #extraConfig = {
            #  allowBroken = true;
            #  permittedInsecurePackages = [ "openssl-1.1.1w" ];
            #};
          };

          # nix run nixpkgs#nixos-anywhere -- --flake .#maryam  --generate-hardware-config nixos-generate-config ./hardware-configuration.nix root@nixos
          maryam = mkNixos {
            system = "x86_64-linux";
            modules = [
              ./profiles/nixos/hosts/maryam/configuration.nix
              inputs.home-manager.nixosModules.home-manager
              inputs.hardware.nixosModules.lenovo-thinkpad
              inputs.hardware.nixosModules.common-cpu-intel
              inputs.hardware.nixosModules.common-pc-laptop-ssd
              inputs.stylix.nixosModules.stylix
              inputs.disko.nixosModules.disko
            ];
            #pkgsInput = inputs.nixpkgs-release; # override
            #pkgsInput = inputs.nixpkgs-unstable; # override
          };

          manggis = mkNixos {
            system = "x86_64-linux";
            modules = [
              ./profiles/nixos/hosts/manggis/configuration.nix
              inputs.hardware.nixosModules.lenovo-thinkpad-x220
            ];
            #pkgsInput = inputs.nixpkgs-unstable; # override
          };

          #hidayah = mkNixos "x86_64-linux" [
          #  ./profiles/nixos/hosts/hidayah/configuration.nix
          #  inputs.nix-ld.nixosModules.nix-ld
          #  { programs.nix-ld.dev.enable = true; }
          #];

          taufiq = mkNixos {
            system = "x86_64-linux";
            modules = [
              ./profiles/nixos/hosts/taufiq/configuration.nix
              inputs.stylix.nixosModules.stylix
              inputs.hardware.nixosModules.common-cpu-intel
              inputs.hardware.nixosModules.common-pc-laptop-ssd
            ];
            pkgsInput = inputs.nixpkgs-release; # override
            #pkgsInput = inputs.nixpkgs-unstable; # override
            #extraConfig = {
            #  allowBroken = true;
            #  permittedInsecurePackages = [ "openssl-1.1.1w" ];
            #};
          };

          sumayah = mkNixos {
            system = "x86_64-linux";
            modules = [
              #self.nixosModules.grafito
              ./profiles/nixos/hosts/sumayah/configuration.nix
            ];
            #pkgsInput = inputs.nixpkgs-release; # override
            #pkgsInput = inputs.nixpkgs-unstable; # override
          };

          keira = mkNixos {
            system = "x86_64-linux";
            modules = [
              ./profiles/nixos/hosts/keira/configuration.nix
              inputs.hardware.nixosModules.lenovo-thinkpad-t410
            ];
            #pkgsInput = inputs.nixpkgs-unstable; # override
          };

        }; # End of 'nixosConfigurations = { ... };'

        homeConfigurations = {
          # To dry-build a Home Manager configuration for the user 'najib@taufiq':
          #   nix build ".#homeConfigurations.najib@taufiq.activationPackage" --dry-run
          #
          # To quick check
          #   home-manager --dry-run build --flake .#najib@maryam
          #
          #   home-manager build --flake .
          #   nix eval .#homeConfigurations.najib@maryam.config.programs.repo-bootstrap.repos
          #
          # To apply
          #   home-manager switch --flake .
          #
          # The flake-native way to dry-run a Home Manager build is nix build
          # ".#homeConfigurations.<user>@<host>.activationPackage" --dry-run
          # which we've discussed. To actually build and activate, you'd use
          # something like nix run ".#homeConfigurations.<user>@<host>.activationPackage".
          # This is more explicit than home-manager switch because it targets a
          # specific output in your flake

          #-----------------------------------------------------------------------------
          # najib
          #-----------------------------------------------------------------------------
          #"najib@taufiq" = inputs.home-manager.lib.homeManagerConfiguration {
          #  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          #  extraSpecialArgs = { inherit inputs; };
          #  modules = [
          #    ./home-manager/user-najib/host-taufiq
          #  ];
          #};
          #"najib@taufiq" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/najib/taufiq ];
          "najib@taufiq" = mkHome {
            system = "x86_64-linux";
            modules = [
              ./profiles/home-manager/users/najib/taufiq
            ];
            #pkgsInputs = inputs.nixpkgs-release; # override
            #pkgsInputs = inputs.nixpkgs-unstable; # override
          };

          "najib@sumayah" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/najib/sumayah ];
            #pkgsInputs = inputs.nixpkgs-release; # override
            #pkgsInputs = inputs.nixpkgs-unstable; # override
          };

          "najib@maryam" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/najib/maryam ];
          };

          "najib@customdesktop" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/najib/customdesktop ];
          };

          "najib@asmak" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/najib/asmak ];
          };

          "najib@zahrah" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/najib/zahrah ];
          };

          "najib@khawlah" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/najib/khawlah ];
          };

          "najib@keira" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/najib/keira ];
          };

          "najib@nyxora" = mkHome {
            system = "x86_64-linux";
            modules = [
              ./profiles/home-manager/users/najib/nyxora
            ];
            #pkgsInputs = inputs.nixpkgs-release; # override
            #pkgsInputs = inputs.nixpkgs-unstable; # override
          };

          #-----------------------------------------------------------------------------
          # root
          #-----------------------------------------------------------------------------
          "root@taufiq" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/root/taufiq ];
            pkgsInputs = inputs.nixpkgs-release; # override
          };

          #-----------------------------------------------------------------------------
          # julia
          #-----------------------------------------------------------------------------
          "julia@manggis" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/julia/manggis ];
          };

          "julia@keira" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/julia/keira ];
          };

          #-----------------------------------------------------------------------------
          # nurnasuha
          #-----------------------------------------------------------------------------
          "nurnasuha@manggis" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/nurnasuha/manggis ];
          };

          "nurnasuha@asmak" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/nurnasuha/asmak ];
          };

          #-----------------------------------------------------------------------------
          # naqib
          #-----------------------------------------------------------------------------
          "naqib@sumayah" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/naqib/sumayah ];
          };

          "naqib@asmak" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/naqib/asmak ];
          };

          "naqib@zahrah" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/naqib/zahrah ];
          };

          "naqib@raudah" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/naqib/raudah ];
          };

          "naqib@taufiq" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/naqib/taufiq ];
            #pkgsInputs = inputs.nixpkgs-release; # override
            #pkgsInputs = inputs.nixpkgs-unstable; # override
            #pkgsInputs = inputs.nixpkgs-stable; # override
          };

          #-----------------------------------------------------------------------------
          # naim
          #-----------------------------------------------------------------------------
          "naim@manggis" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/naim/manggis ];
          };

          "naim@keira" = mkHome {
            system = "x86_64-linux";
            modules = [ ./profiles/home-manager/users/naim/keira ];
          };

        }; # End of 'homeConfigurations = { ... };'

        #
        # Ensure all hostIds are unique across nixosConfigurations
        #
        # To run the check:
        #   nix flake check
        #
        # It will:
        #   Fail with a clear error if any two hosts share the same hostId.
        #   or, Pass if all hostIds are unique.
        #
        #checks.x86_64-linux = {
        #  hostIdUniqueness = let
        #    lib = inputs.nixpkgs.lib;
        #    inherit (lib) mapAttrs attrValues length unique concatStringsSep filterAttrs;
        #
        #    hostIds =
        #      mapAttrs (_: cfg: cfg.config.networking.hostId or null)
        #        self.nixosConfigurations;
        #
        #    # Hosts missing hostId
        #    missingHosts = lib.attrNames (filterAttrs (_: v: v == null) hostIds);
        #
        #    # Collect non-null hostIds
        #    nonNullHostIds = filterAttrs (_: v: v != null) hostIds;
        #
        #    # Detect duplicates
        #    ids = attrValues nonNullHostIds;
        #    dupIds = lib.filter (id: lib.count (x: x == id) ids > 1) (unique ids);
        #    dupHosts = map (id: {
        #      id = id;
        #      hosts = lib.attrNames (filterAttrs (_: v: v == id) nonNullHostIds);
        #    }) dupIds;
        #
        #    prettyDup = concatStringsSep "; " (map (d: "${d.id} → ${concatStringsSep "," d.hosts}") dupHosts);
        #  in
        #    assert (missingHosts == [])
        #      "❌ Some hosts are missing networking.hostId: ${concatStringsSep ", " missingHosts}";
        #    assert (dupIds == [])
        #      "❌ Duplicate hostIds detected: ${prettyDup}";
        #    "✅ All hostIds are present and unique";
        #}; # End check = { ... };

      }; # End of 'flake = let ... in { ... };'
    }; # End of 'flake-parts.lib.mkFlake { inherit inputs; } { ... };
}
