{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    bc  # GNU CLI calculator
    eva # A CLI calculator REPL, similar to bc
    clac # CLI Interactive stack-based calculator
    pro-office-calculator speedcrunch wcalc pdd galculator # calculator
    qalculate-gtk # qalculate-qt # the ultimate desktop calculator
    gnome-calculator
    rink  # unit-aware CLI calculator
    fend # CLI arbitrary-precision unit-aware calculator
    wcalc # A command line (CLI) calculator
    quich # The advanced terminal (CLI) calculator
    kalker  # A command line (CLI) calculator that supports math-like syntax with user-defined variables, functions, derivation, integration, and complex numbers
    #deepin.deepin-calculator  # A easy to use calculator for ordinary users
    pantheon.elementary-calculator # GUI Calculator app designed for elementary OS
    mate.mate-calc # GUI calculator for the MATE desktop
    lumina.lumina-calculator # Scientific calculator for the Lumina Desktop
    ipcalc  # Simple CLI IP network calculator
    sipcalc # advanced console (CLI) ip subnet calculator
    pdd # CLI tiny date, time diff calculator
  ];
}
