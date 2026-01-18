# Build the VirtualBox Vagrant Box by running
#   $ packer build -force .
packer {
  required_plugins {
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
      version = "~> 1"
    }
  }
}

variable "ubuntu_iso_url" {
  type = "string"
  default = "http://releases.ubuntu.com/25.10/ubuntu-25.10-live-server-amd64.iso"
}

variable "ubuntu_iso_checksum" {
  type = "string"
  default = "dc54870e5261c0abad19f74b8146659d10e625971792bd42d7ecde820b60a1d0"
}


source "virtualbox-iso" "ubuntu-25-10" {
  boot_command = [
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "c<wait5>",
    "set gfxpayload=keep<enter><wait5>",
    "linux /casper/vmlinuz <wait5>",
    "autoinstall quiet fsck.mode=skip noprompt <wait5>",
    "net.ifnames=0 biosdevname=0 systemd.unified_cgroup_hierarchy=1 <wait5>",
    "ds=\"nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/\" <wait5>",
    "---<enter><wait5>",
    "initrd /casper/initrd<enter><wait5>", "boot<enter>"
  ]
  boot_wait              = "1s"
  cpus                   = 2
  disk_size              = 131072
  gfx_accelerate_3d      = false
  gfx_controller         = "vboxsvga"
  guest_additions_mode   = "upload"
  guest_os_type          = "Ubuntu_64"
  headless               = false
  http_directory         = "http"
  iso_checksum           = var.ubuntu_iso_checksum
  iso_url                = var.ubuntu_iso_url
  memory                 = 4096
  shutdown_command       = "sudo shutdown -h now"
  ssh_password           = "vagrant"
  ssh_port               = 22
  ssh_read_write_timeout = "600s"
  ssh_timeout            = "120m"
  ssh_username           = "vagrant"
  vboxmanage = [
    ["modifyvm", "{{ .Name }}", "--cpu-profile", "host"],
    ["modifyvm", "{{ .Name }}", "--nested-hw-virt", "on"],
    ["modifyvm", "{{ .Name }}", "--nat-localhostreachable1", "on"]
  ]
  vm_name           = "ubuntu-25-10"
  vrdp_bind_address = "0.0.0.0"
  vrdp_port_max     = 6000
  vrdp_port_min     = 5900
}

build {
  sources = ["source.virtualbox-iso.ubuntu-25-10"]

  provisioner "shell" {
    script = "scripts/post-install.sh"
  }

  post-processor "vagrant" {
    keep_input_artifact = true
    compression_level   = 9
    output              = "output-vagrant/package.box"
    provider_override   = "virtualbox"
  }
}
