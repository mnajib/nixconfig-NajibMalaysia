{
  pkgs,
  ...
}:
{

  # NOTE:
  #   ...

  #imports = [
  #  #./git.nix
  #];

  #home.packages = with pkgs; [
  #  #gitAndTools.gitFull #git
  #];

  programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;

      #userName =  "${name}"; #"Najib Ibrahim";
      #userEmail = "${email}"; # "mnajib@gmail.com";

      aliases = {
          co = "checkout";
          ci = "commit";
          st = "status";
          br = "branch";
          #hist = "log --pretty=format:'%C(yellow)%h%Cred%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cr)' --graph --date=short --all";
          hist = "log --pretty=format:'%C(yellow)%h%Cred%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cd)' --graph --date=short --all";
          #hist = "log --pretty=format:'%C(yellow)%h%Cred%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cd)' --graph --date=relative --all";
          histp = "log --pretty=format:'%C(yellow)%h%Cred%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cd)' --graph --date=short --all -p";
          hist2 = "log --graph --oneline --simplify-by-decoration --all";
          hist3 = "log --graph --oneline --decorate --all";
          type = "cat-file -t";
          dump = "cat-file -p";
          branchall = "branch -a -vv";
          tracked = "ls-tree --full-tree -r --name-only HEAD";
      };
      #diff-so-fancy.enable = true;
      extraConfig = {
          pull = {
            rebase = true;
          };
          #push = {
          #  default = "current";
          #};
          core = {
              editor = "vim";
              excludesfile = "~/.gitignore";
              whitespace = "trailing-space,space-before-tab";
          };
          merge = {
              tool = "vimdiff";
          };
          color = {
              ui = "auto";
              #diff = "auto";
              status = "auto";
              #branch = "auto";
              branch = {
                current = "yellow reverse";
                remote = "green bold";
                local = "blue bold";
              };
              diff = {
                meta = "blue bold";
                frag = "magenta bold";
                old = "red bold";
                new = "green bold";
              };
          };

          # mkdir /srv/gitrepo/nixconfig-NajibMalaysia.git
          # chgrp -R users nixconfig-NajibMalaysia.git
          # git init --bare --shared=0664 /srv/gitrepo/nixconfig-NajibMalaysia.git
          # git init --bare --shared=group mysharedgitrepo
          #
          # git clone --config core.sharedRepository=true
          #
          # setfacl -R -m g:<whatever group>:rwX gitrepo
          # find gitrepo -type d | xargs setfacl -R -m d:g:<whatever group>:rwX
          #
          # chmod -vR g+swX /srv/gitrepo
          safe = {
            #directory = "/srv/gitrepo/nixconfig-NajibMalaysia.git";
            #directory = "/srv/gitrepo";
            directory = "*";
          };
      }; # End extraConfig
  };

  #services.emacs = {
  #  enable = true;
  #  #packages =
  #  client = {
  #    enable = true;
  #  };
  #};

}
