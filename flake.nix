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

    #nixpkgs.url      = "github:nixos/nixpkgs/nixos-25.05";
    #nixpkgs.url      = "github:nixos/nixpkgs/nixos-25.11";
    #nixpkgs.follows  = "nixpkgs-stable"; # Make 'nixpkgs' point to nixpkgs-stable as default.
    #nixpkgs.follows  = "nixpkgs-unstable"; # Make 'nixpkgs' point to nixpkgs-stable as default.
    #nixpkgs.url      = "github:NixOS/nixpkgs/nixpkgs-unstable";
    #nixpkgs.url      = "github:nixos/nixpkgs/release-25.11";
    #nixpkgs.url      = "github:nixos/nixpkgs/release-26.05";
    nixpkgs.follows   = "nixpkgs-release"; # Make 'nixpkgs' point to nixpkgs-stable as default.

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
    # System Utilities & Infrastructure
    #------------------------------------------------------

    # Flake Framework
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.nixpkgs.follows = "nixpkgs-stable";
      #inputs.nixpkgs.follows = "nixpkgs-release";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz"; # XXX:
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

    # To test your system with the local path override flags
    #  nh os build . -- --override-input waktusolat path:/home/najib/src/waktusolat-NajibMalaysia
    #  nh os test . -- --override-input waktusolat path:/home/najib/src/waktusolat-NajibMalaysia
    waktusolat.url = "github:mnajib/waktusolat-NajibMalaysia";

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

    niri.url = "github:sodiboo/niri-flake";

  }; # End of 'inputs = { ... };'

#  outputs =
#    inputs@{ self, nixpkgs, ... }:
#    let
#      supportedSystems = [
#        "x86_64-linux"
#        "aarch64-linux"
#      ];
#
#      #forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
#
#      # ONE-TIME HARNESS HELPER (Solves Trade-off #1 and Trade-off #4)
#      # Automatically instantiates pkgs for per-system outputs
#      eachSystem = f: nixpkgs.lib.genAttrs supportedSystems (system:
#        f (import nixpkgs {
#          inherit system;
#          config.allowUnfree = true;
#        })
#      );
#
#      #inherit (self) outputs;
#
#      # Builder functions (mkPkgsCommon, mkNixos, mkHome, homeProfilePath)
#      # live in lib/builders.nix -- kept out of flake.nix so this file
#      # stays focused on wiring (inputs -> outputs: which host uses
#      # which builder, with which overrides) rather than builder
#      # internals. See that file for what each one does.
#      inherit (import ./lib/builders.nix { inherit inputs self; })
#        hostProfilePath
#        homeProfilePath
#        mkPkgsCommon
#        mkNixos
#        mkHome
#        ;
#
#    in
#    {
#      #------------------------------------------------------------------------
#      # 1. Per-System Flake Outputs (Clean & Boilerplate-Free)
#      #------------------------------------------------------------------------
#
#      #packages = forAllSystems (system:
#      #  let
#      #    pkgs = import nixpkgs { inherit system; };
#      #  in
#      #  {
#      #    default = pkgs.hello;
#      #
#      #    # To use this mangayomi:
#      #    #   nix shell .#mangayomi
#      #    #   nix run .#mangayomi
#      #    mangayomi = pkgs.mangayomi;
#      #  }
#      #);
#
#      packages = eachSystem (pkgs: {
#        default = pkgs.hello;
#        mangayomi = pkgs.mangayomi;
#      });
#
#      #devShells = forAllSystems (system:
#      #  let
#      #    pkgs = import nixpkgs { inherit system; };
#      #  in
#      #  {
#      #    default = import ./shell.nix { inherit pkgs; };
#      #  }
#      #);
#
#      devShells = eachSystem (pkgs: {
#        default = import ./shell.nix { inherit pkgs; };
#      });
#
#      #formatter = forAllSystems (system:
#      #  let
#      #    pkgs = import nixpkgs { inherit system; };
#      #  in
#      #  pkgs.alejandra
#      #);
#
#      formatter = eachSystem (pkgs: pkgs.alejandra);
#
#      #------------------------------------------------------------------------
#      # 2. Global Flake Outputs & Delegated Wiring
#      #------------------------------------------------------------------------
#
#      overlays = import ./overlays { inherit inputs; };                     # myOverlays
#
#      nixosModules = import ./modules/nixos;                                # myNixosModules
#
#      homeManagerModules = import ./modules/home-manager;                   # myHomeManagerModules
#
#      inherit (import ./hosts.nix { inherit inputs mkNixos; })
#        nixosConfigurations
#        ;
#
#      inherit (import ./homes.nix { inherit inputs mkHome; })
#        homeConfigurations
#        ;
#
#    }; # End of 'outputs = ...'

    outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      # SOLVES TRADE-OFF #1: Third-Party flakeModule Imports
      imports = [
        # Example: inputs.treefmt-nix.flakeModule
      ];

      # SOLVES TRADE-OFF #4: Clean, System-Aware Outputs Scope
      perSystem = { pkgs, system, inputs', ... }: {
        # Configure unfree packages cleanly per system
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        packages = {
          default = pkgs.hello;
          mangayomi = pkgs.mangayomi;
        };

        devShells = {
          default = import ./shell.nix { inherit pkgs; };
        };

        formatter = pkgs.alejandra;
      };

      # Top-Level Flake Outputs (NixOS & Home Manager Systems)
      flake = let
        self = inputs.self;

        # Uses your existing lib/builders.nix unchanged
        inherit (import ./lib/builders.nix { inherit inputs self; })
          mkNixos
          mkHome;
      in {
        overlays = import ./overlays { inherit inputs; };
        nixosModules = import ./modules/nixos;
        homeManagerModules = import ./modules/home-manager;

        inherit (import ./hosts.nix { inherit inputs mkNixos; })
          nixosConfigurations;

        inherit (import ./homes.nix { inherit inputs mkHome; })
          homeConfigurations;
      };
    }; # End of outputs = ...

}
