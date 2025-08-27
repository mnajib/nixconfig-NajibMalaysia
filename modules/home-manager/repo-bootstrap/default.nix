{ config, lib, pkgs, ... }:

let
  cfg = config.programs.repo-bootstrap;

  buildRepoScript = name: repo:
    let
      enabled = toString repo.enable;
      repoPath = "$HOME/${cfg.basePath}/${name}";
      primaryRemote = repo.primaryRemote;
      cloneUrl = repo.remotes.${primaryRemote}.url;
      autoFetch = toString (repo.autoFetch or cfg.autoFetch);
      linkEnable = toString (repo.link.enable or cfg.linkEnable);
      linkTarget = if repo.link.target == null then "" else repo.link.target;
    in
    ''
      # ------------------------------------------------------------------------
      # Repo: ${name}
      # ------------------------------------------------------------------------

      enabled="${enabled}"
      if [ "$enabled" != "true" ]; then
        echo "  Skipping disabled repo: ${name}"
        exit 0
      fi

      path="${repoPath}"
      mkdir -p "$(dirname "$path")"

      if [ ! -d "$path/.git" ]; then
        echo "  Cloning ${name} from ${primaryRemote} (${cloneUrl}) into $path"
        git clone "${cloneUrl}" "$path"
      fi

      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (remoteName: remote:
        let
          rUrl = remote.url;
          rPushUrl = if remote ? pushUrl && remote.pushUrl != null then remote.pushUrl else rUrl;
        in
        ''
          git -C "$path" remote | grep -q "^${remoteName}$" || git -C "$path" remote add "${remoteName}" "${rUrl}"
          git -C "$path" remote set-url "${remoteName}" "${rUrl}"
          git -C "$path" remote set-url --push "${remoteName}" "${rPushUrl}"
        ''
      ) cfg.repos.${name}.remotes)}

      if [ "$autoFetch" = "true" ]; then
        echo "  Fetching ${name}..."
        git -C "$path" fetch --all --prune
      fi

      if [ "$linkEnable" = "true" ] && [ -n "$linkTarget" ]; then
        dest="$HOME/$linkTarget"
        src="$HOME/${cfg.basePath}/${name}"
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
      fi
    '';

  repoScripts = lib.concatStringsSep "\n\n" (lib.mapAttrsToList buildRepoScript cfg.repos);

in {
  options.programs.repo-bootstrap = {
    enable = lib.mkEnableOption "Bootstrap git repos into the home directory";

    basePath = lib.mkOption {
      type = lib.types.str;
      default = "src";
      description = "Relative path under $HOME where repositories are stored by default.";
    };

    autoFetch = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "If true, automatically run `git fetch --all --prune` after syncing repos (can be overridden per repo).";
    };

    linkEnable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Global default for whether repos create/update symlinks (can be overridden per repo).";
    };

    repos = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({ ... }: {
        options = {
          enable = lib.mkEnableOption "Enable this repository.";

          link = lib.mkOption {
            type = lib.types.submodule ({ ... }: {
              options = {
                enable = lib.mkOption {
                  type = lib.types.nullOr lib.types.bool;
                  default = null;
                  description = "Override global linkEnable for this repo (true/false). If null, use global setting.";
                };
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

          autoFetch = lib.mkOption {
            type = lib.types.nullOr lib.types.bool;
            default = null;
            description = "Override global autoFetch for this repo (true/false). If null, use global setting.";
          };
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
    '';
  };
}

