# hash = "sha256-g+g1dNGiYPDQ6R/E8GEr4ejNQFItyZAycKCiT2YsgEw=";

# ./nixos/aic8800.nix

{ lib
, stdenv
, fetchFromGitHub
, kernel
, kernelModuleMakeFlags
, bc
}:

stdenv.mkDerivation {
  pname = "aic8800";
  version = "${kernel.version}-unstable-2025-06-25";

  src = fetchFromGitHub {
    owner = "goecho";
    repo = "aic8800_linux_drvier";
    rev = "6b5680d3605f34bfa84618f880a04a240749acc3";
    hash = "sha256-g+g1dNGiYPDQ6R/E8GEr4ejNQFItyZAycKCiT2YsgEw=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;
  makeFlags = kernelModuleMakeFlags;

  prePatch = ''
    substituteInPlace ./drivers/aic8800/Makefile \
      --replace-fail "/lib/modules" "${kernel.dev}/lib/modules" \
      --replace-fail '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/aic8800"

    # Patch: comment out conflicting defines
    substituteInPlace ./drivers/aic8800/aic8800_fdrv/rwnx_defs.h \
      --replace '#define IEEE80211_HE_PHY_CAP6_TRIG_MU_BEAMFORMER_FB' '// #define IEEE80211_HE_PHY_CAP6_TRIG_MU_BEAMFORMER_FB' \
      --replace '#define IEEE80211_HE_PHY_CAP6_TRIG_SU_BEAMFORMER_FB' '// #define IEEE80211_HE_PHY_CAP6_TRIG_SU_BEAMFORMER_FB' \
      --replace '#define IEEE80211_HE_PHY_CAP3_RX_HE_MU_PPDU_FROM_NON_AP_STA' '// #define IEEE80211_HE_PHY_CAP3_RX_HE_MU_PPDU_FROM_NON_AP_STA'

    # Try comment out PCI modules (if any)
    sed -i '/rwnx_pci.c/d' ./drivers/aic8800/Makefile
    sed -i '/rwnx_pci.o/d' ./drivers/aic8800/Makefile
  '';

  buildPhase = ''
    cd drivers/aic8800
    make
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/aic8800"
  '';

  installPhase = ''
    install -Dm644 *.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/aic8800"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Tenda AIC8800 USB WiFi driver";
    homepage = "https://github.com/goecho/aic8800_linux_drvier";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

