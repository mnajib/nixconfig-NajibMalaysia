{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    blender
    freecad
    openscad
    f3d # viewer
    qcad
  ];
}
