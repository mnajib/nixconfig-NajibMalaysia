# profiles/home-manager/common/repo-bootstrap.nix
{
  basePath ? "~/src",
  ...
}:

{
  programs.repo-bootstrap = {
    #enable = false; # Default is 'true'.
    #autoFetch = true; # default: false
    #linkEnable = false; # default: true

    repos = {

      #------------------------------------------------------------------------
      nvim = {
        enable = false;
        path = "${basePath}/nvimconfig-NajibMalaysia";
        link.target = ".config/nvim";
        primaryRemote = "github";
        remotes = {
          github = {
            url = "https://github.com/NajibMalaysia/nvimconfig.git";
            pushUrl = "git@github.com:NajibMalaysia/nvimconfig.git";
          };
        };
        #link.enable = false; # default: true
        #autoFetch = true; # default: false
      };

      #------------------------------------------------------------------------
      nixos = {
        enable = false;
        link.enable = false;
        path = "${basePath}/nixconfig-NajibMalaysia";
        primaryRemote = "github";
        remotes = {
          github = {
            url = "https://github.com/NajibMalaysia/nixconfig.git";
            pushUrl = "git@github.com:NajibMalaysia/nixconfig.git";
          };
        };
      };

      #------------------------------------------------------------------------
      xmonad = {
        enable = false; # Default is 'true'.
        path = "${basePath}/xmonadconfig-NajibMalaysia";
        link.target = ".xmonad";
        primaryRemote = "github";

        remotes = {
          github = {
            url = "https://github.com/NajibMalaysia/xmonadconfig.git";
            pushUrl = "git@github.com:NajibMalaysia/xmonadconfig.git";
          };
        };
      };

      #------------------------------------------------------------------------
      bin = {
        enable = true; #false; # Default is 'true'
        path = "${basePath}/bin-NajibMalaysia";
        link.target = "bin";
        primaryRemote = "myforgejo";

        remotes = {
          myforgejo = {
            url = "http://nyxora:3000/najib/bin.git";
          };
          myforgejo2 = {
            url = "http://customdesktop:3000/najib/bin.git";
          };
          github = {
            url = "https://github.com/NajibMalaysia/bin-NajibMalaysia.git";
            pushUrl = "git@github.com:NajibMalaysia/bin-NajibMalaysia.git";
          };
        };

      };
      #------------------------------------------------------------------------

    }; # End of 'repos = { ... };
  }; # End of 'programs.repo-bootstrap = { ... };
}

