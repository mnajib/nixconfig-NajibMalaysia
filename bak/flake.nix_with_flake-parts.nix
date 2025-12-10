{
  description = "NajibOS";
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

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        #inputs.stylix.flakeModule
        #inputs.hyprland.flakeModule
      ];

      perSystem = { config, self, pkgs, system, inputs, ... }:
        let
          inherit (self) outputs;
          mkNixos = modules:
            pkgs.lib.nixosSystem {
              inherit modules;
              specialArgs = { inherit inputs outputs; };
            };
          mkHome = modules:
            inputs.home-manager.lib.homeManagerConfiguration {
              inherit modules pkgs;
              extraSpecialArgs = { inherit inputs outputs; };
            };
        in
        {
          packages = {
            default = pkgs.hello;
          };

          devShells.default = import ./shell.nix { inherit pkgs; };

          formatter = pkgs.alejandra;

        };

      flake = {
        #overlays = import ./overlays { inherit inputs outputs; };
        overlays = import ./overlays { inherit inputs; };
        nixosModules = import ./modules/nixos;
        homeManagerModules = import ./modules/home-manager;

        nixosConfigurations = {
          khawlah = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./nixos/host-khawlah.nix
            ];
          };
          khadijah = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              inputs.nix-ld.nixosModules.nix-ld
              { programs.nix-ld.dev.enable = true; }
              ./nixos/host-khadijah-Wayland-nauveau.nix
              inputs.stylix.nixosModules.stylix
            ];
          };
          raudah = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./nixos/host-raudah.nix
            ];
          };
          mahirah = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./nixos/host-mahirah.nix
            ];
          };
          nyxora = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./profiles/nixos/hosts/nyxora/configuration.nix
            ];
          };
          customdesktop = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./profiles/nixos/hosts/customdesktop/configuration.nix
              inputs.sops-nix.nixosModules.sops
            ];
          };
          asmak = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./nixos/host-asmak.nix
              inputs.stylix.nixosModules.stylix
            ];
          };
          zahrah = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./nixos/host-zahrah.nix
              inputs.hardware.nixosModules.lenovo-thinkpad
              inputs.hardware.nixosModules.common-cpu-intel
              inputs.hardware.nixosModules.common-pc-laptop-ssd
              inputs.stylix.nixosModules.stylix
            ];
          };
          sakinah = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./nixos/host-sakinah.nix
              inputs.hardware.nixosModules.lenovo-thinkpad-x220
              inputs.stylix.nixosModules.stylix
            ];
          };
          manggis = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./profiles/nixos/hosts/manggis/configuration.nix
              inputs.hardware.nixosModules.lenovo-thinkpad-x220
            ];
          };
          hidayah = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./nixos/host-hidayah.nix
              inputs.nix-ld.nixosModules.nix-ld
              { programs.nix-ld.dev.enable = true; }
            ];
          };
          taufiq = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./profiles/nixos/hosts/taufiq/configuration.nix
            ];
          };
          sumayah = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./profiles/nixos/hosts/sumayah/configuration.nix
            ];
          };
          keira = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./profiles/nixos/hosts/keira/configuration.nix
              inputs.hardware.nixosModules.lenovo-thinkpad-t410
            ];
          };
          maryam = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./nixos/host-maryam.nix
            ];
          };
        };

        homeConfigurations = {
          "najib@khawlah" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-najib/host-khawlah
            ];
          };
          "najib@raudah" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/home-najib.nix
            ];
          };
          "najib@zahrah" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-najib/host-zahrah
            ];
          };
          "najib@customdesktop" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-najib/host-customdesktop/default.nix
            ];
          };
          "najib@nyxora" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-najib/host-nyxora/default.nix
            ];
          };
          "najib@khadijah" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-najib/host-khadijah
            ];
          };
          "najib@maryam" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/home-najib.nix
            ];
          };
          "najib@mahirah" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/home-najib.nix
            ];
          };
          "najib@delldesktop" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/home-najib.nix
            ];
          };
          "root@customdesktop" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/home-root.nix
            ];
          };
          "root@nyxora" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-root/host-nyxora
            ];
          };
          "naim@zahrah" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-naim/host-zahrah
            ];
          };
          "naim@khadijah" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/home-naim.nix
            ];
          };
          "naim@sakinah" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-naim/host-sakinah
            ];
          };
          "naqib@asmak" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-naqib/host-asmak
            ];
          };
          "naqib@sakinah" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-naqib/host-sakinah
            ];
          };
          "naqib@raudah" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-naqib/host-raudah/default.nix
            ];
          };
          "najib@asmak" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/home-najib.nix
            ];
          };
          "naqib@hidayah" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-naqib/host-hidayah/default.nix
            ];
          };
          "nurnasuha@sakinah" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-nurnasuha/host-sakinah
            ];
          };
          "nurnasuha@customdesktop" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-nurnasuha/host-customdesktop/default.nix
            ];
          };
          "julia@keira" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-julia/host-keira/default.nix
            ];
          };
          "julia@manggis" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-julia/host-manggis/default.nix
            ];
          };
          "najib@taufiq" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-najib/host-taufiq
            ];
          };
          "julia@taufiq" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-julia/host-taufiq
            ];
          };
          "naqib@taufiq" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-naqib/host-taufiq
            ];
          };
          "nurnasuha@taufiq" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-nurnasuha/host-taufiq
            ];
          };
          "naim@taufiq" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/user-naim/host-taufiq
            ];
          };
        };
      };
    };
}
