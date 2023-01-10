{
    imports = [
        #./bootEFI.nix
        ./bootBIOS.nix
        ./thinkpad.nix
    ];

    # For the value of 'networking.hostID', use the following command:
    #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
    #
    # Thinkpad T400 sentul RM300
    networking.hostId = "aac7796b";
    networking.hostName = "leila";

    nix.trustedUsers = [ "root" "najib" ];
}
