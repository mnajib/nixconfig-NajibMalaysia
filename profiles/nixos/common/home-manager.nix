{ inputs, ... }: {
  imports = [ inputs.home-manager.nixosModules.default ];
  home-manager = {
    backupFileExtension = "backup";
    #backupCommand = "";
    overwriteBackup = true;
  };
}
