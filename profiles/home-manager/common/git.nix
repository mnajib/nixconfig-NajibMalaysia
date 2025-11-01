{
  pkgs,
  config,
  lib,
  ...
}:
{

  # NOTE:
  #   ...

  #imports = [
  #  #./git-aliases.nix
  #];

  #home.packages = with pkgs; [
  #  #gitAndTools.gitFull #git
  #];

  programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;

      #userName =  "${name}"; #"Najib Ibrahim";
      #userEmail = "${email}"; # "mnajib@gmail.com";

      #
      # To list all aliases:
      #   git config --get-regexp ^alias\.
      #
      aliases = {
          aliases       = "config --get-regexp ^alias\\.";                      # List all aliases (global + local)
          aliases-user  = "config --global --get-regexp ^alias\\.";             # List only user-level aliases
          aliases-local = "config --local --get-regexp ^alias\\.";              # List only repo-level aliases

          co = "checkout";
          ci = "commit";
          st = "status";
          br = "branch";

          #hist = "log --pretty=format:'%C(yellow)%h%Cred%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cr)' --graph --date=short --all";           #
          hist = "log --pretty=format:'%C(yellow)%h%Cred%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cd)' --graph --date=short --all";            #
          #hist = "log --pretty=format:'%C(yellow)%h%Cred%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cd)' --graph --date=relative --all";        #
          histp   = "log --pretty=format:'%C(yellow)%h%Cred%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cd)' --graph --date=short --all -p";        #
          hist2   = "log --graph --oneline --simplify-by-decoration --all";                   #
          hist22  = "!sh -c 'git log --graph --pretty=format:\"%C(auto)%h %d %s\" --simplify-by-decoration --all --color=always | grep --color=always -v \"tag:\"'";
          hist3   = "log --graph --oneline --decorate --all";                                 #
          hist4   = "log --stat --graph --pretty=format:'%h - %an: %s (%cd)' --all";          # '--pretty=format:' show custom commit info.
          hist5   = "log --graph --pretty=format:'%h - %an: %s (%cd)' --numstat --all";       # '--numstat' show files changed with numerac stats, easier to compute percentages.
          hist6   = "log --graph --pretty=format:'%C(yellow)%h%Creset - %C(cyan)%an%Creset: %s %Cgreen(%cd)' --stat --all";         # '--stat' show files changed and lines added/deleted (summary).
          hist7   = "log --graph --pretty=format:'%C(yellow)%h%Creset - %C(cyan)%an%Creset: %s %Cgreen(%cd)' -p --all";             # '-p' show full patch/diff per commit.

          type = "cat-file -t";
          dump = "cat-file -p";
          branchall = "branch -a -vv";
          tracked = "ls-tree --full-tree -r --name-only HEAD";

          # 🔍 Preview what `git merge <branch>` would do (while on current branch)
          # Shows commits in <branch> that are not in HEAD
          # Example: git merge-preview main
          merge-preview = "!git log HEAD..$1 --oneline --graph --decorate";

          # 🧾 Show file-level changes from current branch → <branch>
          # Useful to inspect what would change if you merged <branch> into current
          # Example: git merge-diff main
          merge-diff = "!git diff HEAD $1";

          # 🔍 Preview what `git rebase <branch>` would do (while on current branch)
          # Shows commits in HEAD that are not in <branch>
          # Example: git rebase-preview main
          rebase-preview = "!git log $1..HEAD --oneline --graph --decorate";

          # 🧾 Show file-level changes from <branch> → current branch
          # Useful to inspect what would be replayed during rebase
          # Example: git rebase-diff main
          rebase-diff = "!git diff $1 HEAD";
      };
      #diff-so-fancy.enable = true;
      extraConfig = {
          pull = {
            rebase = true;
          };
          push = {
            #default = "current";
            default = "simple";         # Avoid accidental pushes to upstream
          };
          core = {
              editor = "vim";
              excludesfile = "~/.gitignore";
              whitespace = "trailing-space,space-before-tab";
              commitGraph = true;       # Show nicer diffs for word-level changes
          };
          merge = {
              tool = "vimdiff";
          };
          diff = {
            colorMoved = "zebra";       # Show nicer diffs for word-level changes
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
