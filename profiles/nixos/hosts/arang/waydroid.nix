# waydroid.nix


#
# NOTE:
#
# For a clean version with Google Play Store support:
#   sudo waydroid init -s GAPPS -f
#
# To tart the full Android UI:
#   waydroid show-full-ui
#
# To install an Android app directly from an .apk file:
#   waydroid app install /path/to/app.apk
#
# To launch a specific app standalone from your terminal:
#   waydroid app launch <application.package.name>
#


{ config, pkgs, ... }: {

  # Enable Waydroid container infrastructure
  virtualisation.waydroid.enable = true;

  # Ensure Waydroid uses the nftables package variant to prevent network failures
  virtualisation.waydroid.package = pkgs.waydroid-nftables;

  # Recommended: Enable clipboard sharing between host and Android container
  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];

}
