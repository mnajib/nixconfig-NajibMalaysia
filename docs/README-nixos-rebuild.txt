sudo nixos-rebuild boot --flake . --builders "ssh-ng://najib@sumayah" --max-jobs 0
sudo nixos-rebuild boot --flake . --build-host najib@nyxora --sudo --ask-sudo-password

sudo nixos-rebuild switch --flake .#bawang --target-host najib@bawang --sudo --ask-sudo-password
nh os switch . -H bawang --target-host najib@bawang


