# modules/home-manager/repo-bootstrap/default.nix

{ config, lib, pkgs, ... }:

let
  cfg = config.programs.repo-bootstrap;

  # Expand ~ to $HOME for user-facing paths
  expandHome = path:
    if path == null then ""
    else if lib.hasPrefix "~/" path then
      "$HOME/" + lib.removePrefix "~/" path
    else
      path;

  #boolOrFalse = x: if x == null then false else x or false;

  # This function takes the repository name and its configuration.
  buildRepoScript = name: repo:
    let

      #
      # NOTE: 'or' in Nix means: if left is not null, use it, otherwise fallback to right.
      #

      #
      # NOTE:
      #
      # toString output:
      #   true → "1"
      #   false → ""
      #
      # lib.boolToString output:
      #   true → "true"
      #   false → "false"
      #
      #  {
      #    a = toString true;           # "1"
      #    b = toString false;          # ""
      #    c = lib.boolToString true;   # "true"
      #    d = lib.boolToString false;  # "false"
      #  }

      #enabled = toString ((repo.enable or false) or false);
      enabled = lib.boolToString repo.enable;

      repoPath = expandHome cfg.basePath + "/${name}";

      primaryRemote = repo.primaryRemote;
      cloneUrl = repo.remotes.${primaryRemote}.url;

      #
      # NOTE:
      #
      #   (repo.autofetchEnable or false)               -- safe if missing, unsafe if null
      #   ((repo.autofetchEnable or false) or false)    -- safe if missing or null
      #   (boolOrFalse (repo.autofetchEnable or false)) -- clear
      #   maybe.fromMaybeBool repo.autofetchEnable      -- clear + reusable

      #autofetchEnable = toString (
      #  ((repo.autofetchEnable or false) or false)
      #  && ((cfg.autofetchEnable or false) or false)
      #);
      # or
      #autofetchEnable = toString (
      #  (boolOrFalse (repo.autofetchEnable or false))
      #  && (boolOrFalse (cfg.autofetchEnable or false))
      #);
      # or (with combination of usage lib.mkEnableOption)
      autofetchEnable = lib.boolToString (
        #repo.autofetchEnable && cfg.autofetchEnable
        repo.autofetchEnable or cfg.autofetchEnable
      );

      #symlinkEnable = toString (
      #  (boolOrFalse(repo.symlink.enable or false))
      #  && (boolOrFalse(cfg.symlinkEnable or false))
      #  && ((repo.symlink.target or "") != "")
      #);
      symlinkEnable = lib.boolToString (
        #repo.symlink.enable && cfg.symlinkEnable
        repo.symlink.enable or cfg.symlinkEnable
      );

      #symlinkTarget = if repo.symlink.target == null then "" else repo.symlink.target;
      symlinkTarget = repo.symlink.target or "";
      symlinkTargetPath = expandHome symlinkTarget;
    in
    ''
      # ------------------------------------------------------------------------
      # Repo: ${name}
      # ------------------------------------------------------------------------
      echo "Processing repo ${name}"

      # Skip if this repository is not enabled
      #echo "${enabled}"
      if [ "${enabled}" != "true" ]; then
        echo "  Skipping disabled repo: ${name}"
        #exit 0
      else
        echo "  Continue enabled repo: ${name}"

        # Define the full path to the repository
        path="${repoPath}"

        # Create the parent directory if it doesn't exist
        echo "  Creating $(dirname \"$path\")"
        mkdir -p "$(dirname "$path")"

        # Clone the repository if it does not already exist
        #echo "  Git clone"
        if [ ! -d "$path/.git" ]; then
          echo "  Cloning ${name} from ${primaryRemote} (${cloneUrl}) into $path"
          ${pkgs.git}/bin/git clone "${cloneUrl}" "$path"
        else
          echo "  Cloning: abort as the repository already exist in $path"
        fi

        # Configure all remotes, including setting push URLs
        echo "  Configure all remotes, including setting push URLs"
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (remoteName: remote:
          let
            rUrl = remote.url;
            rPushUrl = if remote ? pushUrl && remote.pushUrl != null then remote.pushUrl else rUrl;
          in
          ''
            #echo "  git remote add ..."
            ${pkgs.git}/bin/git -C "$path" remote | grep -q "^${remoteName}$" || ${pkgs.git}/bin/git -C "$path" remote add "${remoteName}" "${rUrl}"
            #echo "  git remote set-url ..."
            ${pkgs.git}/bin/git -C "$path" remote set-url "${remoteName}" "${rUrl}"
            #echo "  git remote set-url --push ..."
            ${pkgs.git}/bin/git -C "$path" remote set-url --push "${remoteName}" "${rPushUrl}"
          ''
        ) cfg.repos.${name}.remotes)}

        # Run git fetch if autoFetch is enabled for this repo
        #echo "  Git fetch"
        if [ "${autofetchEnable}" = "true" ]; then
          echo "  Fetching ${name}..."
          ${pkgs.git}/bin/git -C "$path" fetch --all --prune
        else
          echo "  Fetching disabled"
        fi

        # Handle symlinking
        #echo "  Symlink"
        if [ "${symlinkEnable}" = "true" ] && [ -n "${symlinkTargetPath}" ]; then
          #echo "  symlink enable: ${symlinkEnable}"
          echo "  Symlink enabled"
          dest="${symlinkTargetPath}"
          src="$path"
          if [ -e "$dest" ] && [ ! -L "$dest" ]; then
            backup="$dest.bak-$(date +%s)"
            echo "  Backing up existing $dest -> $backup"
            mv "$dest" "$backup"
          fi
          if [ ! -e "$dest" ]; then
            echo "  Linking $dest -> $src"
            mkdir -p "$(dirname "$dest")"
            ln -s "$src" "$dest"
          fi
        else
          echo "  Symlink disabled"
        fi
      fi
    '';

  repoScripts = lib.concatStringsSep "\n\n" (lib.mapAttrsToList buildRepoScript cfg.repos);

in {
  options.programs.repo-bootstrap = {
    enable = lib.mkEnableOption "Bootstrap git repos into the home directory";

    basePath = lib.mkOption {
      type = lib.types.str;
      default = "~/src";
      description = "Relative path under $HOME where repositories are stored by default.";
    };

    #autofetchEnable = lib.mkOption {
    #  type = lib.types.bool;
    #  default = false;
    #  description = "If true, automatically run `git fetch --all --prune` after syncing repos (can be overridden per repo).";
    #};
    autofetchEnable = lib.mkEnableOption "If true, automatically run `git fetch --all --prune` after syncing repos (can be overridden per repo).";

    #symlinkEnable = lib.mkOption {
    #  type = lib.types.bool;
    #  default = true;
    #  description = "Global default for whether repos create/update symlinks (can be overridden per repo).";
    #};
    symlinkEnable = lib.mkEnableOption "Global default for whether repos create/update symlinks (can be overridden per repo).";

    repos = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({ ... }: {
        options = {
          enable = lib.mkEnableOption "Enable this repository.";

          symlink = lib.mkOption {
            type = lib.types.submodule ({ ... }: {
              options = {

                #enable = lib.mkOption {
                #  type = lib.types.nullOr lib.types.bool;
                #  default = null;
                #  description = "Override global linkEnable for this repo (true/false). If null, use global setting.";
                #};
                enable = lib.mkEnableOption "Override global linkEnable for this repo (true/false). If null, use global setting.";

                target = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "Optional relative symlink path under $HOME pointing to the repo path.";
                };

              };
            });
            default = {};
            description = "Symlink configuration.";
          };

          primaryRemote = lib.mkOption {
            type = lib.types.str;
            default = "origin";
            description = "The remote to use for the initial clone.";
          };

          remotes = lib.mkOption {
            type = lib.types.attrsOf (lib.types.submodule ({ ... }: {
              options = {
                url = lib.mkOption {
                  type = lib.types.str;
                  description = "Fetch URL for this remote.";
                };
                pushUrl = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "Push URL for this remote. Defaults to url if null.";
                };
              };
            }));
            description = "Remote definitions for this repo.";
          };

          #autofetchEnable = lib.mkOption {
          #  type = lib.types.nullOr lib.types.bool;
          #  default = null;
          #  description = "Override global autoFetch for this repo (true/false). If null, use global setting.";
          #};
          autofetchEnable = lib.mkEnableOption "Override global autoFetch for this repo (true/false). If null, use global setting.";

        };
      }));
      default = {};
      description = "Git repositories to manage.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.activation.repo-bootstrap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "[repo-bootstrap] Bootstrapping git repos..."
      ${repoScripts}
      echo "[repo-bootstrap] Done"
    '';
  };
}

