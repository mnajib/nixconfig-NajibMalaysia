# ./overlays/default.nix
# This file defines overlays
#
# ── WHAT AN OVERLAY ACTUALLY DOES ──────────────────────────────────────
# An overlay is a function: final: prev: { ... }
#   - `prev`  = pkgs BEFORE this overlay is applied (previous layer)
#   - `final` = pkgs AFTER ALL overlays are applied (the final, fully
#               resolved set -- lets overlays reference each other/
#               override things other overlays also touch)
#
# Overlays do NOTHING by themselves. This file only *defines* them as an
# attrset of functions. Something else must actually APPLY them to a
# `pkgs` instantiation via `nixpkgs.overlays = [ ... ];` (NixOS module)
# or `import nixpkgs { overlays = [ ... ]; }` (raw). In this repo, that
# application happens inside `mkPkgsCommon` in lib/builders.nix.
#
# ── CONSEQUENCE: pkgs is NOT one single global thing ───────────────────
# Every place `pkgs` gets constructed independently (a NixOS host, a
# standalone home-manager config, `nix repl`, `nixpkgs.nix`'s bootstrap
# shell) is its OWN instantiation. If that particular construction site
# doesn't pass this overlay list in, pkgs.orilla-run won't exist THERE,
# even though it works fine on hosts that do apply it. "Did I get the
# overlay applied here?" is a real, per-call-site question -- see the
# examples at the bottom of this file's companion notes.
{inputs, ...}: {

  # This one brings our custom packages from the 'pkgs' directory
  #
  # ── WITH this overlay applied ──────────────────────────────────────
  #   pkgs.orilla-run, pkgs.mySeaweedfsPackage, pkgs.myNixvimPackage
  #   are all just... there. Same as pkgs.vim. Usable in:
  #     environment.systemPackages = with pkgs; [ orilla-run vim ];
  #     home.packages              = with pkgs; [ orilla-run vim ];
  #     any module doing `pkgs.callPackage` on something that itself
  #       depends on orilla-run
  #
  # ── WITHOUT this overlay applied ───────────────────────────────────
  #   pkgs.orilla-run -> `error: attribute 'orilla-run' missing`
  #   You'd have to import ../pkgs yourself at every call site:
  #     let myPkgs = import ../../pkgs { inherit pkgs; };
  #     in environment.systemPackages = [ myPkgs.orilla-run ] ++ (with pkgs; [ vim ]);
  #   -- exactly the per-host boilerplate this overlay exists to avoid.
  additions = final: _prev: import ../pkgs {pkgs = final;};
  # additions = import ./additions.nix { inherit inputs; };      # Probably needs inputs

  # This one contains whatever you want to overlay
  # This one contains general inline modifications
  # Inline modifications can stay here if small, no need separate file.
  #
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  #
  # ── WITH vs WITHOUT, same shape as `additions` above ───────────────
  # e.g. if you uncommented the wezterm-nightly block below: WITH this
  # overlay applied, `pkgs.wezterm-nightly` exists as a normal package
  # name anywhere pkgs is used. WITHOUT it, that name simply doesn't
  # exist -- there's no fallback/manual-import equivalent for
  # `overrideAttrs`-based tweaks like this one; you'd have to inline
  # the whole overrideAttrs call at each use site instead.
  modifications = final: prev: {

    # wezterm-nightly = prev.wezterm.overrideAttrs (oldAttrs: rec {
    #   version = "main";
    #
    #   src = prev.fetchFromGitHub {
    #     owner = "wez";
    #     repo = "wezterm";
    #     rev = "600652583594e9f6195a6427d1fabb09068622a7";
    #     hash = "";
    #   };
    #
    #   cargoDeps = oldAttrs.cargoDeps.overrideAttrs (prev.lib.const {
    #     name = "wezterm.tar.gz";
    #     inherit src;
    #     outputHash = "";
    #   });
    # });

    #nixvim = prev.callPackage nixvim.packages.${prev.system}.default { };

    #qemu = import ./qemu-without-ceph-varian2.nix { inherit inputs final prev; };

  };
  # modifications = import ./modifications.nix;                  # Probably doesn't need inputs

  # QEMU overlay passing the flake inputs
  qemu-without-ceph = import ./qemu-without-ceph-variant1.nix { inherit inputs; };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  #
  # ── Different flavor of "without" here ─────────────────────────────
  # Even WITH this overlay applied, `pkgs.unstable.<name>` is a SEPARATE
  # nested pkgs tree (a whole extra nixpkgs evaluation), not a name
  # merged into the top-level `pkgs.*` namespace like `additions` does.
  # So: `with pkgs; [ orilla-run ]` works (flat merge), but
  # `with pkgs; [ unstable.somePackage ]` does NOT -- you must write
  # `pkgs.unstable.somePackage` explicitly, `with` doesn't reach nested
  # attrsets like that.
  unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
  # unstable-packages = import ./unstable-packages.nix { inherit inputs; };  # Definitely needs inputs

  #grafito = import ./grafito.nix;                              # Doesn't need inputs

  #nixvim = import ./nixvim.nix { inherit inputs; };            # Pass all inputs

  #flatpak-quick-fix = import ./flatpak.nix;

  #proxmox-nixos = import ./proxmox-nixos.nix { inherit inputs; };

  #nix-minecraft = import ./nix-minecraft.nix;

  #prismlauncher-version-fix = import ./prismlauncher.nix;

}
