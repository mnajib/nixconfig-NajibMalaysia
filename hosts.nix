# hosts.nix
#
# nixosConfigurations: which host uses mkNixos, and with what per-host
# overrides (extraModules, pkgsInput, etc). Standalone home-manager
# entries (homeConfigurations, i.e. "user@host") live in homes.nix
# instead -- these are a different concern (per-machine vs per-user)
# even though both ultimately come from lib/builders.nix.
#
# `inputs`, `mkNixos` are passed in from flake.nix's `flake = let
# ... in { ... }` scope.
{
  inputs,
  mkNixos
}:
{
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
              users = [
                "najib"
                "naqib"
              ];
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
                inputs.hardware.nixosModules.common-cpu-intel
                inputs.hardware.nixosModules.common-pc-laptop-ssd
                inputs.stylix.nixosModules.stylix
                #inputs.disko.nixosModules.disko
              ];

              #
              # To test:
              #   nix eval .#nixosConfigurations.bawang.config.home-manager.users --apply builtins.attrNames   # patut [ ]
              #
              users = [ ]; # Zero need for 'lib.mkForce [ ]'.
              #
              # NOTE: mkForce, mkOverride, dan mkDefault hanya relevan untuk
              # opsyen modul NixOS atau modul home-manager (benda yang anda
              # set melalui services.x.y, home-manager.users.<nama>, dsb. —
              # yang boleh ditakrif oleh banyak modul serentak). Untuk
              # parameter fungsi biasa macam system, pkgsInput, hmInput,
              # extraModules, copyConfig, users dalam mkNixos — hanya tulis
              # nilai terus, sebab tiada sistem keutamaan (priority) yang perlu
              # dilawan.
              #

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

                # Bind your home-manager configuration to your user here:
                #inputs.home-manager.nixosModules.home-manager
                #{
                #  #home-manager.useGlobalPkgs = true;
                #  #home-manager.useUserPackages = true;
                #  #home-manager.extraSpecialArgs = { inherit inputs; };
                #  home-manager.users.najib = import ./profiles/home-manager/users/najib/nyxora;
                #}

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

              #
              #------------------------
              # NOTE:
              #
              # For:
              #   users = [
              #     "najib"
              #     "naqib"
              #   ];
              #
              # Run test:
              #   nix eval .#nixosConfigurations.asmak.config.home-manager.users --apply builtins.attrNames
              #
              # Result output:
              # [ "najib" "naqib" ]
              #------------------------
              #
              users = [
                "najib"
                "naqib"
              ];

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
              users = [
                "najib"
                "naqib"
              ];
            };

            # White gaming desktop pc currently being use by Naqib
            sumayah = mkNixos "sumayah" {
              users = [ "najib" "naqib" ];
            };

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
              users = [
                "najib"
                "naqib"
              ];
            };

  }; # End of 'nixosConfigurations = { ... };'
}
