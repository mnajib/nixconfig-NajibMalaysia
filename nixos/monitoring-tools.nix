{
  pkgs,
  config,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    s-tui             # CLI
    htop              # CLI
    #unixtools.top     # CLI
    #monit             # web interface
    #uptime-kuma       # web interface
    #glances           # web ui
    health-check
    #xosview
    #cpustat
    #smemstat
    #direvent
    #fam
    tiptop
    nmon
    #eventstat
    #riemann           # monitors distributed systems
    #watchlog

  ];
}
