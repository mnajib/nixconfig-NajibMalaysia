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
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    # sudo nixos-rebuild switch --flake .   --option extra-substituters "ssh-ng://192.168.0.21"   --option require-sigs false
  };

  inputs = {


    #------------------------------------------------------
    # nixpkgs
    #------------------------------------------------------

    #nixpkgs.url            = "github:nixos/nixpkgs/nixos-25.05";
    #nixpkgs.url      = "github:nixos/nixpkgs/nixos-25.11";
    #nixpkgs.follows         = "nixpkgs-stable"; # Make 'nixpkgs' point to nixpkgs-stable as default.
    nixpkgs.follows = "nixpkgs-release"; # Make 'nixpkgs' point to nixpkgs-stable as default.
    #nixpkgs.follows         = "nixpkgs-unstable"; # Make 'nixpkgs' point to nixpkgs-stable as default.
    #nixpkgs.url    = "github:NixOS/nixpkgs/nixpkgs-unstable";
    #nixpkgs.url     = "github:nixos/nixpkgs/release-25.11";

    #nixpkgs-nixos.url       = "github:nixos/nixpkgs/nixos-25.05";
    #nixpkgs-stable.url      = "github:nixos/nixpkgs/nixos-25.05";
    #nixpkgs-release.url     = "github:nixos/nixpkgs/release-25.05";
    #nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    #nixpkgs-release.url = "github:nixos/nixpkgs/release-25.11";
    nixpkgs-release.url = "github:nixos/nixpkgs/release-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs-unstable.url    = "github:NixOS/nixpkgs/nixpkgs-unstable";
    #nixpkgs-master.url      = "github:nixos/nixpkgs/master";
    nixpkgs-release-26_05.url = "github:nixos/nixpkgs/release-26.05";

    #nixpkgs-nonetprob.url = "github:NixOS/nixpkgs/040d0d17f15957e4a08f14abfa3032cd96cc82fe";
    #nixpkgs.follows = "nixpkgs-nonetprob"; # Make 'nixpkgs' point to nixpkgs-stable as default.


    #------------------------------------------------------
    # home-manager
    #------------------------------------------------------

    home-manager.follows = "home-manager-stable";
    #home-manager.follows = home-manager-version;

    home-manager-stable = {
      #url = "github:nix-community/home-manager/release-25.05";
      #url = "github:nix-community/home-manager/release-25.11";
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      #inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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

    /*nh = {
      url = "github:viperML/nh?ref=fe4a96a0b0b0662dba7c186b4a1746c70bbcad03";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.nixpkgs.follows = "nixpkgs-stable";
      #inputs.nixpkgs.follows = "nixpkgs-release";
    };*/

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

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    #
    # Troubleshooting:
    #   # Clear out the packages inside your old user-level nix-env profile
    #   nix-env --profile ~/.nix-profile -e '*'
    #
    #   # Remove the legacy symlinks if they remain
    #   rm -f ~/.nix-profile ~/.home-manager-profile
    #
    #
    # cd ~/src/nixconfig-NajibMalaysia
    # nix flake update my-nvim
    # nixos-rebuild switch --flake .
    # nh os switch .
    #
    # To test build:
    #   nh os build . -H sakinah --target-host najib@sakinah -- --show-trace --override-input my-nvim path:/home/najib/src/nvim-config-test
    #
    # Connect to your declarative standalone editor flake repository
    #my-nvim.url = "git+http://git.localdomain/najib/nvim-config-test";
    # Fallback option layout mirror if needed:
    my-nvim.url = "github:mnajib/nvim-config-test";
    #my-nvim.url = "https://github.com/mnajib/nvim-config-test.git";
    #my-nvim.inputs.nixpkgs.follows = "nixpkgs";

    #
    # 1. Switch to your infrastructure directory and stage the updates
    #      cd ~/src/minecraft-infra
    #      git add .
    #
    # 2. Return to your main system configuration directory
    #      cd ~/src/nixconfig-NajibMalaysia
    #      git add .
    #
    # 3. To test your system with the local path override flags
    #      nh os test . -- --override-input mc-project path:/home/naqib/src/minecraft-infra
    #
    #mc-project.url = "git+file:///home/naqib/src/minecraft-infra";
    #mc-project.url = "path:/home/naqib/src/minecraft-infra";
    #mc-project.url = "git+http://git.localdomain/naqib/minecraft-infra";
    mc-project.url = "github:NaqibNajib/minecraft-infra";

  }; # End of 'inputs = { ... };'

  outputs =
    inputs@{ flake-parts, self, ... }:
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
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      #------------------------------------------------------------------------
      # 3. flake-parts.lib.mkFlake.perSystem
      #------------------------------------------------------------------------
      perSystem =
        {
          config,
          self,
          pkgs,
          system,
          #inputs,
          #outputs,
          ...
        }:
        #let
        #  inherit (self) outputs;
        #  #pkgs = import nixpkgs { inherit system; };
        #  #pkgsStable = import nixpkgs-stable { inherit system; };
        #  #pkgsUnstable = import nixpkgs-unstable { inherit system; };
        #  #pkgsMaster = import nixpkgs-master { inherit system; };
        #  #inherit (inputs.nixpkgs.lib) mapAttrs attrValues length unique concatStringsSep filterAttrs count;
        #in
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
      flake =
        let

          inherit (self) outputs;

          # Shared helper to create consistent pkgs set and stays DRY (Don't Repeat Yourself)
          mkPkgsCommon =
            {
              system,
              pkgsInput,
              #self,
              extraConfig ? { },
            }:
            /*let
              baseConfig = {
                allowUnfree = true;
                android_sdk.accept_license = true;
                nvidia.acceptLicense = true;
                pulseaudio = true;
                xsane.libusb = true;
              };

              # merge user overrides with default config
              #finalConfig = pkgsInput.lib.recursiveUpdate baseConfig extraConfig;
            in */
            import pkgsInput {
              inherit system;
              overlays = builtins.attrValues self.overlays;
              #config = finalConfig;
              #config = pkgsInput.lib.recursiveUpdate baseConfig extraConfig;
              config = pkgsInput.lib.recursiveUpdate {
                allowUnfree = true;
                android_sdk.accept_license = true;
                nvidia.acceptLicense = true;
                pulseaudio = true;
                xsane.libusb = true;
              } extraConfig;
            };

          #mkNixos = system: modules:
          #mkNixos = { system, modules, pkgsInput ? inputs.nixpkgs-stable, extraConfig ? {} }:
          #mkNixos = { system, modules, pkgsInput ? inputs.nixpkgs-release, extraConfig ? {} }:
          #mkNixos = { system, modules, pkgsInput ? inputs.nixpkgs-unstable, extraConfig ? {} }:
          #mkNixos =
          mkNixos = hostName: {
            system ? "x86_64-linux",
            #modules,
            pkgsInput ? inputs.nixpkgs,
            hmInput ? inputs.home-manager,
            #extraConfig ? { },
            extraModules ? [],
            copyConfig ? true,
          }:
            #inputs.nixpkgs.lib.nixosSystem { # <-- Use inputs.nixpkgs
            pkgsInput.lib.nixosSystem {
              # <-- Use inputs.nixpkgs
              #inputs.nixpkgs-unstable.lib.nixosSystem { # <-- Use inputs.nixpkgs-unstable
              #inherit system modules;
              inherit system; #modules;
              specialArgs = { inherit inputs outputs hmInput self; };           # NOTE: ...

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
              #
              #pkgs = mkPkgsCommon {
              #  inherit system pkgsInput self; # system, pkgsInput, and self come from the current mkNixos scope via inherit
              #  extraConfig = extraConfig; # explicitly rebinds the outer mkNixos.extraConfig to the inner mkPkgsCommon.extraConfig
              #};

              #modules = modules ++ [
              modules = [

                # Auto-resolve the host config path
                (./. + "/profiles/nixos/hosts/${hostName}/configuration.nix")

                ## Inject the home-manager NixOS module automatically for ALL hosts
                # Global Home Manager Configuration
                hmInput.nixosModules.home-manager

                {

                  #nixpkgs.pkgs = mkPkgsCommon { inherit system pkgsInput; };
                  nixpkgs.config = {
                    allowUnfree = true;
                    android_sdk.accept_license = true;
                    nvidia.acceptLicense = true;
                    pulseaudio = true;
                    xsane.libusb = true;
                  };
                  nixpkgs.overlays = builtins.attrValues self.overlays; # use myOverlays

                  home-manager = {
                    useGlobalPkgs = true; # Reuse system pkgs to save evalution RAM/Time
                    useUserPackages = true;
                    backupFileExtension = "backup";
                    extraSpecialArgs = { inherit inputs outputs hmInput self; };
                  };
                  environment.systemPackages = [ hmInput.packages.${system}.default ];

                  # Copy physical files ONLY if copyConfig is true
                  environment.etc."current-system-flake" = pkgsInput.lib.mkIf copyConfig {
                    source = self;
                  };

                  # Embed Git commit revision
                  system.configurationRevision = pkgsInput.lib.mkIf (self ? rev || self ? dirtyRev)
                    (self.rev or self.dirtyRev);

                }

                /*
                # Configure default settings for home-manager on all hosts
                {
                  home-manager = {
                    useGlobalPkgs = false; #true;
                    useUserPackages = true;
                    extraSpecialArgs = { inherit inputs outputs hmInput self; };
                  };
                }

                # Inject base configuration natively via a NixOS module
                #{
                #  nixpkgs.overlays = builtins.attrValues self.overlays;
                #  nixpkgs.config = pkgsInput.lib.recursiveUpdate {
                #    allowUnfree = true;
                #    android_sdk.accept_license = true;
                #    nvidia.acceptLicense = true;
                #    pulseaudio = true;
                #    xsane.libusb = true;
                #  } extraConfig;
                #}

                # Global configuration module
                ({ lib, pkgs, ... }: {

                  # INJECT HOME-MANAGER GLOBALLY HERE:
                  environment.systemPackages = [

                    #inputs.home-manager.packages.${system}.default # # <-- Statically locked to inputs.home-manager XXX
                    hmInput.packages.${system}.default #

                  ];

                  # Copy physical files ONLY if copyConfig is true
                  environment.etc."current-system-flake" = lib.mkIf copyConfig {
                    source = self;
                  };

                  # ALWAYS embed the exact Git commit revision (zero storage impact)
                  system.configurationRevision = lib.mkIf (self ? rev || self ? dirtyRev)
                    (self.rev or self.dirtyRev);


                })
                */

              ] ++ extraModules;

            };

          #
          # Standalone Home Manager Builder (For non-NixOS environments if needed)
          #
          #mkHome = { system, modules, pkgsInput ? inputs.nixpkgs-stable }:
          #mkHome = { system, modules, pkgsInput ? inputs.nixpkgs-unstable }: # nixpkgs-unstable as default
          #mkHome = { system, modules, pkgsInput ? inputs.nixpkgs-unstable, extraConfig ? {} }: # nixpkgs-unstable as default
          #mkHome = { system, modules, pkgsInput ? inputs.nixpkgs-stable, extraConfig ? {} }: # nixpkgs-stable as default
          #mkHome = { system, modules, pkgsInput ? inputs.nixpkgs-release, hmInput ? inputs.home-manager-release, extraConfig ? {} }: # nixpkgs-stable as default
          #mkHome = { system, modules, pkgsInput ? inputs.nixpkgs-release, hmInput ? inputs.home-manager, extraConfig ? {} }: # nixpkgs-stable as default
          mkHome = userName: hostName: {
              system ? "x86_64-linux",
              #modules,
              pkgsInput ? inputs.nixpkgs,
              hmInput ? inputs.home-manager,
              #extraConfig ? { },
              extraModules ? []
          }: # nixpkgs-stable as default
            #inputs.home-manager.lib.homeManagerConfiguration {
            hmInput.lib.homeManagerConfiguration {
              #pkgs = mkPkgsCommon {
              #  inherit system pkgsInput self;
              #  extraConfig = extraConfig;
              #};
              #pkgs = mkPkgsCommon { inherit system pkgsInput self extraConfig; };
              pkgs = mkPkgsCommon { inherit system pkgsInput; };
              #inherit modules;
              #extraSpecialArgs = { inherit inputs outputs; };
              extraSpecialArgs = { inherit inputs outputs self; };
              modules = [
                (./. + "/profiles/home-manager/users/${userName}/${hostName}")
              ] ++ extraModules;
            };

        in
        {
          #--------------------------------------------------
          # flake-parts.lib.mkFlake.flake.overlays
          #   will pass as
          #     flake ouputs: overlays
          #--------------------------------------------------
          #overlays = import ./overlays { inherit inputs outputs; };
          overlays = import ./overlays { inherit inputs; };                     # myOverlays

          nixosModules = import ./modules/nixos;                                # myNixosModules

          homeManagerModules = import ./modules/home-manager;                   # myHomeManagerModules

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

            khawlah = mkNixos "khawlah" {
              #system = "x86_64-linux";
              #modules = [
              extraModules = [
                #./profiles/nixos/hosts/khawlah/configuration.nix
                #inputs.home-manager.nixosModules.home-manager
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

            raudah = mkNixos "raudah" {
              #system = "x86_64-linux";
              #modules = [
              extraModules = [
                #./profiles/nixos/hosts/raudah/configuration.nix
                #inputs.home-manager.nixosModules.home-manager
                inputs.hardware.nixosModules.lenovo-thinkpad
                inputs.hardware.nixosModules.common-cpu-intel
                inputs.hardware.nixosModules.common-pc-laptop-ssd
                inputs.stylix.nixosModules.stylix
                #inputs.disko.nixosModules.disko
              ];
              #pkgsInput = inputs.nixpkgs-unstable; # override
            };

            huda = mkNixos "huda" {
              #system = "x86_64-linux";
              #modules = [
              extraModules = [
                #./profiles/nixos/hosts/huda/configuration.nix
                #inputs.home-manager.nixosModules.home-manager
                inputs.hardware.nixosModules.common-cpu-intel
                inputs.hardware.nixosModules.common-pc-laptop-ssd
                inputs.stylix.nixosModules.stylix
                #inputs.disko.nixosModules.disko
              ];
              #pkgsInput = inputs.nixpkgs-unstable; # override
            };

            bawang = mkNixos "bawang" {
              #system = "x86_64-linux";
              #pkgsInput = inputs.nixpkgs-unstable; # override
              #pkgsInput = inputs.nixpkgs-release-26_05; # override
              #pkgsInput = inputs.nixpkgs-release; # override
              extraModules = [
                #./profiles/nixos/hosts/bawang/configuration.nix
                inputs.home-manager.nixosModules.home-manager
                inputs.hardware.nixosModules.common-cpu-intel
                inputs.hardware.nixosModules.common-pc-laptop-ssd
                inputs.stylix.nixosModules.stylix
                #inputs.disko.nixosModules.disko
              ];
            };

            arang = mkNixos "arang" {
              #system = "x86_64-linux";
              #pkgsInput = inputs.nixpkgs-unstable; # override
              #pkgsInput = inputs.nixpkgs-release-26_05; # override
              #copyConfig = false; # Override to prevents copying the source files to /etc
              extraModules = [
                #./profiles/nixos/hosts/arang/configuration.nix
                #inputs.home-manager.nixosModules.home-manager
                inputs.hardware.nixosModules.common-cpu-intel
                inputs.hardware.nixosModules.common-pc-laptop-ssd
                inputs.stylix.nixosModules.stylix
                #inputs.disko.nixosModules.disko
              ];
            };

            #nyxora = let
            # Toggle these to true/false before running nixos-rebuild or nix run
            # Only enabled drive will be process
            #enableDrive1 = false;
            #enableDrive2 = false;
            #enableDrive3 = true;
            #in mkNixos {
            nyxora = mkNixos "nyxora" {

              #system = "x86_64-linux";
              extraModules = [
                # To test build
                #   nixos-rebuild dry-build --flake .#nyxora
                # To build and apply
                #   nixos-rebuild switch --flake .#nyxora
                #./profiles/nixos/hosts/nyxora/configuration.nix

                inputs.sops-nix.nixosModules.sops

                # Pass proxmox-nixos to modules
                #{ _module.args.proxmox-nixos = inputs.proxmox-nixos; }
                #
                # NixOS module: Enables and configures Proxmox services (services.proxmox-ve.*)
                #inputs.proxmox-nixos.nixosModules.proxmox-ve

                /*
                # Bind your home-manager configuration to your user here:
                inputs.home-manager.nixosModules.home-manager
                #
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.extraSpecialArgs = { inherit inputs; };
                  home-manager.users.najib = import ./profiles/home-manager/users/najib/nyxora;
                }
                */

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

            customdesktop = mkNixos "customdesktop" {
              #system = "x86_64-linux";
              extraModules = [
                #./profiles/nixos/hosts/customdesktop/configuration.nix
                inputs.sops-nix.nixosModules.sops
                inputs.disko.nixosModules.disko
                inputs.zfs-snapshot-manager.nixosModules.default
              ];
              #pkgsInput = inputs.nixpkgs-unstable; # override
            };

            durian = mkNixos "durian" {
              #system = "x86_64-linux";
              extraModules = [
                #./profiles/nixos/hosts/durian/configuration.nix
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
            asmak = mkNixos "asmak" {
              #system = "x86_64-linux";
              extraModules = [
                #./profiles/nixos/hosts/asmak/configuration.nix
                #inputs.home-manager.nixosModules.home-manager
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
            zahrah = mkNixos "zahrah" {
              #system = "x86_64-linux";
              extraModules = [
                #./profiles/nixos/hosts/zahrah/configuration.nix
                #inputs.home-manager.nixosModules.home-manager
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
            maryam = mkNixos "maryam" {
              #system = "x86_64-linux";
              extraModules = [
                #./profiles/nixos/hosts/maryam/configuration.nix
                #inputs.home-manager.nixosModules.home-manager
                inputs.hardware.nixosModules.lenovo-thinkpad
                inputs.hardware.nixosModules.common-cpu-intel
                inputs.hardware.nixosModules.common-pc-laptop-ssd
                inputs.stylix.nixosModules.stylix
                inputs.disko.nixosModules.disko
              ];
              #pkgsInput = inputs.nixpkgs-release; # override
              #pkgsInput = inputs.nixpkgs-unstable; # override
            };

            manggis = mkNixos "manggis" {
              #system = "x86_64-linux";
              extraModules = [
                #./profiles/nixos/hosts/manggis/configuration.nix
                inputs.hardware.nixosModules.lenovo-thinkpad-x220
              ];
              #pkgsInput = inputs.nixpkgs-unstable; # override
            };

            #hidayah = mkNixos "x86_64-linux" [
            #  ./profiles/nixos/hosts/hidayah/configuration.nix
            #  inputs.nix-ld.nixosModules.nix-ld
            #  { programs.nix-ld.dev.enable = true; }
            #];

            taufiq = mkNixos "taufiq" {
              #system = "x86_64-linux";
              extraModules = [
                #./profiles/nixos/hosts/taufiq/configuration.nix
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

            sakinah = mkNixos "sakinah" {
              #system = "x86_64-linux";
              extraModules = [
                #./profiles/nixos/hosts/sakinah/configuration.nix
                inputs.stylix.nixosModules.stylix
                inputs.hardware.nixosModules.common-cpu-intel

                #inputs.hardware.nixosModules.common-pc-laptop-ssd

                #inputs.home-manager.nixosModules.home-manager
                #inputs.home-manager-unstable.nixosModules.home-manager
              ];
              #pkgsInput = inputs.nixpkgs-release; # override
              #pkgsInput = inputs.nixpkgs-unstable; # override
              #pkgsInput = inputs.nixpkgs-release-26_05; # override
              #extraConfig = {
              #  allowBroken = true;
              #  permittedInsecurePackages = [ "openssl-1.1.1w" ];
              #};
              #hmInput = inputs.home-manager-unstable;
            };

            # White gaming desktop pc currently being use by Naqib
            sumayah = mkNixos "sumayah" {};

            laila = mkNixos "laila" {};

            # external USB 2.5" 256GB SSD brand SP
            sukun = mkNixos "sukun" {};

            # nixos on acer laptop
            parang = mkNixos "parang" {};

            # Thinkpad T410 without nvidia
            keira = mkNixos "keira" {
              #system = "x86_64-linux";
              #modules = [
              extraModules = [
                #./profiles/nixos/hosts/keira/configuration.nix
                inputs.hardware.nixosModules.lenovo-thinkpad-t410
              ];
              #pkgsInput = inputs.nixpkgs-unstable; # override
            };

          }; # End of 'nixosConfigurations = { ... };'

          #--------------------------------------------------
          # Standalone Home Manager Configurations
          # NOTE: Cleaned up duplicates. User home spaces are
          # fully integrated into the hosts above natively.
          #--------------------------------------------------
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
            "najib@sumayah" = mkHome "najib" "sumayah" {
              #system = "x86_64-linux";
              #modules = [ ./profiles/home-manager/users/najib/sumayah ];
              #pkgsInputs = inputs.nixpkgs-release;
              #pkgsInputs = inputs.nixpkgs-unstable;
            };
            "najib@taufiq" = mkHome "najib" "taufiq" {};
            "najib@huda" = mkHome "najib" "huda" {};
            "najib@bawang" = mkHome "najib" "bawang" {};
            "najib@maryam" = mkHome "najib" "maryam" {};
            "najib@customdesktop" = mkHome "najib" "customdesktop" {};
            "najib@asmak" = mkHome "najib" "asmak" {};
            "najib@zahrah" = mkHome "najib" "zahrah" {};
            "najib@khawlah" = mkHome "najib" "khawlah" {};
            "najib@keira" = mkHome "najib" "keira" {};
            "najib@nyxora" = mkHome "najib" "nyxora" {
              #modules = [
              extraModules = [
                #./profiles/home-manager/users/najib/nyxora
              ];
              #pkgsInputs = inputs.nixpkgs-release; # override
              #pkgsInputs = inputs.nixpkgs-unstable; # override
            };
            "najib@manggis" = mkHome "najib" "manggis" {};
            "najib@parang" = mkHome "najib" "parang" {};
            "najib@raudah" = mkHome "najib" "raudah" {};

            #-----------------------------------------------------------------------------
            # root
            #-----------------------------------------------------------------------------
            "root@taufiq" = mkHome "root" "taufiq" {
              #pkgsInputs = inputs.nixpkgs-release;
            };

            #-----------------------------------------------------------------------------
            # julia
            #-----------------------------------------------------------------------------
            "julia@manggis" = mkHome "julia" "manggis" {};
            "julia@keira" = mkHome "julia" "keira" {};

            #-----------------------------------------------------------------------------
            # nurnasuha
            #-----------------------------------------------------------------------------
            "nurnasuha@manggis" = mkHome "nurnasuha" "manggis" {};
            "nurnasuha@asmak" = mkHome "nurnasuha" "asmak" {};

            #-----------------------------------------------------------------------------
            # naqib
            #-----------------------------------------------------------------------------
            "naqib@sumayah" = mkHome "naqib" "sumayah" {
              #system = "x86_64-linux";
              extraModules = [
                #./profiles/home-manager/users/naqib/sumayah

                # Ensure this line is present here so it builds for the naqib user!
                #inputs.mc-project.homeModules.minecraft-client
              ];
            };

            "naqib@huda" = mkHome  "naqib" "huda" {
              #system = "x86_64-linux";
              #modules = [ ./profiles/home-manager/users/naqib/huda ];
            };

            "naqib@laila" = mkHome "naqib" "laila" {};
            "naqib@sukun" = mkHome "naqib" "sukun" {};
            "naqib@parang" = mkHome "naqib" "parang" {};
            "naqib@asmak" = mkHome "naqib" "asmak" {};
            "naqib@zahrah" = mkHome "naqib" "zahrah" {};
            "naqib@raudah" = mkHome "naqib" "raudah" {};
            "naqib@taufiq" = mkHome "naqib" "taufiq" {};

            #-----------------------------------------------------------------------------
            # naim
            #-----------------------------------------------------------------------------
            "naim@manggis" = mkHome "naim" "manggis" {};
            "naim@keira" = mkHome "naim" "keira" {};
            "naim@huda" = mkHome "naim" "huda" {};

        }; # End of 'homeConfigurations = { ... };'

      }; # End of 'flake = let ... in { ... };'
    }; # End of 'flake-parts.lib.mkFlake { inherit inputs; } { ... };
}
