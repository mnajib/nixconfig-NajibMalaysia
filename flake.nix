{
  description = "Najib new nix flake config";

  inputs = {
    # Nixpkgs
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    #
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.11";

    # Set this up as an overlay; or pull-request (PR) it to nixpkgs.
    #nixpkgs-mitchty.url = "github:/mitchty/nixpkgs/mitchty";
    #nixpkgs-najib.url = "github:/mnajib/nixpkgs/najib";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Add any other flake you might need
    hardware.url = "github:nixos/nixos-hardware";

    flake-utils.url = "github:numtide/flake-utils";

    nur.url = "github:nix-community/NUR";

    impermanence.url = "github:nix-community/impermanence";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    nix-colors.url = "github:misterio77/nix-colors";

    hyprland.url = "github:hyprwm/hyprland";

    sops-nix.url = "github:mic92/sops-nix";

    sile.url = "github:sile-typesetter/sile/v0.14.3";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dnsblacklist = {
      url = "github:notracking/hosts-blocklists";
      flake = false;
    };

    seaweedfs.url = "github:/mitchty/nixos-seaweedfs/wip";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    #nixpkgs-najib,
    home-manager,
    hardware,
    flake-utils,
    nur,
    nix-colors,
    hyprland,
    sile,
    nixos-generators,
    dnsblacklist,
    seaweedfs,
    ...
  }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    in
    rec {

      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      # You can compose these into your own configuration by using my flake's overlay,
      # or comsume them through NUR.
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );

      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      # A couple project templates for different languages.
      # Accessible via `nix init`.
      templates = import ./templates;

      #hydraJobs = {
      #  packages = mapAttrs ...
      #  ...
      #};

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays;

      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;

      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # XXX: Me (Najib) try to include nixos-generators.
      isoSimple = nixos-generators.nixosGenerate {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          #./modules/iso/autoinstall.nix
          #simpleAutoinstall {
          #  autoinstall.debug = true;
          #}
          ./modules/iso/configuration.nix
        ];
        format = "install-iso";
      };

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {

        # Laptop Thinkpad X230
        khawlah = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            #./nixos/configuration-khawlah.nix
            ./nixos/host-khawlah.nix
          ];
        };

        # Laptop Dell Najib
        khadijah = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-khadijah.nix
          ];
        };

        # Laptop Thinkpad T400 (dalam bilik tidur)
        raudah = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-raudah.nix
          ];
        };

        # Laptop Thinkpad T400 (sebelah tv)
        mahirah = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-mahirah.nix
          ];
        };

        # Najib's Dell Desktop (formerly used as firewall/router; currently being use as TV/media player)
        delldesktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-delldesktop.nix
          ];
        };

        # Najib's Main Desktop
        customdesktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-customdesktop.nix
          ];
        };

        # Laptop Thinkpad T410 (with nvidia) Naim
        zahrah = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-zahrah.nix

            # Add your model from this list:
            # http://github.com/NixOS/nixos-hardware/blob/master/flake.nix
            hardware.nixosModules.lenovo-thinkpad-t410
            hardware.nixosModules.common-cpu-intel
            hardware.nixosModules.common-gpu-intel
            #hardware.nixosModules.common-gpu-nvidia
            #hardware.nixosModules.common-gpu-nvidia-disable.nix
            hardware.nixosModules.common-pc-laptop
            hardware.nixosModules.common-pc-ssd
          ];
        };

        # Laptop Thinkpad x220 Nur Nasuha
        sakinah = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-sakinah.nix

            # Add your model from this list:
            # http://github.com/NixOS/nixos-hardware/blob/master/flake.nix
            hardware.nixosModules.lenovo-thinkpad-x220
          ];
        };

        # Laptop Thinkpad T410 (without nvidia) Julia
        keira = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-keira.nix

            # Add your model from this list:
            # http://github.com/NixOS/nixos-hardware/blob/master/flake.nix
            hardware.nixosModules.lenovo-thinkpad-t410
          ];
        };

        # Laptop Thinkpad T61/R61 (dalam bilik tidur)
        maryam = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-maryam.nix
          ];
        };

      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {

        "najib@khawlah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-najib.nix
          ];
        };

        "najib@raudah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-najib.nix
          ];
        };

        "najib@customdesktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-najib.nix
          ];
        };

        "najib@khadijah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-najib.nix
          ];
        };

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

        "naim@zahrah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            #hyprland.homeManagerModules.default
            ./home-manager/home-naim.nix
          ];
        };

        "naim@khadijah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            #hyprland.homeManagerModules.default
            ./home-manager/home-naim.nix
          ];
        };

        "naqib@asmak" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-naqib.nix
          ];
        };

        "nurnasuha@sakinah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-nurnasuha.nix
          ];
        };

        "julia@keira" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-julia.nix
          ];
        };

      };
    };
}
