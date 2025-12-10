{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Messaging
    telegram-desktop ayugram-desktop signal-desktop
    hexchat discord discord-ptb

    # Secure/alt messengers
    simplex-chat-desktop session-desktop briar-desktop

    # Email
    neomutt
  ];
}

