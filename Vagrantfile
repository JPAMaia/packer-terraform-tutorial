# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # VM Image
  config.vm.box = "bento/centos-7"
  config.vm.box_version = "202103.18.0"
  config.vm.box_check_update = false

  # VirtualBox Guest Additions
  config.vbguest.auto_update = false
  config.vbguest.installer_options = { allow_kernel_upgrade: true }
  config.vbguest.installer_hooks[:before_install] = [
    "yum install -y epel-release-7",
    "yum install -y kernel-headers-3.10.0",
    "yum install -y kernel-devel-3.10.0",
    "yum install -y gcc-4.8.5",
    "yum install -y make-1:3.82",
    "yum install -y perl-4:5.16.3"
  ]

  # Networking
  config.vm.hostname = "tutorial-vm"
  config.vm.network "private_network", ip: "10.1.1.2"

  # VM Capacity
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = "3"       # 3 CPU cores
    vb.memory = "8192"  # 8 GB RAM
  end

  # VM Provisioning
  scripts = [
      "vagrant/base.sh",
      "vagrant/ansible.sh",
      "vagrant/packer.sh",
      "vagrant/terraform.sh",
      "vagrant/jenkins.sh"
    ]
  scripts.each do |s|
    config.vm.provision "shell" do |sp|
      sp.path = s
    end
  end
end
