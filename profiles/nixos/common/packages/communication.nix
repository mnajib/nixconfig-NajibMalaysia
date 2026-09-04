{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Messaging
    telegram-desktop ayugram-desktop signal-desktop
    #hexchat # 'hexchat' has been removed due to being archived upstream and relying on gtk2.
    discord discord-ptb

    # Secure/alt messengers
    simplex-chat-desktop
    #session-desktop
    jami
    briar-desktop

    # Email
    neomutt
  ];
}

