sudo nixos-rebuild boot --flake . --builders "ssh-ng://najib@sumayah" --max-jobs 0
sudo nixos-rebuild boot --flake . --build-host najib@nyxora --sudo --ask-sudo-password

sudo nixos-rebuild switch --flake .#bawang --target-host najib@bawang --sudo --ask-sudo-password
nh os switch . -H bawang --target-host najib@bawang
nh os boot . -H khawlah --target-host najib@khawlah
nh os test . -H khawlah --target-host najib@khawlah

#
# NOTE:
#
#  Flake from non-flake, need to do
#
#  #ssh a@192.168.0.195
#  #echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
#
#  a@192.168.0.195> nvim /etc/nixos/configuration.nix
#     nix = {
#       extraOptions = ''
#         experimental-features = nix-command flakes
#       '';
#     };
#  a@192.168.0.195> sudo nixos-rebuild switch
#
nh os build . -H sakinah --target-host a@192.168.0.195 -- --override-input my-nvim path:/home/najib/src/nvim-config-test --show-trace


[2026-07-18 21:52:51] [najib@nyxora:~/src/nixconfig-NajibMalaysia]$ nh os boot . -H parang --target-host naqib@parang


# To build VM script:
  nix build .#nixosConfigurations.parang.config.system.build.vm
# To run the VM:
  ./result/bin/run-parang-vm
# If you need to SSH into the VM from your nyxora host, you can forward a port by setting an environment variable before running the script:
  QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-parang-vm



