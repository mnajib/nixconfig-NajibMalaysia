{
  pkgs,
  config,
  #lib,
  ...
}:
{
  imports = [
    #./steam.nix
    #./proton-GE.nix
  ];

  environment.systemPackages = with pkgs; [
    #kmscon
  ];

  services.kmscon = {
    enable = true;
    #package = pkgs.kmscon;
    fonts = [
      { name = "Source Code Pro"; package = pkgs.source-code-pro; }
    ];
    extraOptions = "--term xterm-256color";
    #extraConfig = "font-size=12";
    hwRender = true;

    extraConfig = ''
      font-name=Source Code Pro
      font-size=12
      xkb-layout=us
      xkb-variant=dvorak
    '';

  };

  console = {
    enable = true;
    # Inherits from the XKB parameters if useXkbConfig is supported by vconsole as well
    #useXkbConfig = true;
    # Fallback to standard kernel keymap for early boot initrd stages
    keyMap = "dvorak";
  };

}
