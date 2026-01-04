{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wasistlos #whatsapp-for-linux
    whatsapp-emoji-font

    #whatsie		# Feature rich WhatsApp Client for Desktop Linux. Disabled because use unsecure qtwebengine-5...

    nchat
  ];
}
