{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    whatsapp-for-linux
    whatsapp-emoji-font

    whatsie		# Feature rich WhatsApp Client for Desktop Linux

    nchat
  ];
}
