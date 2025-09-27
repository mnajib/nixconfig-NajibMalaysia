# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config, pkgs,
  lib,
  inputs, outputs, # Need for home-manager ?
  ...
}:
let
  commonDir = "../../common";
  hmDir = "../../../home-manager/users";
  hostName = "sumayah";
  stateVersion = "24.11";
in
{
  imports = let
    fromCommon = name: ./. + "/${toString commonDir}/${name}";
  in [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    ./turn-off-rgb.nix

    (fromCommon "configuration.FULL.nix")

    (fromCommon "console-keyboard-dvorak.nix")
    (fromCommon "keyboard-with-msa.nix")

    (fromCommon "users-a-wheel.nix")
    (fromCommon "users-naqib-wheel.nix")
    (fromCommon "users-najib.nix")
    (fromCommon "users-julia.nix")
    (fromCommon "users-naim.nix")
    (fromCommon "users-nurnasuha.nix")
    #(fromCommon "users-anak2.nix")

    (fromCommon "nfs-client-automount.nix")
    (fromCommon "zramSwap.nix")

    (fromCommon "window-managers.nix")

    (fromCommon "3D.nix")
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #networking.hostName = "sumayah"; #"nixos"; # Define your hostname.
  networking.hostName = hostName; #"nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "Asia/Kuala_Lumpur";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings =  {
    LC_ADDRESS = lib.mkForce "ms_MY.UTF-8";
    LC_IDENTIFICATION = lib.mkForce "ms_MY.UTF-8";
    LC_MEASUREMENT = lib.mkForce "ms_MY.UTF-8";
    LC_MONETARY = lib.mkForce "ms_MY.UTF-8";
    LC_NAME = lib.mkForce "ms_MY.UTF-8";
    LC_NUMERIC = lib.mkForce "ms_MY.UTF-8";
    LC_PAPER = lib.mkForce "ms_MY.UTF-8";
    LC_TELEPHONE = lib.mkForce "ms_MY.UTF-8";
    LC_TIME = lib.mkForce "ms_MY.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.displayManager.defaultSession = "none+xmonad";

  services.flatpak.enable = true;

  # Configure keymap in X11
  #services.xserver.xkb = {
  #  layout = "us";
  #  variant = "dvorak";
  #};

  # Configure console keymap
  console.keyMap = "dvorak";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.hardware.openrgb.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  #users.users.a = {
  #  isNormalUser = true;
  #  description = "a";
  #  extraGroups = [ "networkmanager" "wheel" "kvm" "adbusers" ];
  #  packages = with pkgs; [
  #  #  thunderbird
  #  ];
  #};

  #users.users.najib = {
  #  isNormalUser = true;
  #  description = "najib";
  #  extraGroups = [ "networkmanager" "wheel" "kvm" "adbusers" ];
  #  packages = with pkgs; [
  #  #  thunderbird
  #  ];
  #};

  home-manager = let
    userImport = user: import ( ./. + "/${hmDir}/${user}/${hostName}" );
  in
  {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      #root = import (./. + "/${hmDir}/root/${hostName}");
      #najib = import (./. + "/${hmDir}/najib/${hostName}");
      root = userImport "root";
      najib = userImport "najib";
    };
  };

  nix.settings.trusted-users = [ "root" "najib" "naqib" ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nixpkgs.config.android_sdk.accept_license = true;

  programs.adb.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  programs.steam.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    tmux
    neovim
    mosh
    pulseaudioFull
    pulsemixer
    mission-center
    ranger
    gnomeExtensions.vitals
    unzip
    blender-hip
    unrar
    p7zip
    tldr
    pigz
    android-studio # android-studio-full
    kmonad
    discord
    htop
    flatpak
    gimp
    freecad
    steam

    qbittorrent
    bottles
    zeroad-unwrapped
    minetest
    firefox
    brave
    varia
    git

    input-leap
    #barrier

    libreoffice
    popcorntime

    telegram-desktop
    whatsie # whatsapp client
    whatsapp-for-linux # whatsapp client
    kchat # kde app
    hexchat # IRC client
    #fluffychat # matrix client. Marked as insecure package.
    #deltachat-desktop # email-base IM
    simplex-chat-desktop
    #keet # (unfree) P2P chat
    mumble

    openrgb-with-all-plugins

    inputs.home-manager.packages.${pkgs.system}.default # To install home-manager packages
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 16216 ];
  networking.firewall.allowedUDPPorts = [ 16216 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  #system.stateVersion = "24.11"; # Did you read the comment?
  system.stateVersion = stateVersion;

}
