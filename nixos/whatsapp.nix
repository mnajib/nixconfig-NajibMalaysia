{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    whatsapp-for-linux
    whatsapp-emoji-font
  ];
}
