{ inputs, ... }: {
  #imports = [ inputs.home-manager.nixosModules.default ]; # commented here because already imported in mkNixos
  home-manager = {
    backupFileExtension = "backup";
    #backupCommand = "";
    overwriteBackup = true;
  };
}
