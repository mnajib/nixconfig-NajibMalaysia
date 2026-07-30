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
    # How to Consume in Home Manager
    #
    # 1. Inside your flake.nix:
    #
    #   inputs = {
    #     # my-doom-emacs.url = "path:/path/to/doom-dual-mode";
    #     # or GitHub URL
    #     my-emacs.url = "github:mnajib/emacs-doom-dual-mode";
    #   };
    #
    # 2. Inside home.nix:
    #
    #   home.packages = [
    #     #inputs.my-doom-emacs.packages.${system}.default
    #     inputs.my-emacs.packages.${system}.default
    #   ];
    #
    my-emacs.url = "github:mnajib/emacs-doom-dual-mode";


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
    #      nh os build . -- --override-input mc-project path:/home/naqib/src/minecraft-infra
    #      nh os test  . -- --override-input mc-project path:/home/naqib/src/minecraft-infra
    #
    # 4. To get update from upstream repo
    #      nix flake update mc-project
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

          # Builder functions (mkPkgsCommon, mkNixos, mkHome, homeProfilePath)
          # live in lib/builders.nix -- kept out of flake.nix so this file
          # stays focused on wiring (inputs -> outputs: which host uses
          # which builder, with which overrides) rather than builder
          # internals. See that file for what each one does.
          inherit (import ./lib/builders.nix { inherit inputs self; })
            homeProfilePath
            mkPkgsCommon
            mkNixos
            mkHome
            ;

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
          # flake-parts.lib.mkFlake.flake.homeConfigurations
          #   will pass as
          #     flake ouputs: nixosConfigurations, homeConfigurations
          #
          # Per-host system entries live in hosts.nix; standalone
          # per-user home-manager entries live in homes.nix. Split because
          # they're edited for different reasons (machine vs person) --
          # see either file's header comment for details. This is just
          # the wiring.
          #--------------------------------------------------
          inherit (import ./hosts.nix { inherit inputs mkNixos; })
            nixosConfigurations
            ;

          inherit (import ./homes.nix { inherit inputs mkHome; })
            homeConfigurations
            ;


      }; # End of 'flake = let ... in { ... };'
    }; # End of 'flake-parts.lib.mkFlake { inherit inputs; } { ... };
}
