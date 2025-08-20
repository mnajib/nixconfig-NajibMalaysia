# modules/home-manager/repo-bootstrap/default.nix
{ config, lib, pkgs, ... }:

let
  cfg = config.programs.repo-bootstrap;
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
            description = "Relative path under \$HOME where the repo should be cloned (without ~/).";
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
    home.activation.repo-bootstrap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "=== [repo-bootstrap] Starting bootstrap process ==="
      echo "Current user: $(whoami)"
      echo "HOME directory: $HOME"

      # Simple approach: manually check each repo
      ${lib.concatStrings (lib.mapAttrsToList (repoName: repo: ''
        if ${lib.boolToString repo.enable}; then
          echo "Processing repo: ${repoName}"
          path="$HOME/${lib.removePrefix "~/" repo.path}"
          echo "Repo path: $path"
          mkdir -p "$(dirname "$path")"

          if [ ! -d "$path/.git" ]; then
            echo "Git repo doesn't exist, cloning..."
            primaryRemote="${repo.primaryRemote}"
            cloneUrl="${repo.remotes.${repo.primaryRemote}.url}"
            echo "  Cloning ${repoName} from $primaryRemote ($cloneUrl) into $path"
            ${pkgs.git}/bin/git clone "$cloneUrl" "$path" || echo "Clone failed for ${repoName}"
          else
            echo "Git repo already exists at $path"
          fi

          # Configure remotes
          ${lib.concatStrings (lib.mapAttrsToList (remoteName: remote: ''
            echo "Configuring remote: ${remoteName}"
            rUrl="${remote.url}"
            rPushUrl="${if remote.pushUrl != null then remote.pushUrl else remote.url}"
            
            if ! ${pkgs.git}/bin/git -C "$path" remote | grep -q "^${remoteName}$"; then
              ${pkgs.git}/bin/git -C "$path" remote add "${remoteName}" "$rUrl"
            fi
            ${pkgs.git}/bin/git -C "$path" remote set-url "${remoteName}" "$rUrl"
            ${pkgs.git}/bin/git -C "$path" remote set-url --push "${remoteName}" "$rPushUrl"
          '') repo.remotes)}

          # Auto-fetch if enabled
          if ${lib.boolToString repo.autoFetch}; then
            echo "Fetching ${repoName}..."
            ${pkgs.git}/bin/git -C "$path" fetch --all --prune
          fi

          # Handle symlink
          if ${lib.boolToString repo.link.enable} && [ -n "${toString repo.link.target}" ]; then
            dest="$HOME/${lib.removePrefix "~/" (toString repo.link.target)}"
            src="$path"
            echo "Checking symlink: $dest -> $src"
            
            if [ -e "$dest" ] && [ ! -L "$dest" ]; then
              backup="$dest.bak-$(date +%s)"
              echo "  Backing up existing $dest → $backup"
              mv "$dest" "$backup"
            fi
            if [ ! -e "$dest" ]; then
              echo "  Linking $dest → $src"
              mkdir -p "$(dirname "$dest")"
              ln -s "$src" "$dest"
            else
              echo "  Symlink or file already exists at $dest"
            fi
          fi
        fi
      '') cfg.repos)}

      echo "=== [repo-bootstrap] Bootstrap process completed ==="
    '';
  };
}
