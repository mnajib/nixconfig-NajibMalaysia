# modules/home-manager/repo-bootstrap/default.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.repo-bootstrap;
  genMarker = config.home.generation;

  # Helper function to generate shell script for each repo
  repoScript = repoName: repoConfig: ''
    # Process repo: ${repoName}
    enabled="${toString repoConfig.enable}"
    [ "$enabled" != "true" ] && continue

    path="$HOME/${repoConfig.path}"
    mkdir -p "$(dirname "$path")"

    if [ ! -d "$path/.git" ]; then
      # Pick first remote for initial clone
      firstRemoteName="${builtins.head (builtins.attrNames repoConfig.remotes)}"
      cloneUrl="${(builtins.head (builtins.attrValues repoConfig.remotes)).url}"
      echo "  Cloning ${repoName} from $cloneUrl into $path"
      git clone "$cloneUrl" "$path"
    fi

    # Configure all remotes
    ${lib.concatStringsSep "\n    " (lib.mapAttrsToList (remoteName: remoteConfig: ''
      rName="${remoteConfig.remoteName}"
      rUrl="${remoteConfig.url}"
      rPushUrl="${if remoteConfig.pushUrl != null then remoteConfig.pushUrl else remoteConfig.url}"

      git -C "$path" remote | grep -q "^$rName$" || git -C "$path" remote add "$rName" "$rUrl"
      git -C "$path" remote set-url "$rName" "$rUrl"
      git -C "$path" remote set-url --push "$rName" "$rPushUrl"
    '') repoConfig.remotes)}

    # Auto-fetch if enabled
    autoFetch="${toString repoConfig.autoFetch}"
    if [ "$autoFetch" = "true" ]; then
      echo "  Fetching ${repoName}..."
      git -C "$path" fetch --all --prune
    fi

    # Handle symlink
    linkEnable="${toString repoConfig.link.enable}"
    linkTarget="${if repoConfig.link.target != null then repoConfig.link.target else ""}"
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
  '';
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

                remoteName = lib.mkOption {
                  type = lib.types.str;
                  default = "origin";
                  description = "Remote name to use (default: origin).";
                };

              };
            });
            description = "Remote definitions for this repo.";
          };

          link = lib.mkOption {
            type = lib.types.submodule {
              options = {

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
            };
            default = {};
            description = "Symlink configuration for this repo.";
          };

          autoFetch = lib.mkOption {
            type = lib.types.bool;
            default = cfg.autoFetch;
            description = "Whether to automatically fetch after cloning/updating.";
          };

        };
      })); # End type = lib.types.attrsOf ( ... ) { ... };
      default = {};
      description = "Repos to bootstrap.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.activation.repo-bootstrap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "[repo-bootstrap] Bootstrapping git repos..."

      ${lib.concatStringsSep "\n\n" (lib.mapAttrsToList repoScript cfg.repos)}
    '';
  };

}
