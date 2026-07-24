# profiles/nixos/common/configuration.DESKTOP_FULL.nix

{
  config,
  pkgs,
  lib,
  ...
}:{

  imports = [
    ./configuration.DESKTOP_LITE.nix

    ./packages/android.nix
    ./packages/devtools.nix
    ./packages/games.nix
    ./packages/virtualization.nix
    ./packages/extras.nix
  ];

}
