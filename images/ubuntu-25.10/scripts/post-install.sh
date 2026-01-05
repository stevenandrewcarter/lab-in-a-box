#!/usr/bin/env bash

set -eu

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y gcc hostname iproute2 language-pack-en locales build-essential dkms
sudo mount -o loop VBoxGuestAdditions.iso /mnt
(echo 'y' | sudo sh /mnt/VBoxLinuxAdditions.run) || echo $?
sudo umount /mnt
sudo rm VBoxGuestAdditions.iso

sudo rm -rf /etc/apt/sources.list*
sudo mkdir -p /etc/apt/sources.list.d
printf "Components: main universe restricted multiverse\nEnabled: yes\nX-Repolib-Name: ubuntu\nSigned-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg\nSuites: questing questing-updates questing-backports\nTypes: deb\nURIs: http://archive.ubuntu.com/ubuntu\n" | sudo tee /etc/apt/sources.list.d/ubuntu.sources > /dev/null
printf "Components: main universe restricted multiverse\nEnabled: yes\nX-Repolib-Name: ubuntu-security\nSigned-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg\nSuites: questing-security\nTypes: deb\nURIs: http://security.ubuntu.com/ubuntu\n" | sudo tee /etc/apt/sources.list.d/ubuntu-security.sources > /dev/null

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  bzip2 \
  gnupg \
  gzip \
  passwd \
  procps \
  python3-apt \
  python3-debian \
  python3-jmespath \
  python3-lxml \
  python3-pip \
  python3-setuptools \
  python3-venv \
  python3-wheel \
  tar \
  unzip \
  util-linux \
  xz-utils \
  zip

#sudo setenforce 0
#sudo sed -i 's/^SELINUX=.*$/SELINUX=permissive/g' /etc/selinux/config
#sudo systemctl stop iptables.service
#sudo systemctl disable iptables.service
#sudo systemctl stop firewalld.service
#sudo systemctl disable firewalld.service
#sudo systemctl stop ufw.service
#sudo systemctl disable ufw.service

sudo apt autoremove -y
