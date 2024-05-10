{
  users.users.abdullah = {
    description = "abdullah";
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    #packages = with pkgs; [
    #  firefox
    #  kate
    #];
  };
}
