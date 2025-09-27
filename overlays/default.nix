# This file defines overlays
{inputs, ...}: {

  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};
  # additions = import ./additions.nix { inherit inputs; };      # Probably needs inputs

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
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

  };
  # modifications = import ./modifications.nix;                  # Probably doesn't need inputs

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
  # unstable-packages = import ./unstable-packages.nix { inherit inputs; };  # Definitely needs inputs

  #grafito = import ./grafito.nix;                              # Doesn't need inputs

  #nixvim = import ./nixvim.nix { inherit inputs; };            # Pass all inputs

}
