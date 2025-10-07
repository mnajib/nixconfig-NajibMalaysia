{
  description = "My NixOS Config";

  nixConfig = {
    #extra-substituters = [
    #  "https://nix-community.cachix.org"
    #];
    #extra-trusted-public-keys = [
    #  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #];
  };

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    #nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs.follows = "nixpkgs-stable"; # Make 'nixpkgs' point to nixpkgs-stable

    flake-parts.url = "github:hercules-ci/flake-parts";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
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

    stylix.url = "github:danth/stylix/release-25.05";

    hyprland = {
      url = "git+https://github.com/hyprwm/hyprland?submodules=1";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprwn-contrib = {
      url = "github:hyprwm/contrib";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprkeys = {
      url = "github:hyprland-community/hyprkeys";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh?ref=fe4a96a0b0b0662dba7c186b4a1746c70bbcad03";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dnsblacklist = {
      url = "github:notracking/hosts-blocklists";
      flake = false;
    };

    seaweedfs.url = "github:/mitchty/nixos-seaweedfs/wip";

    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  }; # End of 'inputs = { ... };'

  outputs = inputs@{ flake-parts, self, ... }:
  #outputs = top@{ flake-parts, self, ... }:
  #outputs = top@inputs@{ flake-parts, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [
        #inputs.stylix.flakeModule
        #inputs.hyprland.flakeModule
      ];

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
          packages = {
            default = pkgs.hello;
          };

          devShells.default = import ./shell.nix { inherit pkgs; };

          formatter = pkgs.alejandra;

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

      flake = let

        inherit (self) outputs;

        mkNixos = system: modules:
          inputs.nixpkgs.lib.nixosSystem { # <-- Use inputs.nixpkgs
          #inputs.nixpkgs-unstable.lib.nixosSystem { # <-- Use inputs.nixpkgs-unstable
            inherit system modules;
            specialArgs = { inherit inputs outputs; };

            # Apply your overlays and config to the pkgs used by NixOS modules
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = builtins.attrValues self.overlays;
              config = {
                allowUnfree = true;
                android_sdk.accept_license = true;
                nvidia.acceptLicense = true;
                pulseaudio = true;
                xsane.libusb = true;
              };
            };

          };

        mkHome = system: modules:
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.${system}; # <-- Use inputs.nixpkgs
            #pkgs = inputs.nixpkgs-unstable.legacyPackages.${system}; # <-- Use inputs.nixpkgs-unstable
            inherit modules;
            extraSpecialArgs = { inherit inputs outputs; };
          };

      in {
        #overlays = import ./overlays { inherit inputs outputs; };
        overlays = import ./overlays { inherit inputs; };
        nixosModules = import ./modules/nixos;
        homeManagerModules = import ./modules/home-manager;

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
          khawlah = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/khawlah/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            inputs.hardware.nixosModules.lenovo-thinkpad
            inputs.hardware.nixosModules.common-cpu-intel
            inputs.hardware.nixosModules.common-pc-laptop-ssd
            inputs.stylix.nixosModules.stylix
            inputs.disko.nixosModules.disko
          ];

          #khadijah = mkNixos "x86_64-linux" [
          #  inputs.nix-ld.nixosModules.nix-ld
          #  { programs.nix-ld.dev.enable = true; }
          #  ./profiles/nixos/hosts/khadijah/host-khadijah-Wayland-nauveau.nix
          #  #./profiles/nixos/hosts/khadijah/configuration.nix
          #  inputs.stylix.nixosModules.stylix
          #];

          raudah = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/raudah/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            inputs.hardware.nixosModules.lenovo-thinkpad
            inputs.hardware.nixosModules.common-cpu-intel
            inputs.hardware.nixosModules.common-pc-laptop-ssd
            inputs.stylix.nixosModules.stylix
            #inputs.disko.nixosModules.disko
          ];

          #mahirah = mkNixos "x86_64-linux" [
          #  ./profiles/nixos/hosts/mahirah/configuration.nix
          #];

          nyxora = let
            # Toggle these to true/false before running nixos-rebuild or nix run
            # Only enabled drive will be process
            enableDrive1 = false;
            enableDrive2 = false;
            enableDrive3 = true;
          in mkNixos "x86_64-linux" [
            # To test build
            #   nixos-rebuild dry-build --flake .#nyxora
            # To build and apply
            #   nixos-rebuild switch --flake .#nyxora
            ./profiles/nixos/hosts/nyxora/configuration.nix

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

          ];

          #customdesktop = inputs.nixpkgs-unstable.lib.nixosSystem {  # <-- Use inputs.nixpkgs-unstable
          #  system = "x86_64-linux";
          #  modules = [
          #    ./profiles/nixos/hosts/customdesktop/configuration.nix
          #    /* ... */
          #  ];
          #};
          #
          customdesktop = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/customdesktop/configuration.nix
            inputs.sops-nix.nixosModules.sops
          ];

          #asmak = mkNixos "x86_64-linux" [
          #  ./profiles/nixos/hosts/asmak/configuration.nix
          #  inputs.stylix.nixosModules.stylix
          #];

          #
          ##nix run nixpkgs#nixos-anywhere -- --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix root@nixos
          # nix run nixpkgs#nixos-anywhere -- --flake .#zahrah  --generate-hardware-config nixos-generate-config ./hardware-configuration.nix root@nixos
          #
          zahrah = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/zahrah/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            inputs.hardware.nixosModules.lenovo-thinkpad
            inputs.hardware.nixosModules.common-cpu-intel
            inputs.hardware.nixosModules.common-pc-laptop-ssd
            inputs.stylix.nixosModules.stylix
            inputs.disko.nixosModules.disko
          ];

          # nix run nixpkgs#nixos-anywhere -- --flake .#maryam  --generate-hardware-config nixos-generate-config ./hardware-configuration.nix root@nixos
          maryam = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/maryam/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            inputs.hardware.nixosModules.lenovo-thinkpad
            inputs.hardware.nixosModules.common-cpu-intel
            inputs.hardware.nixosModules.common-pc-laptop-ssd
            inputs.stylix.nixosModules.stylix
            inputs.disko.nixosModules.disko
          ];

          #sakinah = mkNixos "x86_64-linux" [
          #  ./profiles/nixos/hosts/sakinah/configuration.nix
          #  inputs.hardware.nixosModules.lenovo-thinkpad-x220
          #  inputs.stylix.nixosModules.stylix
          #];

          manggis = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/manggis/configuration.nix
            inputs.hardware.nixosModules.lenovo-thinkpad-x220
          ];

          #hidayah = mkNixos "x86_64-linux" [
          #  ./profiles/nixos/hosts/hidayah/configuration.nix
          #  inputs.nix-ld.nixosModules.nix-ld
          #  { programs.nix-ld.dev.enable = true; }
          #];

          taufiq = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/taufiq/configuration.nix
          ];

          sumayah = mkNixos "x86_64-linux" [
            #self.nixosModules.grafito
            ./profiles/nixos/hosts/sumayah/configuration.nix
          ];

          keira = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/keira/configuration.nix
            inputs.hardware.nixosModules.lenovo-thinkpad-t410
          ];

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

          #"najib@taufiq" = inputs.home-manager.lib.homeManagerConfiguration {
          #  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          #  extraSpecialArgs = { inherit inputs; };
          #  modules = [
          #    ./home-manager/user-najib/host-taufiq
          #  ];
          #};
          "najib@taufiq" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/najib/taufiq ];
          "najib@sumayah" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/najib/sumayah ];
          "najib@maryam" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/najib/maryam ];
          "najib@zahrah" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/najib/zahrah ];
          "najib@khawlah" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/najib/khawlah ];

          "root@taufiq" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/root/taufiq ];

          "julia@manggis" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/julia/manggis ];
          "julia@keira" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/julia/keira ];

          "nurnasuha@manggis" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/nurnasuha/manggis ];
          "nurnasuha@asmak" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/nurnasuha/asmak ];

          "naqib@sumayah" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/naqib/sumayah ];
          "naqib@asmak" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/naqib/asmak ];
          "naqib@zahrah" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/naqib/zahrah ];
          "naqib@raudah" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/naqib/raudah ];
          "naqib@taufiq" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/naqib/taufiq ];

          "naim@manggis" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/naim/manggis ];
          "naim@keira" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/naim/keira ];

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
