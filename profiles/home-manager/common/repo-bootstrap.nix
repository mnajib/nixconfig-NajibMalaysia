# profiles/home-manager/common/repo-bootstrap.nix

{
  ...
}:

{
  programs.repo-bootstrap = {
    enable = true;                      # Default is 'false'.
    basePath = "~/src";
    #autofetchEnable = true;            # Default: false
    #symlinkEnable = true;              # Default: false

    repos = {

      #------------------------------------------------------------------------
      neovim-config-NajibMalaysia-kickstart-nix-nvim = {
        enable = true;
        symlink = {
          enable = false; #true;
          #target = ".config/nvim";
        };
        primaryRemote = "github";
        remotes = {
          github = {
            url = "https://github.com/mnajib/neovim-config-NajibMalaysia.git";
            pushUrl = "git@github.com:mnajib/neovim-config-NajibMalaysia.git";
          };
        };
        #link.enable = false; # default: true
        #autoFetch = true; # default: false
      };

      #------------------------------------------------------------------------
      nixconfig-NajibMalaysia = {
        enable = true; #false;
        symlink.enable = false;
        primaryRemote = "nyxora"; #"github";
        remotes = {
          github = {
            url = "https://github.com/mnajib/nixconfig-NajibMalaysia.git";
            pushUrl = "git@github.com:mnajib/nixconfig-NajibMalaysia.git";
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
      xmonad-config-NajibMalaysia = {
        enable = true; #false; # Default is 'true'.
        symlink = {
          enable = true;
          target = "~/.xmonad";
        };
        primaryRemote = "nyxora"; #"github";

        remotes = {
          github = {
            url = "https://github.com/mnajib/xmonad-config-NajibMalaysia.git";
            pushUrl = "git@github.com:mnajib/xmonad-config-NajibMalaysia.git";
          };
          nyxora = {
            url = "http://nyxora:3000/najib/xmonad-config.git";
            pushUrl = "ssh://forgejo@nyxora/najib/xmonad-config.git";
          };
          customdesktop = {
            url = "http://customdesktop:3000/najib/xmonad-config.git";
            pushUrl = "ssh://forgejo@customdesktop/najib/xmonad-config.git";
          };
        };
      };

      #------------------------------------------------------------------------
      bin-NajibMalaysia = {
        enable = true; #false; # Default is 'true'
        symlink = {
          enable = true;
          target = "~/bin";
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

