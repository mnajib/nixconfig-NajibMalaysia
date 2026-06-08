sudo nixos-rebuild boot --flake . --builders "ssh-ng://najib@sumayah" --max-jobs 0
sudo nixos-rebuild boot --flake . --build-host najib@nyxora --sudo --ask-sudo-password
