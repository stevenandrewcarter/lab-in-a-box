#!/usr/bin/env bash
set -eu
_IMAGE="$(ls -1d output-virtualbox-iso/packer-virtualbox-iso-*.vmdk)"
sudo qemu-img convert -f vmdk -O qcow2 "$_IMAGE" "$_IMAGE.convert"
sudo rm -rf "$_IMAGE"
sudo chmod a+r /boot/vmlinuz*
sudo virt-customize --no-network -a "$_IMAGE.convert" --delete "/var/lib/*/random-seed" --delete "/var/lib/wicked/*" --firstboot-command "/usr/local/bin/virt-sysprep-firstboot.sh"
sudo virt-sysprep --operations defaults,-ssh-userdir,-customize -a "$_IMAGE.convert"
sudo virt-sparsify --in-place "$_IMAGE.convert"
sudo qemu-img convert -f qcow2 -O vmdk "$_IMAGE.convert" "$_IMAGE"
sudo rm -rf "$_IMAGE.convert"
