#nixos/tenda-usb-wifi-dongle.nix
{
  pkgs,
  config,
  lib,
  ...
}:
let
  #kernel = config.boot.kernelPackages.kernel;
  #kernelPackages = config.boot.kernelPackages.kernel;
  kernelPackages = config.boot.kernelPackages;
  #kernelPackages = pkgs.linuxPackages_6_12;

  #aic8800 = import ./aic8800.nix {
  #  inherit (pkgs) lib stdenv fetchFromGitHub bc;
  #  inherit kernel;
  #};
in
{

  boot.kernelModules = [
    #"8821cu" # usb wifi dongle. dah cuba, tak berjaya.
    #"8812au" # menyokong lebih banyak CU. Biasanya menyokong RTL8811CU, RTL8812AU, RTL8821CU
    #"aic8800_fdrv"
    "aic8800"
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    #rtl8821cu
    #rtl8812au
    #pkgs.linuxKernel.packages.linux_6_12.rtl8821cu
    #aic8800

    (pkgs.callPackage ./aic8800.nix {
      kernel = kernelPackages.kernel;
      kernelModuleMakeFlags = kernelPackages.kernel.makeFlags or [
        "KSRC=${kernelPackages.kernel.dev}/lib/modules/${kernelPackages.kernel.modDirVersion}/build"
      ];
    })

  ]; # End boot.extraModulePackages

  environment.systemPackages = with pkgs; [
    usbutils
    usb-modeswitch
    usb-modeswitch-data
  ];

}
