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
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  inputs.nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixpkgs-master.url = "github:nixos/nixpkgs/master";
  inputs.lix-module = {
    url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.home-manager = {
    url = "github:nix-community/home-manager/release-25.05";
    inputs.nixpkgs.follows = "nixpkgs-unstable"; # "nixpkgs" # Forcing another flake (github nix-community home-manager) to use one of our inputs (nixpkgs).
  };
  inputs.hardware.url = "github:NixOS/nixos-hardware/master";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixvim = {
    url = "github:nix-community/nixvim";
    inputs.nixpkgs.follows = "nixpkgs-unstable"; #"nixpkgs";
  };
  inputs.neovim-config-NajibMalaysia.url = "github:mnajib/neovim-config-NajibMalaysia";
  inputs.nur.url = "github:nix-community/NUR";
  inputs.impermanence.url = "github:nix-community/impermanence";
  inputs.nix-colors.url = "github:misterio77/nix-colors";
  inputs.stylix.url = "github:danth/stylix/release-25.05";
  inputs.hyprland = {
    url = "git+https://github.com/hyprwm/hyprland?submodules=1";
    inputs.nixpkgs.follows = "nixpkgs-unstable"; #"nixpkgs"
  };
  inputs.hyprwn-contrib = {
    url = "github:hyprwm/contrib";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
  };
  inputs.hyprkeys = {
    url = "github:hyprland-community/hyprkeys";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
  };
  inputs.nh = {
    url = "github:viperML/nh?ref=fe4a96a0b0b0662dba7c186b4a1746c70bbcad03";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
  };
  inputs.sops-nix = {
    url = "github:mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs-unstable";                   # optional, not necessary for the module
  };
  inputs.nixos-generators = {
    url = "github:nix-community/nixos-generators";
    inputs.nixpkgs.follows = "nixpkgs-unstable"; #"nixpkgs";
  };
  inputs.dnsblacklist = {
    url = "github:notracking/hosts-blocklists";
    flake = false;
  };
  inputs.seaweedfs.url = "github:/mitchty/nixos-seaweedfs/wip";
  inputs.nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  inputs.nix-ld = {
    url = "github:Mic92/nix-ld";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-unstable,
    lix-module,
    home-manager,
    hardware,
    flake-utils,
    nur,
    impermanence,
    nix-colors,
    hyprland,
    nixos-generators,
    dnsblacklist,
    seaweedfs,
    sops-nix,
    nix-doom-emacs,
    nix-ld,
    nixvim,
    neovim-config-NajibMalaysia,
    stylix,
    ...
  }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      forEachSystem = nixpkgs.lib.genAttrs ["x86_64-linux"];
      forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});
      mkNixos = modules:
        nixpkgs.lib.nixosSystem {
          inherit modules;
          specialArgs = {inherit inputs outputs;};
        };
      mkHome = modules: pkgs:
        home-manager.lib.homeManagerConfiguration {
          inherit modules pkgs;
          extraSpecialArgs = {inherit inputs outputs;};
        };
    in
    rec {
      packages.${system} = {
        default = pkgs.hello; # custom package ???
      };
      devShells = forEachPkgs (
        pkgs:
          import ./shell.nix {
            inherit pkgs;
          }
      );
      formatter = forEachPkgs (pkgs: pkgs.alejandra);
      overlays = import ./overlays {inherit inputs outputs;};
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      nixosConfigurations = {
        khawlah = mkNixos [
          ./nixos/host-khawlah.nix
        ];
        khadijah = mkNixos [
          nix-ld.nixosModules.nix-ld
          { programs.nix-ld.dev.enable = true; }
          ./nixos/host-khadijah-Wayland-nauveau.nix
          inputs.stylix.nixosModules.stylix
        ];
        raudah = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-raudah.nix
          ];
        };
        mahirah = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-mahirah.nix
          ];
        };
        nyxora = mkNixos [
          ./profiles/nixos/hosts/nyxora/configuration.nix
        ]; # End nixosConfigurations.nyxora
        customdesktop = mkNixos [
          ./profiles/nixos/hosts/customdesktop/configuration.nix
          sops-nix.nixosModules.sops
        ];
        asmak = mkNixos [
          ./nixos/host-asmak.nix
          inputs.stylix.nixosModules.stylix
        ];
        zahrah = mkNixos [
          ./nixos/host-zahrah.nix
          hardware.nixosModules.lenovo-thinkpad # zahrah on T400, after T410 having CPU error
          hardware.nixosModules.common-cpu-intel
          hardware.nixosModules.common-pc-laptop-ssd
          inputs.stylix.nixosModules.stylix
        ];
        sakinah = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-sakinah.nix
            hardware.nixosModules.lenovo-thinkpad-x220
            inputs.stylix.nixosModules.stylix
          ];
        };
        manggis = mkNixos [
          ./profiles/nixos/hosts/manggis/configuration.nix
          hardware.nixosModules.lenovo-thinkpad-x220
        ];
        hidayah = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-hidayah.nix
            nix-ld.nixosModules.nix-ld
            { programs.nix-ld.dev.enable = true; }
          ];
        };
        taufiq = mkNixos [
          ./profiles/nixos/hosts/taufiq/configuration.nix
        ];
        sumayah = mkNixos [
          ./profiles/nixos/hosts/sumayah/configuration.nix
        ];
        keira = mkNixos [
          ./profiles/nixos/hosts/keira/configuration.nix
          hardware.nixosModules.lenovo-thinkpad-t410
        ];
        maryam = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-maryam.nix
          ];
        };
      }; # End nixosConfigurations
      homeConfigurations = {
        "najib@khawlah" = mkHome [./home-manager/user-najib/host-khawlah] nixpkgs.legacyPackages."x86_64-linux";
        "najib@raudah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-najib.nix
          ];
        };
        "najib@zahrah" = mkHome [
          ./home-manager/user-najib/host-zahrah
        ] nixpkgs.legacyPackages."x86_64-linux";
        "najib@customdesktop" = mkHome [./home-manager/user-najib/host-customdesktop/default.nix] nixpkgs.legacyPackages."x86_64-linux";
        "najib@nyxora" = mkHome [./home-manager/user-najib/host-nyxora/default.nix] nixpkgs.legacyPackages."x86_64-linux";
        "najib@khadijah" = mkHome [./home-manager/user-najib/host-khadijah] nixpkgs.legacyPackages."x86_64-linux";
        "najib@maryam" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-najib.nix
          ];
        };
        "najib@mahirah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-najib.nix
          ];
        };
        "najib@delldesktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-najib.nix
          ];
        };
        "root@customdesktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-root.nix
          ];
        };
        "root@nyxora" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/user-root/host-nyxora
          ];
        };
        "naim@zahrah" = mkHome [./home-manager/user-naim/host-zahrah] nixpkgs.legacyPackages."x86_64-linux";
        "naim@khadijah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-naim.nix
          ];
        };
        "naim@sakinah" = mkHome [./home-manager/user-naim/host-sakinah] nixpkgs.legacyPackages."x86_64-linux";
        "naqib@asmak" = mkHome [./home-manager/user-naqib/host-asmak] nixpkgs.legacyPackages."x86_64-linux";
        "naqib@sakinah" = mkHome [./home-manager/user-naqib/host-sakinah] nixpkgs.legacyPackages."x86_64-linux";
        "naqib@raudah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/user-naqib/host-raudah/default.nix
          ];
        };
        "najib@asmak" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-najib.nix
          ];
        };
        "naqib@hidayah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/user-naqib/host-hidayah/default.nix
          ];
        };
        "nurnasuha@sakinah" = mkHome [./home-manager/user-nurnasuha/host-sakinah] nixpkgs.legacyPackages."x86_64-linux";
        "nurnasuha@customdesktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/user-nurnasuha/host-customdesktop/default.nix
          ];
        };
        "julia@keira" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/user-julia/host-keira/default.nix
          ];
        };
        "julia@manggis" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/user-julia/host-manggis/default.nix
          ];
        };
        "najib@taufiq" = mkHome [
          ./home-manager/user-najib/host-taufiq
        ] nixpkgs.legacyPackages."x86_64-linux";
        "julia@taufiq"      = mkHome [./home-manager/user-julia/host-taufiq] nixpkgs.legacyPackages."x86_64-linux";
        "naqib@taufiq"      = mkHome [./home-manager/user-naqib/host-taufiq] nixpkgs.legacyPackages."x86_64-linux";
        "nurnasuha@taufiq"  = mkHome [./home-manager/user-nurnasuha/host-taufiq] nixpkgs.legacyPackages."x86_64-linux";
        "naim@taufiq"       = mkHome [./home-manager/user-naim/host-taufiq] nixpkgs.legacyPackages."x86_64-linux";
      }; # End homeConfiguration
    }; # End let ... in ... rec
}
