sudo virt-install --connect qemu:///system -n $1  -r 1024 --vcpus=1 --disk path=ubuntu-vm.img,size=8 -c /home/pranithk/Downloads/ubuntu-11.10-desktop-amd64.iso --vnc --noautoconsole --os-type linux --accelerate --network=bridge:virbr0 --hvm
