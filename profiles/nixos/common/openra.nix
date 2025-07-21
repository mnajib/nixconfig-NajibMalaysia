{ pkgs, config, ... }: {

  #imports = [
  #  ./jupiternotebook.nix
  #];

  environment.systemPackages = with pkgs; [
    openra

    #openraPackages_2019.engines.bleed
    #openraPackages_2019.engines.playtest
    openraPackages_2019.engines.release
    openraPackages_2019.mods.ca         # OpenRA Red Alert and Tiberian Dawn mods
    openraPackages_2019.mods.d2         # A modernization of the original Dune II game
    openraPackages_2019.mods.dr         # A re-imagination of the original Command & Conquer: Dark Reign game
    openraPackages_2019.mods.gen        # Re-imagination of the original Command & Conquer: Generals game
    openraPackages_2019.mods.kknd       # Re-imagination of the original Krush, Kill 'n' Destroy game
    openraPackages_2019.mods.mw         # A re-imagination of the original Command & Conquer: Medieval Warfare game
    openraPackages_2019.mods.ra2        # Re-imagination of the original Command & Conquer: Red Alert 2 game
    openraPackages_2019.mods.raclassic  # A modernization of the original Command & Conquer: Red Alert game
    openraPackages_2019.mods.rv         # Re-imagination of the original Command & Conquer: Red Alert 2 game
    openraPackages_2019.mods.sp         # Re-imagination of the original Command & Conquer: Tiberian Sun game
    openraPackages_2019.mods.ss         # A re-imagination of the original Command & Conquer: Sole Survivor game
    openraPackages_2019.mods.ura        # Re-imagination of the original Command & Conquer: Red Alert game
    openraPackages_2019.mods.yr         # Re-imagination of the original Command & Conquer: Yuri's Revenge game
  ];
}
