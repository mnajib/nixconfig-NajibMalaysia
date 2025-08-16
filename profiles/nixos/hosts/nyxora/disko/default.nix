{
  lib, # is a must
  enableDrive1 ? false, # if the key is missing, take the default value (after the '?')
  enableDrive2 ? false,
  enableDrive3 ? false #true #false
}:

let
  d1 = import ./drive1.nix;
  d2 = import ./drive2.nix;
  d3 = import ./drive3.nix;
in

#lib.mkMerge [
#  (lib.optional enableDrive1 d1)
#  (lib.optional enableDrive2 d2)
#  (lib.optional enableDrive3 d3)
#]

#{
#  disk = lib.mkMerge [
#    (lib.optional enableDrive1 d1.disk)
#    (lib.optional enableDrive2 d2.disk)
#    (lib.optional enableDrive3 d3.disk)
#  ];
#}

#{
#  disko.devices = lib.mkMerge [
#    (lib.optionalAttrs enableDrive1 (import ./drive1.nix))
#    (lib.optionalAttrs enableDrive2 (import ./drive2.nix))
#    (lib.optionalAttrs enableDrive3 (import ./drive3.nix))
#  ];
#}

{
  disko.devices = lib.mkMerge [
    (lib.optionalAttrs enableDrive1 d1)
    (lib.optionalAttrs enableDrive2 d2)
    (lib.optionalAttrs enableDrive3 d3)
  ];
}
