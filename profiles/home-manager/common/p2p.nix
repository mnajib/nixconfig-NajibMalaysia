{
  pkgs,
  ...
}:
{

  home.packages = with pkgs; [
    mldonkey
    tribler
    #gnunet
    peergos
    zeronet-conservancy

    #amule-gui #amule-daemon amule

    peertube

    #retroshare
    cabal-cli

    brig
    kubo kubo-migrator
    framesh
    ipget
    #iroh
    #gx

    filegive
  ];

}
