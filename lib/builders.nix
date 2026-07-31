# lib/builders.nix
#
# Builder functions used to construct `nixosConfigurations` and
# `homeConfigurations` entries in flake.nix:
#   - mkPkgsCommon : consistent `pkgs` set (overlays + config), shared by
#                    both the NixOS and standalone home-manager paths
#   - mkNixos      : builds a nixosConfigurations.<host> entry, with
#                    home-manager embedded via the NixOS module
#   - mkHome       : builds a homeConfigurations."<user>@<host>" entry,
#                    for standalone (non-NixOS) home-manager use
#
# Kept separate from flake.nix so flake.nix itself stays focused on
# "wiring" (inputs -> outputs: which host uses which builder, with which
# overrides) rather than on how the builders work internally.
#
# `inputs` and `self` are passed in explicitly from flake.nix's `flake = let
# ... in { ... }` scope, since this file has no access to flake-parts'
# special args on its own.
{ inputs, self }:

let
  inherit (self) outputs;

  # Shared helper: the one path expression for a user's home-manager
  # profile, used by BOTH mkNixos (embedded HM) and mkHome (standalone HM)
  # so there's exactly one place that defines this convention.
  #
  # NOTE: `../` here because this file lives in `lib/`, one level below
  # the flake root -- unlike the old inline version in flake.nix, which
  # used `./.` (flake root itself).
  homeProfilePath = user: hostName:
    ../profiles/home-manager/users/${user}/${hostName};

  hostProfilePath = hostName:
    ../profiles/nixos/hosts/${hostName}/configuration.nix;

  # Shared helper to create a consistent pkgs set and stay DRY (Don't Repeat Yourself)
  mkPkgsCommon =
    {
      system,
      pkgsInput,
      extraConfig ? { },
    }:
    let
      lib = pkgsInput.lib;
      baseConfig = {
        allowUnfree = true;
        android_sdk.accept_license = true;
        nvidia.acceptLicense = true;
        pulseaudio = true;
        xsane.libusb = true;
      };
    in
    import pkgsInput {
      inherit system;
      overlays = builtins.attrValues self.overlays;
      config = lib.recursiveUpdate baseConfig extraConfig;
    };

  mkNixos = hostName: {
    system ? "x86_64-linux",
    pkgsInput ? inputs.nixpkgs,
    hmInput ? inputs.home-manager,
    extraModules ? [ ],
    copyConfig ? true,
    users ? [ ], #[ "najib" ], # Accepts a list of users, defaulting to just me
  }:
    let
      lib = pkgsInput.lib;

      # FIX THE INPUT LEAK: mask the default `inputs.nixpkgs` with the
      # active `pkgsInput` so no module -- NixOS or home-manager --
      # accidentally pulls a different nixpkgs than the one this host
      # was actually built with. Defined once, reused in both
      # specialArgs (NixOS modules) and extraSpecialArgs (HM modules).
      patchedInputs = inputs // { nixpkgs = pkgsInput; };
      commonSpecialArgs = {
        inputs = patchedInputs;
        inherit outputs hmInput self;
      };

      # Resolve home-manager profiles UP FRONT, outside the module system,
      # instead of via `mkIf (pathExists ...) (import ...)` inside
      # `home-manager.users`. This means a profile dir that doesn't exist
      # (e.g. because it was never `git add`-ed, so the flake's
      # git-tracked source can't see it) is reported via `lib.warn`, not
      # silently dropped.
      /*
      userProfiles =
        let
          resolve = user:
            let
              path = homeProfilePath user hostName;
              exists = builtins.pathExists path;
            in
              if exists
              then { name = user; value = import path; }
              else
                lib.warn
                  "mkNixos '${hostName}': no home-manager profile at ${toString path} for user '${user}' (skipped -- check `git add` if the dir exists on disk)"
                  null;
          resolved = map resolve users;
        in
          builtins.listToAttrs (builtins.filter (r: r.value != null) resolved);
      */
    in
    lib.nixosSystem {
      inherit system;
      specialArgs = commonSpecialArgs;

      modules = [

        # LOCK THE PACKAGE SET:
        # Use your DRY mkPkgsCommon helper. By setting nixpkgs.pkgs, NixOS will use THIS exact
        # evaluation, guaranteeing parity with your standalone Home Manager configs.
        {
          nixpkgs.pkgs = mkPkgsCommon {
            inherit system pkgsInput;
          };
        }

        # Auto-resolve the host config path
        # NOTE: `../` here, same reason as `homeProfilePath` above.
        (../profiles/nixos/hosts/${hostName}/configuration.nix)
        #(../profiles/nixos/hosts/sumayah/configuration.nix) # XXX: test debug

        # Inject the home-manager NixOS module automatically for ALL hosts.
        # NOTE: don't also add this in a host's `extraModules` -- it's
        # already here, unconditionally, for every host.
        hmInput.nixosModules.home-manager

        {
          home-manager = #let
            #userImport = user: import (./. + "/${hmDir}/${user}/${hostName}");
            #userImport = user: import ( homeProfilePath user hostName );
          #in
          {
            useGlobalPkgs = true; # Reuse system pkgs to save evalution RAM/Time
            useUserPackages = true;
            backupFileExtension = "backup";

            # Apply the same patched inputs to Home Manager
            extraSpecialArgs = commonSpecialArgs;

            # Pre-resolved above (see `userProfiles`): only users
            # whose profile dir actually exists get in here.
            #
            #users = userProfiles;
            #
            #users = pkgsInput.lib.genAttrs users (user:
            #  let
            #    userPath = ./. + "../profiles/home-manager/users/${user}/${hostName}";
            #  in
            #    pkgsInput.lib.mkIf (builtins.pathExists userPath) (import userPath)
            #    #import userPath
            #);
            #
            #users = {
            #  najib = userImport "najib";
            #  naqib = userImport "naqib";
            #};
            #
            # STATUS: TESTED, WORKING GOOD
            users = {
              najib = import (homeProfilePath "najib" hostName);
              naqib = import (homeProfilePath "naqib" hostName);
            };

          };
        }

        {
          environment.systemPackages = [
            hmInput.packages.${system}.default
          ];
        }

        {
          # Copy physical files ONLY if copyConfig is true
          # to /etc/current-system-flake/
          environment.etc."current-system-flake" = lib.mkIf copyConfig {
            source = self;
          };

          # Embed Git commit revision
          system.configurationRevision = lib.mkIf (self ? rev || self ? dirtyRev)
            (self.rev or self.dirtyRev);
        }

      ] ++ extraModules;

    };

  #
  # Standalone Home Manager Builder (For non-NixOS environments if needed)
  #
  #   When evaluating a standalone Home Manager profile (for non-NixOS
  #   hosts or direct user builds), `extraSpecialArgs` is passed
  #   directly at the top level of `homeManagerConfiguration`.
  #
  #   NOTE (opinion, not applied): unlike `mkNixos`, this does NOT mask
  #   `inputs.nixpkgs` with `pkgsInput`. Today that's harmless since your
  #   user profiles reference `pkgs` / named inputs like `inputs.my-nvim`
  #   directly, not `inputs.nixpkgs`. But it means mkNixos and mkHome are
  #   inconsistent in what `inputs` looks like inside a module -- worth
  #   deciding on consciously if a shared `profiles/home-manager/common/*.nix`
  #   module ever reaches for `inputs.nixpkgs` directly.
  #
  mkHome = userName: hostName: {
      system ? "x86_64-linux",
      pkgsInput ? inputs.nixpkgs,
      hmInput ? inputs.home-manager,
      extraModules ? [ ],
  }:
    hmInput.lib.homeManagerConfiguration {
      pkgs = mkPkgsCommon { inherit system pkgsInput; };

      extraSpecialArgs = { inherit inputs outputs self; }; # Injects inputs into standalone user profile modules.

      modules = [
        (homeProfilePath userName hostName)
      ] ++ extraModules;

    };

in
{
  inherit homeProfilePath mkPkgsCommon mkNixos mkHome;
}
