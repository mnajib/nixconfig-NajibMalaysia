# profiles/home-manager/common/repo-bootstrap.nix
{
  #basePath ? "~/src",
  basePath ? "src",
  ...
}:

{
  programs.repo-bootstrap = {
    enable = true; #false; # Default is 'true'.
    #autoFetch = true; # default: false
    #linkEnable = false; # default: true

    repos = {

      #------------------------------------------------------------------------
      nvim = {
        enable = false;
        path = "${basePath}/nvimconfig-NajibMalaysia";
        link = {
          enable = true;
          target = ".config/nvim";
        };
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
        enable = true; #false;
        link.enable = false;
        path = "${basePath}/nixconfig-NajibMalaysia";
        primaryRemote = "nyxora"; #"github";
        remotes = {
          github = {
            url = "https://github.com/NajibMalaysia/nixconfig.git";
            pushUrl = "git@github.com:NajibMalaysia/nixconfig.git";
          };
          nyxora = {
            url = "http://nyxora:3000/najib/nixconfig-NajibMalaysia.git";
            pushUrl = "ssh://forgejo@nyxora/najib/nixconfig-NajibMalaysia.git";
          };
          customdesktop = {
            url = "http://customdesktop:3000/najib/nixconfig-NajibMalaysia.git";
            pushUrl = "ssh://forgejo@customdesktop/najib/nixconfig-NajibMalaysia.git";
          };
        };
      };

      #------------------------------------------------------------------------
      xmonad = {
        enable = true; #false; # Default is 'true'.
        path = "${basePath}/xmonadconfig-NajibMalaysia";
        link = {
          enable = true;
          target = ".xmonad";
        };
        primaryRemote = "nyxora"; #"github";

        remotes = {
          github = {
            url = "https://github.com/NajibMalaysia/xmonadconfig.git";
            pushUrl = "git@github.com:NajibMalaysia/xmonadconfig.git";
          };
          nyxora = {
            url = "http://nyxora:3000/najib/xmonad-config.git";
            pushUrl = "ssh://forgejo@nyxora/najib/xmonad-config.git";
          };
          #customdesktop = {
          #  url = "";
          #  pushUrl = "";
          #};
        };
      };

      #------------------------------------------------------------------------
      bin = {
        enable = true; #false; # Default is 'true'
        path = "${basePath}/bin-NajibMalaysia";
        link = {
          enable = true;
          target = "bin";
        };
        primaryRemote = "myforgejo";

        remotes = {
          myforgejo = {
            url = "http://nyxora:3000/najib/bin.git";
            pushUrl = "ssh://forgejo@nyxora/najib/bin.git";
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

