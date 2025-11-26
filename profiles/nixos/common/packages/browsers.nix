{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Modern browsers
    firefox qutebrowser
    brave google-chrome chromium

    # Text browsers
    lynx elinks w3m
  ];
}

