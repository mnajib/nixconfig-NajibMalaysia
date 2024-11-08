{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    #blender
    freecad
    openscad
    f3d # viewer
    qcad
    sweethome3d.application sweethome3d.furniture-editor sweethome3d.textures-editor
  ];
}
