# Lab in a Box

This repository provides different Virtualization Stacks / Solutions as Lab in a Box builds. The idea is to explore
building out the different stacks entirely on the local machine, but to explore examples beyond the basics.

## Tooling

The following tools are used to build out the environments.

* VirtualBox
* Packer
* Vagrant

## Build Images

Run the following commands to build a desired Virtual Box Image usable by Vagrant

```shell
cd images/<OS_VERSION>
packer init .
packer build .
vagrant box add --name <OS_VERSION> ./output-vagrant/package.box
```