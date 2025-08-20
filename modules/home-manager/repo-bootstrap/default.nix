# modules/home-manager/repo-bootstrap/default.nix
{ config, lib, pkgs, ... }:

let
  cfg = config.programs.repo-bootstrap;
  genMarker = config.home.generation;
in {
  options.programs.repo-bootstrap = {
    enable = lib.mkEnableOption "Bootstrap git repos into home directory";

    autoFetch = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to automatically fetch after cloning/updating.";
    };

    repos = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
        options = {
          enable = lib.mkEnableOption "Enable repo ${name}";

          path = lib.mkOption {
            type = lib.types.str;
            description = "Relative path under \$HOME where the repo should be cloned.";
          };

          remotes = lib.mkOption {
            type = lib.types.attrsOf (lib.types.submodule {
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
            });
            description = "Remote definitions for this repo.";
          };
      
          primaryRemote = lib.mkOption {
            type = lib.types.str;
            default = "origin";
            description = "The remote to use for the initial clone.";
          };
      
          link = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to create a symlink in \$HOME.";
            };
            target = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Target path (relative to \$HOME) to symlink to the repo path.";
            };
          };
          autoFetch = lib.mkOption {
            type = lib.types.bool;
            default = cfg.autoFetch;
            description = "Whether to automatically fetch after cloning/updating.";
          };
        };
      }));
      default = {};
      description = "Repos to bootstrap.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.activation.repo-bootstrap = let
      reposJson = builtins.toJSON (lib.mapAttrs (name: repo: {
        inherit (repo) enable path primaryRemote autoFetch;
        remotes = lib.mapAttrs (remoteName: remote: {
          inherit (remote) url;
          pushUrl = if remote.pushUrl != null then remote.pushUrl else remote.url;
        }) repo.remotes;
        link = {
          enable = repo.link.enable;
          target = if repo.link.target != null then repo.link.target else "";
        };
      }) cfg.repos);
    in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "[repo-bootstrap] Bootstrapping git repos..."

      repos='${reposJson}'
      
      echo "$repos" | ${pkgs.jq}/bin/jq -r 'keys[]' | while read -r repoName; do
        # Extract repo configuration
        enabled=$(echo "$repos" | jq -r ".\"$repoName\".enable")
        [ "$enabled" != "true" ] && continue

        path="$HOME/$(echo "$repos" | jq -r ".\"$repoName\".path")"
        mkdir -p "$(dirname "$path")"

        if [ ! -d "$path/.git" ]; then
          primaryRemote=$(echo "$repos" | jq -r ".\"$repoName\".primaryRemote")
          cloneUrl=$(echo "$repos" | jq -r ".\"$repoName\".remotes.\"$primaryRemote\".url")
          echo "  Cloning $repoName from $primaryRemote ($cloneUrl) into $path"
          git clone "$cloneUrl" "$path"
        fi

        # Configure all remotes
        echo "$repos" | jq -r ".\"$repoName\".remotes | keys[]" | while read -r remote; do
          rUrl=$(echo "$repos" | jq -r ".\"$repoName\".remotes.\"$remote\".url")
          rPushUrl=$(echo "$repos" | jq -r ".\"$repoName\".remotes.\"$remote\".pushUrl")

          if ! git -C "$path" remote | grep -q "^$remote$"; then
            git -C "$path" remote add "$remote" "$rUrl"
          fi
          git -C "$path" remote set-url "$remote" "$rUrl"
          git -C "$path" remote set-url --push "$remote" "$rPushUrl"
        done

        # Auto-fetch if enabled
        autoFetch=$(echo "$repos" | jq -r ".\"$repoName\".autoFetch")
        if [ "$autoFetch" = "true" ]; then
          echo "  Fetching $repoName..."
          git -C "$path" fetch --all --prune
        fi

        # Handle symlink
        linkEnable=$(echo "$repos" | jq -r ".\"$repoName\".link.enable")
        linkTarget=$(echo "$repos" | jq -r ".\"$repoName\".link.target")
        if [ "$linkEnable" = "true" ] && [ -n "$linkTarget" ]; then
          dest="$HOME/$linkTarget"
          src="$path"
          if [ -e "$dest" ] && [ ! -L "$dest" ]; then
            backup="$dest.bak-hm${toString genMarker}-$(date +%s)"
            echo "  Backing up existing $dest → $backup"
            mv "$dest" "$backup"
          fi
          if [ ! -e "$dest" ]; then
            echo "  Linking $dest → $src"
            mkdir -p "$(dirname "$dest")"
            ln -s "$src" "$dest"
          fi
        fi
      done
    '';
  };
}
