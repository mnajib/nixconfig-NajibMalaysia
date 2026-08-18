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

  # Shared helper for file path discovery
  #
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

    users ? [ "najib" ], # Accepts a list of users. Empty by default -- a host
    #users ? [ ], # Accepts a list of users. Empty by default. A host with no `users = [...]` override gets NO home-manager users at all, rather than silently defaultingto najib.

  }:
    let
      lib = pkgsInput.lib;

      # TYPE SAFETY ASSERTIONS (Solves Trade-off #3)
      assertHostName = lib.assertMsg (builtins.isString hostName)
        "mkNixos Error: 'hostName' must be a string, got ${builtins.typeOf hostName}.";
      assertSystem = lib.assertMsg (builtins.isString system)
        "mkNixos Error: 'system' for host '${toString hostName}' must be a string.";
      assertUsers = lib.assertMsg (builtins.isList users)
        "mkNixos Error: 'users' for host '${toString hostName}' must be a list of user strings.";

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

      # Resolve home-manager profiles up front with warnings for uncommitted paths
      # Resolve home-manager profiles UP FRONT, outside the module system,
      # instead of via `mkIf (pathExists ...) (import ...)` inside
      # `home-manager.users`. This means a profile dir that doesn't exist
      # (e.g. because it was never `git add`-ed, so the flake's
      # git-tracked source can't see it) is reported via `lib.warn`, not
      # silently dropped.
      #
      #--------------------------------
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
      #--------------------------------
      #
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

    in
    assert assertHostName;
    assert assertSystem;
    assert assertUsers;
    lib.nixosSystem {
      inherit system;
      specialArgs = commonSpecialArgs;

      modules = [

        # Lock package set across NixOS and Home Manager
        # LOCK THE PACKAGE SET:
        # Use your DRY mkPkgsCommon helper. By setting nixpkgs.pkgs, NixOS will use THIS exact
        # evaluation, guaranteeing parity with your standalone Home Manager configs.
        {
          nixpkgs.pkgs = mkPkgsCommon {
            inherit system pkgsInput;
          };
        }

        # Auto-resolve the host configuration path
        # NOTE: `../` here, same reason as `homeProfilePath` above.
        (hostProfilePath hostName)

        # Inject Home Manager module
        # Inject the home-manager NixOS module automatically for ALL hosts.
        # NOTE: don't also add this in a host's `extraModules` -- it's
        # already here, unconditionally, for every host.
        hmInput.nixosModules.home-manager

        {
          home-manager = {
            useGlobalPkgs = true; # Reuse system pkgs to save evalution RAM/Time
            useUserPackages = true;
            backupFileExtension = "backup";

            # Apply the same patched inputs to Home Manager
            extraSpecialArgs = commonSpecialArgs;

            # Pre-resolved above (see `userProfiles`): only users
            # whose profile dir actually exists get in here.
            users = userProfiles;
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
    let
      lib = pkgsInput.lib;

      # TYPE SAFETY ASSERTIONS (Solves Trade-off #3)
      assertUser = lib.assertMsg (builtins.isString userName)
        "mkHome Error: 'userName' must be a string, got ${builtins.typeOf userName}.";
      assertHost = lib.assertMsg (builtins.isString hostName)
        "mkHome Error: 'hostName' must be a string, got ${builtins.typeOf hostName}.";

      # Input masking parity with mkNixos
      patchedInputs = inputs // { nixpkgs = pkgsInput; };
      commonSpecialArgs = {
        inputs = patchedInputs;
        inherit outputs self;
      };
    in
    assert assertUser;
    assert assertHost;
    hmInput.lib.homeManagerConfiguration {
      pkgs = mkPkgsCommon { inherit system pkgsInput; };

      #extraSpecialArgs = { inherit inputs outputs self; }; # Injects inputs into standalone user profile modules.
      extraSpecialArgs = commonSpecialArgs;

      modules = [
        (homeProfilePath userName hostName)
      ] ++ extraModules;

    };

in
{
  inherit homeProfilePath hostProfilePath mkPkgsCommon mkNixos mkHome;
}
