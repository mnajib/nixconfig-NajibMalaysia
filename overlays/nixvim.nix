{ final, prev }: {
  nixvim = prev.callPackage nixvim.packages.${prev.system}.default { };
}
