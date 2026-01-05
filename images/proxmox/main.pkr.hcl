packer {
  required_plugins {
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

source "virtualbox-iso" "basic-example" {
  guest_os_type = "Debian_64"
  iso_url = "https://enterprise.proxmox.com/iso/proxmox-ve_9.1-1.iso"
  iso_checksum = "sha256:6d8f5afc78c0c66812d7272cde7c8b98be7eb54401ceb045400db05eb5ae6d22"
  ssh_username = "proxmox"
  ssh_password = "proxmox"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  nested_virt = true
  cd_label            = "proxmox-ais"
  cd_files            = ["answer.toml"]
  boot_wait           = "10s"
  disk_size           = 20 * 1024
  boot_command = [
    # select Advanced Options.
    "<end><enter>",
    # select Install Proxmox VE (Automated).
    "<down><down><down><enter>",
    # wait for the shell prompt.
    "<wait1m>",
    # do the installation.
    "proxmox-fetch-answer partition proxmox-ais >/run/automatic-installer-answers<enter><wait>exit<enter>",
  ]
}

build {
  sources = ["sources.virtualbox-iso.basic-example"]
}