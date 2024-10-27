#
# NOTES:
#
#  nix flake info                       # will show all inputs and what revision (or other flake's inputs) are being tracked!
#  nix flake show
#  nix flake update                     # will try to update all inputs where possible. Inputs pinned to specific revisions will, of course, remain pinned.
#  nix flake lock --update-input $NAME  # will only try to update the $NAME input.
#  nix flake check                      # is a great way to ensure that the entire flake configuration is up to snuff with a single invocation.
#  nix repl
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

    extra-substituters = [
      # Nix community's cache server
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    # Need to pass '--accept-nix-config' or accept them interactively.
    # Looks like the flag is '--accept-flake-config'.
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    #nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";   # TODO: use flake hub as much as possible
    #
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    #
    #fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";
    #nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2305.*.tar.gz";
    #
    # pkgs ? import <nixpkgs> {}
    # unstable-pkgs ? import <nixpkgs-unstable> {}
    # old-pkgs ? import <nixpkgs-23.05> {}
    # old-pkgs ? import <nixos-old> {}
    #

    # Set this up as an overlay; or pull-request (PR) it to nixpkgs.
    #nixpkgs-mitchty.url = "github:/mitchty/nixpkgs/mitchty";
    #nixpkgs-najib.url = "github:/mnajib/nixpkgs/najib";

    #systems = {
    #  url = "github:nix-systems/default-linux";
    #};

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";                   # Forcing another flake (github nix-community home-manager) to use one of our inputs (nixpkgs).
    };

    #nixos-mailserver = {
    #  url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #  inputs.nixpkgs-23_05.follows = "nixpkgs";
    #  inputs.nixpkgs-23_11.follows = "nixpkgs";
    #};

    # TODO: Add any other flake you might need
    #hardware.url = "github:nixos/nixos-hardware";
    hardware.url = "github:NixOS/nixos-hardware/master";
    #nixos-hardware.url = "github:NixOS/nixos-hardware";

    flake-utils.url = "github:numtide/flake-utils";

    nur.url = "github:nix-community/NUR";

    impermanence.url = "github:nix-community/impermanence";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    nix-colors.url = "github:misterio77/nix-colors";

    hyprland = {
      #url = "github:hyprwm/hyprland";
      url = "git+https://github.com/hyprwm/hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      #plugin_name = {
      #  url = "github:maintener/plugin_name";
      #  inputs.hyprland.follows = "hyprland";                 # IMPORTANT
      #}
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
      #inputs.nixpkgs.follows = "nixpkgs";                   # optional, not necessary for the module
      inputs.nixpkgs.follows = "nixpkgs-unstable";                   # optional, not necessary for the module
      inputs.nixpkgs-stable.follows = "nixpkgs";            # ???
    };

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

    #expose-cuda = {
    #  url = "github:ogoid/nixos-expose-cuda";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    kmonad = {
      url = "git+https://github.com/kmonad/kmonad?submodules=1&dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  }; # End 'inputs'.

  outputs = {
    self,
    #fh                                 # flakehub.com
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-unstable,
    #nixpkgs-najib,
    #systems,
    home-manager,

    hardware,
    #nixos-hardware,

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
    #expose-cuda,
    kmonad,
    ...
  }@inputs:
    let
      inherit (self) outputs;

      #lib = nixpkgs.lib // home-manager.lib;

      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Supported systems for your flake packages, shell, etc.
      #forAllSystems = nixpkgs.lib.genAttrs [
      #  "aarch64-linux"
      #  "i686-linux"
      #  "x86_64-linux"
      #  "aarch64-darwin"
      #  "x86_64-darwin"
      #];
      #
      #forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
      #pkgsFor = lib.genAttrs (import systems) (
      #  system:
      #    import nixpkgs {
      #      inherit system;
      #      config.allowUnfree = true;
      #    }
      #);
      #
      forEachSystem = nixpkgs.lib.genAttrs ["x86_64-linux"];
      forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});

      #pkgs = import nixpkgs {
      #  config.allowUnfree = true;
      #};
      #
      #pkgsUnstable = import nixpkgs-unstable {
      #  config.allowUnfree = true;
      #};

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

        #home-manager.useGlobalPkgs = true; # Use nixpkgs globally
        #home-manager.useUserPackages = true; # Use user-specific packages for this config

    in
    rec {

      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      # You can compose these into your own configuration by using my flake's overlay,
      # or comsume them through NUR.
      #packages = forAllSystems (system:
      #  let pkgs = nixpkgs.legacyPackages.${system};
      #  in import ./pkgs { inherit pkgs; }
      #);
      #
      # Also setup iso installs with nixos generators
      #packages = forEachPkgs (
      #  pkgs:
      #    (import ./pkgs {
      #      inherit pkgs;
      #    })
      #    //
      #    (import ./generators {
      #      inherit pkgs inputs outputs;
      #      specialArgs = {inherit inputs outputs;};
      #    })
      #);
      #
      packages.${system} = {
        default = pkgs.hello; # custom package ???
      };

      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      #devShells = forAllSystems (system:
      #  let pkgs = nixpkgs.legacyPackages.${system};
      #  in import ./shell.nix { inherit pkgs; }
      #);
      #
      devShells = forEachPkgs (
        pkgs:
          import ./shell.nix {
            inherit pkgs;
          }
      );

      # A couple project templates for different languages.
      # Accessible via `nix init`.
      #templates = import ./templates;

      formatter = forEachPkgs (pkgs: pkgs.alejandra);

      #hydraJobs = {
      #  packages = mapAttrs ...
      #  ...
      #};

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays {inherit inputs outputs;};

      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;

      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # Me (Najib) try to include nixos-generators.
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

        #----------------------------------------------------------------------
        # Laptop Thinkpad X230
        #khawlah = nixpkgs.lib.nixosSystem {
        #  specialArgs = { inherit inputs outputs; };
        #  system = "x86_64-linux";
        #  modules = [
        #    #./nixos/configuration-khawlah.nix
        #    ./nixos/host-khawlah.nix
        #  ];
        #};
        #
        khawlah = mkNixos [./nixos/host-khawlah.nix];

        #----------------------------------------------------------------------
        # Laptop Dell Najib
        #khadijah = nixpkgs.lib.nixosSystem {
        #  specialArgs = { inherit inputs outputs; };
        #
        #  #system = "x86_64-linux";
        #
        #  modules = [
        #    # system-wide doom-emacs
        #    #environment.systemPackages =
        #    #let
        #    #  doom-emacs = nix-doom-emacs.packages.${system}.default.override {
        #    #    doomPrivateDir = ./doom.d;
        #    #  };
        #    #in [
        #    #  doom-emacs
        #    #];environment.systemPackages =
        #    #let
        #    #  doom-emacs = nix-doom-emacs.packages.${system}.default.override {
        #    #    doomPrivateDir = ./doom.d;
        #    #  };
        #    #in [
        #    #  doom-emacs
        #    #];
        #
        #    #------------------------------------------------------------------
        #    # nix-ld
        #    # Ref:
        #    #   - https://github.com/Mic92/nix-ld
        #    #   - https://unix.stackexchange.com/questions/522822/different-methods-to-run-a-non-nixos-executable-on-nixos
        #    #------------------------------------------------------------------
        #    nix-ld.nixosModules.nix-ld
        #    #
        #    # The module in this repositiry defines a new module under
        #    # (prgrams.nix-ld.dev) instead of (programs.nix-ld) to not
        #    # collide with the nixpkgs version.
        #    { programs.nix-ld.dev.enable = true; }
        #    #
        #    # Usage: After setting up the nix-ld symlink as described above, one
        #    # needs to set NIX_LD and NIX_LD_LIBRARY_PATH to run executables.
        #    # For example, this can be done with a shell.nix in a nix-shell like this:
        #    #with import <nixpkgs> {};
        #    #mkShell {
        #    # NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
        #    #   stdev.cc.cc
        #    #   openssl
        #    #   #...
        #    # ]
        #    # NIX_LD = lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker";
        #    #}
        #    #------------------------------------------------------------------
        #
        #    #./machines/host-khadijah.nix
        #    ./nixos/host-khadijah.nix
        #
        #    #pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        #    #extraSpecialArgs = { inherit inputs outputs; };
        #    #home-manager.nixosModules.home-manager {
        #    #  home-manager = {
        #    #    useGlobalPkgs = true;
        #    #    useUserPackages = true;
        #    #    users.najib = import ./home-manager/home-najib.nix {
        #    #      inherit pkgs;
        #    #      inherit pkgsUnstable;
        #    #      inherit impermanence;
        #    #      inherit nur;
        #    #    };
        #    #  };
        #    #}
        #  ];
        #};
        #
        khadijah = mkNixos [
          nix-ld.nixosModules.nix-ld
          { programs.nix-ld.dev.enable = true; }
          ./nixos/host-khadijah.nix

          #{ environment.systemPackages = [ fh.packages.x86_64-linux.default ]; }
        ];

        #----------------------------------------------------------------------
        # Laptop Thinkpad T400 (dalam bilik tidur)
        raudah = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-raudah.nix
          ];
        };

        #----------------------------------------------------------------------
        # Laptop Thinkpad T400 (sebelah tv)
        mahirah = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-mahirah.nix
          ];
        };

        #----------------------------------------------------------------------
        # Najib's Dell Desktop (formerly used as firewall/router; currently being use as TV/media player)
        delldesktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-delldesktop.nix
          ];
        };

        #----------------------------------------------------------------------
        # Najib's Main Desktop
        #customdesktop = nixpkgs.lib.nixosSystem {
        #  specialArgs = { inherit inputs outputs; };
        #  modules = [
        #    ./nixos/host-customdesktop.nix
        #    sops-nix.nixosModules.sops
        #  ];
        #};
        customdesktop = mkNixos [
          ./nixos/host-customdesktop.nix
          sops-nix.nixosModules.sops
        ];

        #----------------------------------------------------------------------
        # Thinkpad Farid bagi, problem
        # dah baiki; keyboard, ram, ssd, screen
        #asmak = nixpkgs.lib.nixosSystem {
        #  specialArgs = { inherit inputs outputs; };
        #  modules = [
        #    ./nixos/host-asmak.nix
        #  ];
        #};
        asmak = mkNixos [
          ./nixos/host-asmak.nix
          #sops-nix.nixosModules.sops
        ];

        #----------------------------------------------------------------------
        # Laptop Thinkpad T410 (with nvidia) Naim
        #zahrah = nixpkgs.lib.nixosSystem {
        #  specialArgs = { inherit inputs outputs; };
        #  modules = [
        #    ./nixos/host-zahrah.nix
        #
        #    # Roferences:
        #    #   http://github.com/NixOS/nixos-hardware/blob/master/flake.nix
        #    hardware.nixosModules.lenovo-thinkpad-t410
        #    hardware.nixosModules.common-cpu-intel
        #    hardware.nixosModules.common-gpu-intel
        #    #hardware.nixosModules.common-gpu-nvidia
        #    #hardware.nixosModules.common-gpu-nvidia-disable
        #    #hardware.nixosModules.common-gpi-nvidia-nonprime
        #    #hardware.nixosModules.common-pc-laptop
        #    #hardware.nixosModules.common-pc-ssd
        #    hardware.nixosModules.common-pc-laptop-ssd
        #  ];
        #};
        zahrah = mkNixos [
          ./nixos/host-zahrah.nix

          # Roferences:
          #   http://github.com/NixOS/nixos-hardware/blob/master/flake.nix
          #hardware.nixosModules.lenovo-thinkpad-t410
          hardware.nixosModules.lenovo-thinkpad # zahrah on T400, after T410 having CPU error
          hardware.nixosModules.common-cpu-intel
          #hardware.nixosModules.common-gpu-intel
          #hardware.nixosModules.common-gpu-nvidia
          #hardware.nixosModules.common-gpu-nvidia-disable
          #hardware.nixosModules.common-gpi-nvidia-nonprime
          #hardware.nixosModules.common-pc-laptop
          #hardware.nixosModules.common-pc-ssd
          hardware.nixosModules.common-pc-laptop-ssd

          kmonad.nixosModules.default
        ];

        #----------------------------------------------------------------------
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

        #----------------------------------------------------------------------
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

        #----------------------------------------------------------------------
        # HP DeskPro
        #cheetah = nixpkgs.lib.nixosSystem {
        hidayah = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            #./nixos/host-cheetah.nix
            ./nixos/host-hidayah.nix

            nix-ld.nixosModules.nix-ld
            { programs.nix-ld.dev.enable = true; }

            # Add your model from this list:
            # http://github.com/NixOS/nixos-hardware/blob/master/flake.nix
            #hardware.nixosModules.lenovo-thinkpad-x220
          ];
        };

        #----------------------------------------------------------------------
        # Acer Aspire
        #leopard = nixpkgs.lib.nixosSystem {
        #taufiq = nixpkgs.lib.nixosSystem {
        #  specialArgs = { inherit inputs outputs; };
        #  modules = [
        #    #./nixos/host-leopard.nix
        #    ./nixos/host-taufiq.nix
        #
        #    nix-ld.nixosModules.nix-ld {
        #      programs.nix-ld.dev.enable = true;
        #    }
        #
        #    # Add your model from this list:
        #    # http://github.com/NixOS/nixos-hardware/blob/master/flake.nix
        #    #hardware.nixosModules.lenovo-thinkpad-x220
        #
        #    expose-cuda.nixosModules.default
        #  ]; # End 'modules'.
        #}; #End: taufiq = nixpkgs.lib.nixosSystem
        taufiq = mkNixos [
          ./nixos/host-taufiq.nix

          #sops-nix.nixosModules.sops

          nix-ld.nixosModules.nix-ld {
            programs.nix-ld.dev.enable = true;
          }

          # Add your model from this list:
          # http://github.com/NixOS/nixos-hardware/blob/master/flake.nix
          #hardware.nixosModules.lenovo-thinkpad-x220

          #expose-cuda.nixosModules.default
        ];

        #----------------------------------------------------------------------
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

            nix-ld.nixosModules.nix-ld
            { programs.nix-ld.dev.enable = true; }

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

        #----------------------------------------------------------------------
        # Laptop Thinkpad T61/R61 (dalam bilik tidur)
        maryam = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/host-maryam.nix
          ];
        };

        #----------------------------------------------------------------------
        # !!! test test test
        #----------------------------------------------------------------------
        #"najib@khawlah" = inputs.home-manager.lib.homeManagerConfiguration {
        #  pkgs = nixpkgs.legacyPackages.x86_64-linux;
        #  extraSpecialArgs = { inherit inputs outputs; };
        #  configuration = {
        #    "najib@khawlah" = mkHome [./home-manager/user-najib/host-khawlah] nixpkgs.legacyPackages.x86_64-linux;
        #  };
        #};
        #
        #"najib@customdesktop" = inputs.home-manager.lib.homeManagerConfiguration {
        #  pkgs = nixpkgs.legacyPackages.x86_64-linux;
        #  extraSpecialArgs = { inherit inputs outputs; };
        #  configuration = {
        #    "najib@customdesktop" = mkHome [./home-manager/user-najib/host-customdesktop] nixpkgs.legacyPackages.x86_64-linux;
        #  };
        #};
        #----------------------------------------------------------------------

      }; # End nixosConfigurations

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      #home-manager = inputs.home-manager.lib.homeManagerConfiguration { # XXX: Reserved for home-manager
      #hmConfigs = inputs.home-manager.lib.homeManagerConfiguration {
      #myHmConfigs = inputs.home-manager.lib.homeManagerConfiguration {
      #  pkgs = nixpkgs.legacyPackages.x86_64-linux;
      #  extraSpecialArgs = { inherit inputs outputs; };
      homeConfigurations = {
        #hmConfigs = {
        #configurations = {

        #----------------------------------------------------------------------
        #"najib@khawlah" = home-manager.lib.homeManagerConfiguration {
        #  pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        #  extraSpecialArgs = { inherit inputs outputs; };
        #  modules = [
        #    ./home-manager/home-najib.nix
        #  ];
        #};
        #
        #"najib@khawlah" = mkHome [./home-manager/home-najib.nix] nixpkgs.legacyPackages."x86_64-linux";
        "najib@khawlah" = mkHome [./home-manager/user-najib/host-khawlah] nixpkgs.legacyPackages."x86_64-linux";

        #----------------------------------------------------------------------
        "najib@raudah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-najib.nix
          ];
        };

        #----------------------------------------------------------------------
        "najib@zahrah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-najib.nix
          ];
        };

        #----------------------------------------------------------------------
        #"najib@customdesktop" = home-manager.lib.homeManagerConfiguration {
        #  pkgs = nixpkgs.legacyPackages.x86_64-linux;
        #  extraSpecialArgs = { inherit inputs outputs; };
        #  modules = [
        #    #./home-manager/home-najib.nix
        #    ./home-manager/user-najib/host-customdesktop/default.nix
        #  ];
        #};
        "najib@customdesktop" = mkHome [./home-manager/user-najib/host-customdesktop/default.nix] nixpkgs.legacyPackages."x86_64-linux";

        #----------------------------------------------------------------------
        #"najib@khadijah" = home-manager.lib.homeManagerConfiguration {
        #  pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        #  extraSpecialArgs = { inherit inputs outputs; };
        #  modules = [
        #    #./home-manager/home-najib.nix
        #    ./home-manager/user-najib/host-khadijah/default.nix
        #  ];
        #
        #  # Try setting up doom-emacs
        #  # Also look in home-najib.nix and emacs-doom.nix
        #  #imports = [ nix-doom-emacs.hmModule ];
        #  #programs.doom-emacs = {
        #  #  enable = true;
        #  #  doomPrivateDir = ./doom.d;                                          # Directory containing your config.el, init.el, and packages.el files
        #  #};
        #};
        #
        #"najib@khadijah" = mkHome [./home-manager/user-najib/host-khadijah/default.nix] nixpkgs.legacyPackages."x86_64-linux";
        "najib@khadijah" = mkHome [./home-manager/user-najib/host-khadijah] nixpkgs.legacyPackages."x86_64-linux";

        #----------------------------------------------------------------------
        "najib@maryam" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-najib.nix
          ];
        };

        #----------------------------------------------------------------------
        "najib@mahirah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-najib.nix
          ];
        };

        #----------------------------------------------------------------------
        "najib@delldesktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-najib.nix
          ];
        };

        #----------------------------------------------------------------------
        "root@customdesktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-root.nix
          ];
        };

        #----------------------------------------------------------------------
        #"naim@zahrah" = home-manager.lib.homeManagerConfiguration {
        #  pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        #  extraSpecialArgs = { inherit inputs outputs; };
        #  modules = [
        #    #hyprland.homeManagerModules.default
        #    ./home-manager/home-naim.nix
        #  ];
        #};
        "naim@zahrah" = mkHome [./home-manager/user-naim/host-zahrah] nixpkgs.legacyPackages."x86_64-linux";

        #----------------------------------------------------------------------
        "naim@khadijah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            #hyprland.homeManagerModules.default
            ./home-manager/home-naim.nix
          ];
        };

        #----------------------------------------------------------------------
        "naim@sakinah" = mkHome [./home-manager/user-naim/host-sakinah] nixpkgs.legacyPackages."x86_64-linux";

        #----------------------------------------------------------------------
        #"naqib@asmak" = home-manager.lib.homeManagerConfiguration {
        #  pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        #  extraSpecialArgs = { inherit inputs outputs; };
        #  modules = [
        #    ./home-manager/home-naqib.nix
        #  ];
        #};
        "naqib@asmak" = mkHome [./home-manager/user-naqib/host-asmak] nixpkgs.legacyPackages."x86_64-linux";

        #----------------------------------------------------------------------
        #"naqib@sakinah" = home-manager.lib.homeManagerConfiguration {
        #  pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        #  extraSpecialArgs = { inherit inputs outputs; };
        #  modules = [
        #    #./home-manager/home-naqib.nix
        #    ./home-manager/user-naqib/host-sakinah/default.nix
        #  ];
        #};
        "naqib@sakinah" = mkHome [./home-manager/user-naqib/host-sakinah] nixpkgs.legacyPackages."x86_64-linux";

        #----------------------------------------------------------------------
        "naqib@raudah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-naqib.nix
          ];
        };

        #----------------------------------------------------------------------
        "najib@asmak" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home-najib.nix
          ];
        };

        #----------------------------------------------------------------------
        "naqib@hidayah" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            #./home-manager/naqib-hidayah/default.nix
            ./home-manager/user-naqib/host-hidayah/default.nix
          ];
        };

        #----------------------------------------------------------------------
        #"nurnasuha@sakinah" = home-manager.lib.homeManagerConfiguration {
        #  pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        #  extraSpecialArgs = { inherit inputs outputs; };
        #  modules = [
        #    #./home-manager/home-nurnasuha.nix
        #    ./home-manager/user-nurnasuha/host-sakinah/default.nix
        #  ];
        #};
        "nurnasuha@sakinah" = mkHome [./home-manager/user-nurnasuha/host-sakinah] nixpkgs.legacyPackages."x86_64-linux";

        #----------------------------------------------------------------------
        "nurnasuha@customdesktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            #./home-manager/home-nurnasuha.nix
            ./home-manager/user-nurnasuha/host-customdesktop/default.nix
          ];
        };

        #----------------------------------------------------------------------
        "julia@keira" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            #./home-manager/home-julia.nix
            #./home-manager/julia-keira/default.nix
            ./home-manager/user-julia/host-keira/default.nix
          ];
        };

        #----------------------------------------------------------------------
        "julia@manggis" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            #./home-manager/home-julia.nix
            #./home-manager/julia-manggis/default.nix
            ./home-manager/user-julia/host-manggis/default.nix
          ];
        };

        #----------------------------------------------------------------------
        #"julia@taufiq" = home-manager.lib.homeManagerConfiguration {
        #  pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        #  extraSpecialArgs = { inherit inputs outputs; };
        #  modules = [
        #    #./home-manager/home-julia.nix
        #    #./home-manager/julia-taufiq/default.nix
        #    ./home-manager/user-julia/host-taufiq/default.nix
        #  ];
        #};
        "najib@taufiq"      = mkHome [./home-manager/user-najib/host-taufiq] nixpkgs.legacyPackages."x86_64-linux";
        "julia@taufiq"      = mkHome [./home-manager/user-julia/host-taufiq] nixpkgs.legacyPackages."x86_64-linux";
        "naqib@taufiq"      = mkHome [./home-manager/user-naqib/host-taufiq] nixpkgs.legacyPackages."x86_64-linux";
        "nurnasuha@taufiq"  = mkHome [./home-manager/user-nurnasuha/host-taufiq] nixpkgs.legacyPackages."x86_64-linux";
        "naim@taufiq"       = mkHome [./home-manager/user-naim/host-taufiq] nixpkgs.legacyPackages."x86_64-linux";

      }; # End homeConfiguration
      #}; # XXX:reserved for home-manager

    }; # End let ... in ... rec
}
