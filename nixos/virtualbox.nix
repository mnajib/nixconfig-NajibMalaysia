{
    virtualisation.virtualbox.host.enable = true;

    # Oracle VirtualBox Extentions are required if you want to 
    # forward usb2 or usb3 to your guests. The Extensions are unfree.
    # Host extensions cause frequent recompilation.
    #nixpkgs.config.allowUnfree = true;
    #virtualisation.virtualbox.host.enableExtensionPack = true; 

    # XXX:
    #environment.systemPackages = with pkgs; [
    #    virtualboxWithExtpack
    #];

    # Adding users to the group vboxusers allows them to use the virtualbox functionality.
    users.extraGroups.vboxusers.members = [ "najib" ];
}
