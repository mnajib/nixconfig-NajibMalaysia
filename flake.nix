#
# NOTES:
#
#  nix flake show
#

{
  description = "Najib new NixOS configuration with flakes";

  nixConfig = {
    #experimental-features = [ "nix-command" "flakes" ];

    #substituters = [
    #  # Replace the official cache with a mirror located in China
    #  #"https://mirrors.ustc.edu.cn/nix-channels/store"
    #  "https://cache.nixos.org/"
    #];

    #extra-substituters = [
    #  # Nix community's cache server
    #  "https://nix-community.cachix.org"
    #];

    #extra-trusted-public-keys = [
    #  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #];
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    #
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    # Set this up as an overlay; or pull-request (PR) it to nixpkgs.
    #nixpkgs-mitchty.url = "github:/mitchty/nixpkgs/mitchty";
    #nixpkgs-najib.url = "github:/mnajib/nixpkgs/najib";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Add any other flake you might need
    #hardware.url = "github:nixos/nixos-hardware";
    hardware.url = "github:NixOS/nixos-hardware/master";

    flake-utils.url = "github:numtide/flake-utils";

    nur.url = "github:nix-community/NUR";

    impermanence.url = "github:nix-community/impermanence";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    nix-colors.url = "github:misterio77/nix-colors";

    hyprland.url = "github:hyprwm/hyprland";

    sops-nix.url = "github:mic92/sops-nix";
    #inputs.sops-nix.inputs.nixpkps.follows = "nixpkgs";        # optional, not necessary for the module

    #sile.url = "github:sile-typesetter/sile/v0.14.3";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
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
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-unstable,
    #nixpkgs-najib,
    home-manager,
    hardware,
    flake-utils,
    nur,
    impermanence,
    nix-colors,
    hyprland,
    #sile,
    nixos-generators,
    dnsblacklist,
    seaweedfs,
    sops-nix,
    nix-doom-emacs,
    nix-ld,
    ...
  }@inputs:
    let
      inherit (self) outputs;

      # Supported systems for your flake packages, shell, etc.
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      pkgs = import nixpkgs {
        config.allowUnfree = true;
      };

      pkgsUnstable = import nixpkgs-unstable {
        config.allowUnfree = true;
      };
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
      #templates = import ./templates;

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
      #isoSimple = nixos-generators.nixosGenerate {
      #  pkgs = nixpkgs.legacyPackages.x86_64-linux;
      #  modules = [
      #    #./modules/iso/autoinstall.nix
      #    #simpleAutoinstall {
      #    #  autoinstall.debug = true;
      #    #}
      #    ./modules/iso/configuration.nix
      #  ];
      #  format = "install-iso";
      #};

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {

        # Laptop Thinkpad X230
        khawlah = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          system = "x86_64-linux";
          modules = [
            #./nixos/configuration-khawlah.nix
            ./nixos/host-khawlah.nix
          ];
        };

        # Laptop Dell Najib
        khadijah = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };

          #system = "x86_64-linux";

          modules = [
            # system-wide doom-emacs
            #environment.systemPackages =
            #let
            #  doom-emacs = nix-doom-emacs.packages.${system}.default.override {
            #    doomPrivateDir = ./doom.d;
            #  };
            #in [
            #  doom-emacs
            #];environment.systemPackages =
            #let
            #  doom-emacs = nix-doom-emacs.packages.${system}.default.override {
            #    doomPrivateDir = ./doom.d;
            #  };
            #in [
            #  doom-emacs
            #];

            #------------------------------------------------------------------
            # nix-ld
            # Ref:
            #   - https://github.com/Mic92/nix-ld
            #   - https://unix.stackexchange.com/questions/522822/different-methods-to-run-a-non-nixos-executable-on-nixos
            #------------------------------------------------------------------
            nix-ld.nixosModules.nix-ld
            #
            # The module in this repositiry defines a new module under
            # (prgrams.nix-ld.dev) instead of (programs.nix-ld) to not
            # collide with the nixpkgs version.
            { programs.nix-ld.dev.enable = true; }
            #
            # Usage: After setting up the nix-ld symlink as described above, one
            # needs to set NIX_LD and NIX_LD_LIBRARY_PATH to run executables.
            # For example, this can be done with a shell.nix in a nix-shell like this:
            #with import <nixpkgs> {};
            #mkShell {
            # NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
            #   stdev.cc.cc
            #   openssl
            #   #...
            # ]
            # NIX_LD = lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker";
            #}
            #------------------------------------------------------------------

            #./machines/host-khadijah.nix
            ./nixos/host-khadijah.nix

            #pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
            #extraSpecialArgs = { inherit inputs outputs; };
            #home-manager.nixosModules.home-manager {
            #  home-manager = {
            #    useGlobalPkgs = true;
            #    useUserPackages = true;
            #    users.najib = import ./home-manager/home-najib.nix {
            #      inherit pkgs;
            #      inherit pkgsUnstable;
            #      inherit impermanence;
            #      inherit nur;
            #    };
            #  };
            #}
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
            sops-nix.nixosModules.sops
          ];
        };

        asmak = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-asmak.nix
          ];
        };

        # Laptop Thinkpad T410 (with nvidia) Naim
        zahrah = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-zahrah.nix

            # Roferences:
            #   http://github.com/NixOS/nixos-hardware/blob/master/flake.nix
            hardware.nixosModules.lenovo-thinkpad-t410
            hardware.nixosModules.common-cpu-intel
            hardware.nixosModules.common-gpu-intel
            #hardware.nixosModules.common-gpu-nvidia
            #hardware.nixosModules.common-gpu-nvidia-disable
            #hardware.nixosModules.common-gpi-nvidia-nonprime
            #hardware.nixosModules.common-pc-laptop
            #hardware.nixosModules.common-pc-ssd
            hardware.nixosModules.common-pc-laptop-ssd
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

        # Laptop Thinkpad x220 Julia
        manggis = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-manggis.nix

            # Add your model from this list:
            # http://github.com/NixOS/nixos-hardware/blob/master/flake.nix
            hardware.nixosModules.lenovo-thinkpad-x220
          ];
        };

        # Laptop Thinkpad T410 (without nvidia) Julia
        keira = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          system = "x86_64-linux";
          #system = nixpkgs.hostPlatform;
          modules = [
            ./nixos/host-keira.nix

            # Add your model from this list:
            # http://github.com/NixOS/nixos-hardware/blob/master/flake.nix
            hardware.nixosModules.lenovo-thinkpad-t410

            #home-manager.nixosModules.home-manager {
            #  home-manager = {
            #    useGlobalPkgs = true;
            #    useUserPackages = true;
            #    users.najib = import ./home-manager/home-najib.nix {
            #      inherit pkgs;
            #      inherit pkgsUnstable;
            #      inherit impermanence;
            #      inherit nur;
            #    };
            #    users.julia = import ./home-manager/home-julia.nix {
            #      inherit pkgs;
            #      inherit pkgsUnstable;
            #      inherit impermanence;
            #      inherit nur;
            #    };
            #  };
            #}
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

        "najib@zahrah" = home-manager.lib.homeManagerConfiguration {
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

          # Try setting up doom-emacs
          # Also look in home-najib.nix and emacs-doom.nix
          #imports = [ nix-doom-emacs.hmModule ];
          #programs.doom-emacs = {
          #  enable = true;
          #  doomPrivateDir = ./doom.d;                                          # Directory containing your config.el, init.el, and packages.el files
          #};
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

        "naqib@raudah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-naqib.nix
          ];
        };

        "najib@asmak" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-najib.nix
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

        "julia@manggis" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-julia.nix
          ];
        };

      };
    };
}
