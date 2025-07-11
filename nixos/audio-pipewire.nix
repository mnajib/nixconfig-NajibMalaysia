{ pkgs, config, ... }:
{
  # Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
  #sound.enable = false;
  #sound.enable = true;a# no longer has any effect, please remove it

  #hardware.pulseaudio.enable = false;
  services.pulseaudio.enable = false;

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pulseaudioFull
  ];

  networking.firewall = {
    allowedTCPPorts = [ 4656 ];
  };
}
