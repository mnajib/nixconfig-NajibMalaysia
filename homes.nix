# homes.nix
#
# homeConfigurations: standalone home-manager entries, keyed as
# "user@host", built via mkHome. This is separate from hosts.nix
# (nixosConfigurations) because it's a different concern -- edited when
# a person's account changes, not when a machine's hardware/system
# config changes -- even though both ultimately come from
# lib/builders.nix.
#
# NOTE: for hosts where home-manager is already embedded via mkNixos
# (see hosts.nix + lib/builders.nix), an entry here is a standalone
# fallback/alternative activation path for that user@host, not the
# primary one. See the mkForce/users.users bug fixed earlier in
# nyxora's case for why running both paths on the same host needs care
# (backupFileExtension, stale $PATH, etc).
#
# `inputs`, `mkHome` are passed in from flake.nix's `flake = let
# ... in { ... }` scope.
{ inputs, mkHome }:
{
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

            #-----------------------------------------------------------------------------
            # najib
            #-----------------------------------------------------------------------------
            "najib@sumayah" = mkHome "najib" "sumayah" {
              #system = "x86_64-linux";
              #modules = [ ./profiles/home-manager/users/najib/sumayah ];
              #pkgsInputs = inputs.nixpkgs-release;
              #pkgsInputs = inputs.nixpkgs-unstable;
            };
            "najib@taufiq" = mkHome "najib" "taufiq" {};
            "najib@huda" = mkHome "najib" "huda" {};
            "najib@bawang" = mkHome "najib" "bawang" {};
            "najib@maryam" = mkHome "najib" "maryam" {};
            "najib@customdesktop" = mkHome "najib" "customdesktop" {};
            "najib@asmak" = mkHome "najib" "asmak" {};
            "najib@zahrah" = mkHome "najib" "zahrah" {};
            "najib@khawlah" = mkHome "najib" "khawlah" {};
            "najib@keira" = mkHome "najib" "keira" {};
            "najib@nyxora" = mkHome "najib" "nyxora" {
              #modules = [
              extraModules = [
                #./profiles/home-manager/users/najib/nyxora
              ];
              #pkgsInputs = inputs.nixpkgs-release; # override
              #pkgsInputs = inputs.nixpkgs-unstable; # override
            };
            "najib@manggis" = mkHome "najib" "manggis" {};
            "najib@parang" = mkHome "najib" "parang" {};
            "najib@raudah" = mkHome "najib" "raudah" {};

            #-----------------------------------------------------------------------------
            # root
            #-----------------------------------------------------------------------------
            "root@taufiq" = mkHome "root" "taufiq" {
              #pkgsInputs = inputs.nixpkgs-release;
            };

            #-----------------------------------------------------------------------------
            # julia
            #-----------------------------------------------------------------------------
            "julia@manggis" = mkHome "julia" "manggis" {};
            "julia@keira" = mkHome "julia" "keira" {};

            #-----------------------------------------------------------------------------
            # nurnasuha
            #-----------------------------------------------------------------------------
            "nurnasuha@manggis" = mkHome "nurnasuha" "manggis" {};
            "nurnasuha@asmak" = mkHome "nurnasuha" "asmak" {};

            #-----------------------------------------------------------------------------
            # naqib
            #-----------------------------------------------------------------------------
            "naqib@sumayah" = mkHome "naqib" "sumayah" {
              #system = "x86_64-linux";
              #extraModules = [
              #  #./profiles/home-manager/users/naqib/sumayah
              #  # Ensure this line is present here so it builds for the naqib user!
              #  #inputs.mc-project.homeModules.minecraft-client
              #];
            };

            "naqib@huda" = mkHome  "naqib" "huda" {
              #system = "x86_64-linux";
              #modules = [ ./profiles/home-manager/users/naqib/huda ];
            };

            "naqib@laila" = mkHome "naqib" "laila" {};
            "naqib@sukun" = mkHome "naqib" "sukun" {};
            "naqib@parang" = mkHome "naqib" "parang" {};
            "naqib@asmak" = mkHome "naqib" "asmak" {};
            "naqib@zahrah" = mkHome "naqib" "zahrah" {};
            "naqib@raudah" = mkHome "naqib" "raudah" {};
            "naqib@taufiq" = mkHome "naqib" "taufiq" {};

            #-----------------------------------------------------------------------------
            # naim
            #-----------------------------------------------------------------------------
            "naim@manggis" = mkHome "naim" "manggis" {};
            "naim@keira" = mkHome "naim" "keira" {};
            "naim@huda" = mkHome "naim" "huda" {};

  }; # End of 'homeConfigurations = { ... };'
}
