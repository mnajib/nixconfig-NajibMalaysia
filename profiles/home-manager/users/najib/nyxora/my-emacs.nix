# profiles/home-manager/users/najib/nyxora/my-emacs.nix
{
 #config,
 pkgs,
 inputs,
 ...
}:
{

  # Import the Home Manager module from your flake inputs
  #imports = [
  #  inputs.nix-doom-emacs-unstraightened.hmModule
  #];

  # Configure Doom Emacs
  #programs.doom-emacs = {
  #  enable = true;
  #  doomDir = ./path/to/doom.d; # or inputs.self + "/doom.d"
  #  doomLocalDir = "~/.local/share/nix-doom";
  #};

  # 1. Enable Fontconfig so GUI programs can discover installed fonts
  fonts.fontconfig.enable = true;

  # 2. Add fonts to home.packages
  home.packages = with pkgs; [

    inputs.my-emacs.packages.${pkgs.system}.default

    # Modern Doom modeline uses nerd-fonts
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono

    # Legacy icon font used by some Doom packages
    emacs-all-the-icons-fonts

  ];

}
