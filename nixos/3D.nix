{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    blender
    freecad
    openscad
  ];
}
