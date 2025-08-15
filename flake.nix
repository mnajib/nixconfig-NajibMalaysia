{
  description = "My NixOS Config";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    flake-parts.url = "github:hercules-ci/flake-parts";

    disko.url = "github:nix-community/disko";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hardware.url = "github:NixOS/nixos-hardware/master";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    neovim-config-NajibMalaysia.url = "github:mnajib/neovim-config-NajibMalaysia";
    nur.url = "github:nix-community/NUR";
    impermanence.url = "github:nix-community/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";
    stylix.url = "github:danth/stylix/release-25.05";
    hyprland = {
      url = "git+https://github.com/hyprwm/hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hyprwn-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hyprkeys = {
      url = "github:hyprland-community/hyprkeys";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nh = {
      url = "github:viperML/nh?ref=fe4a96a0b0b0662dba7c186b4a1746c70bbcad03";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
  };

  outputs = inputs@{ flake-parts, self, ... }:
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
        in
        {
          packages = {
            default = pkgs.hello;
          };

          devShells.default = import ./shell.nix { inherit pkgs; };

          formatter = pkgs.alejandra;

        };

      flake = let

        inherit (self) outputs;

        mkNixos = system: modules:
          inputs.nixpkgs.lib.nixosSystem { # <-- Use inputs.nixpkgs
          #inputs.nixpkgs-unstable.lib.nixosSystem { # <-- Use inputs.nixpkgs-unstable
            inherit system modules;
            specialArgs = { inherit inputs outputs; };
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
          # NOTE: to test / dry-build nixos for host 'taufiq'
          #   nixos-rebuild dry-build --flake .#taufiq

          khawlah = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/khawlah/configuration.nix
          ];

          khadijah = mkNixos "x86_64-linux" [
            inputs.nix-ld.nixosModules.nix-ld
            { programs.nix-ld.dev.enable = true; }
            ./profiles/nixos/hosts/khadijah/host-khadijah-Wayland-nauveau.nix
            #./profiles/nixos/hosts/khadijah/configuration.nix
            inputs.stylix.nixosModules.stylix
          ];

          raudah = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/raudah/configuration.nix
          ];

          mahirah = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/mahirah/configuration.nix
          ];

          nyxora = mkNixos "x86_64-linux" [
            # To test build
            #   nixos-rebuild dry-build --flake .#nyxora
            # To build and apply
            #   nixos-rebuild switch --flake .#nyxora
            ./profiles/nixos/hosts/nyxora/configuration.nix

            inputs.disko.nixosModules.disko

            # To apply disko
            #   nix run 3#nixosConfigurations.nyxora.config.system.build.disko
            # 'nixos-rebuild' will ignore the partitioning (by 'disko') step by default.
            #{ disko.devices = import ./profile/nixos/hosts/nyxora/disko-GCNL.nix {}; }
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

          asmak = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/asmak/configuration.nix
            inputs.stylix.nixosModules.stylix
          ];

          zahrah = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/zahrah/configuration.nix
            inputs.hardware.nixosModules.lenovo-thinkpad
            inputs.hardware.nixosModules.common-cpu-intel
            inputs.hardware.nixosModules.common-pc-laptop-ssd
            inputs.stylix.nixosModules.stylix
          ];

          sakinah = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/sakinah/configuration.nix
            inputs.hardware.nixosModules.lenovo-thinkpad-x220
            inputs.stylix.nixosModules.stylix
          ];

          manggis = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/manggis/configuration.nix
            inputs.hardware.nixosModules.lenovo-thinkpad-x220
          ];

          hidayah = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/hidayah/configuration.nix
            inputs.nix-ld.nixosModules.nix-ld
            { programs.nix-ld.dev.enable = true; }
          ];

          taufiq = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/taufiq/configuration.nix
          ];

          sumayah = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/sumayah/configuration.nix
          ];

          keira = mkNixos "x86_64-linux" [
            ./profiles/nixos/hosts/keira/configuration.nix
            inputs.hardware.nixosModules.lenovo-thinkpad-t410
          ];

        }; # End of 'nixosConfigurations = { ... };'

        # Make disko shortcut
        #  nix run .#disko-nyxora-newmirror
        #apps.x86_64-linux.disko-nyxora-GCNL = {
        #apps.x86_64-linux = {
        apps = {
          x86_64-linux = {

            #--------------------------------------------------------------------
            # for host nyxora
            #--------------------------------------------------------------------

            # To apply disko to drive ...7G9F only:
            #   nix run .#disko-nyxora-7G9F
            disko-nyxora-7G9F = let system = "x86_64-linux"; in {
              type = "app";
              #program = "${self.nixosConfigurations.nyxora.config.system.build.disko}/bin/disko";
              program = toString (inputs.nixpkgs.legacyPackages.${system}.writeShellScript "disko-nyxora-7G9F" ''
                exec ${self.nixosConfigurations.nyxora.config.system.build.disko} \
                  --arg devices "(import ./profile/nixos/hosts/nyxora/disko-7G9F.nix {})"
              '');
            };

            # To apply disko to drive ...4S78 only:
            #   nix run .#disko-nyxora-4S78
            disko-nyxora-4S78 = let system = "x86_64-linux"; in {
              type = "app";
              #program = "${self.nixosConfigurations.nyxora.config.system.build.disko}/bin/disko";
              program = toString (inputs.nixpkgs.legacyPackages.${system}.writeShellScript "disko-nyxora-4S78" ''
                exec ${self.nixosConfigurations.nyxora.config.system.build.disko} \
                  --arg devices "(import ./profile/nixos/hosts/nyxora/disko-4S78.nix {})"
              '');
            };

            # To apply disko to drive ...GCNL only:
            #   nix run .#disko-nyxora-GCNL
            disko-nyxora-GCNL = let system = "x86_64-linux"; in {
              type = "app";
              #program = "${self.nixosConfigurations.nyxora.config.system.build.disko}/bin/disko";
              program = toString (inputs.nixpkgs.legacyPackages.${system}.writeShellScript "disko-nyxora-GCNL" ''
                exec ${self.nixosConfigurations.nyxora.config.system.build.disko} \
                  --arg devices "(import ./profile/nixos/hosts/nyxora/disko-GCNL.nix {})"
              '');
            };

            # To apply disko to drive ...7G9F and drive...GCNL :
            #   nix run .#disko-nyxora-7G9F-GCNL
            disko-nyxora-7G9F-GCNL = let system = "x86_64-linux"; in {
              type = "app";
              #program = "${self.nixosConfigurations.nyxora.config.system.build.disko}/bin/disko";
              program = toString (inputs.nixpkgs.legacyPackages.${system}.writeShellScript "disko-nyxora-7G9F-GCNL" ''
                exec ${self.nixosConfigurations.nyxora.config.system.build.disko} \
                  --arg devices "(nixpkgs.lib.mkMerge [
                    (import ./profile/nixos/hosts/nyxora/disko-7G9F.nix {})
                    (import ./profile/nixos/hosts/nyxora/disko-GCNL.nix {})
                  ])"
              '');
            };

            # To apply disko to the all three drives
            #   nix run .#disko-nyxora-all
            disko-nyxora-all = let system = "x86_64-linux"; in {
              type = "app";
              #program = "${self.nixosConfigurations.nyxora.config.system.build.disko}/bin/disko";
              program = toString (inputs.nixpkgs.legacyPackages.${system}.writeShellScript "disko-nyxora-all" ''
                exec ${self.nixosConfigurations.nyxora.config.system.build.disko} \
                  --arg devices "(nixpkgs.lib.mkMerge [
                    (import ./profile/nixos/hosts/nyxora/disko-7G9F.nix {})
                    (import ./profile/nixos/hosts/nyxora/disko-4S78.nix {})
                    (import ./profile/nixos/hosts/nyxora/disko-GCNL.nix {})
                  ])"
              '');
            };

            #--------------------------------------------------------------------
            # for host customdesktop
            #--------------------------------------------------------------------
            # ...

          }; # End apps.x86_64-linux = { ... };
        }; # End apps = { ... };

        homeConfigurations = {
          # NOTE: to dry-build a Home Manager configuration for the user 'najib@taufiq':
          #   nix build ".#homeConfigurations.najib@taufiq.activationPackage" --dry-run
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

          "root@taufiq" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/root/taufiq ];

          "julia@manggis" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/julia/manggis ];
          "julia@keira" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/julia/keira ];

          "nurnasuha@manggis" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/nurnasuha/manggis ];
          "nurnasuha@asmak" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/nurnasuha/asmak ];

          "naqib@sumayah" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/naqib/sumayah ];
          "naqib@asmak" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/naqib/asmak ];

          "naim@manggis" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/naim/manggis ];
          "naim@keira" = mkHome "x86_64-linux" [ ./profiles/home-manager/users/naim/keira ];

        }; # End of 'homeConfigurations = { ... };'

      };
    };
}
