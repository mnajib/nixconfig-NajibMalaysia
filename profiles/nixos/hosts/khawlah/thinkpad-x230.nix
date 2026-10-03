{
  pkgs,
  configs,
  ...
}:{

  # ─── Intel Ivy Bridge (HD 4000): VA-API hardware video decode ───────
  # hardware.graphics.extraPackages : NixOS option, extra GPU userspace drivers
  # intel-vaapi-driver              : nixpkgs package, the old "i965" VA-API driver
  # Comment out this block to disable.
  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.intel-vaapi-driver ];
  };

  # Force the i965 driver. Remove if vainfo works without it.
  environment.sessionVariables.LIBVA_DRIVER_NAME = "i965";

}
