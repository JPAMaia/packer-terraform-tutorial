packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "apache" {
  ami_name      = "tutorial"
  instance_type = var.instance_type
  region        = "eu-west-1"

  ssh_username = "centos"

  force_deregister      = true
  force_delete_snapshot = true

  source_ami_filter {
    most_recent = true
    owners      = ["125523088429"]
    filters = {
      virtualization-type = "hvm"
      root-device-type    = "ebs"
      architecture        = "x86_64"
      name                = "CentOS 7.8.2003 x86_64"
    }
  }

  tags = {
    Name    = "Tutorial"
    Project = "tutorial"
  }
}

build {
  name    = "learn-packer"
  sources = ["source.amazon-ebs.apache"]

  provisioner "file" {
    destination = "/home/centos/"
    sources     = ["index.html"]
  }

  provisioner "ansible" {
    playbook_file   = "/vagrant/ansible/playbooks/apache.yml"
    user            = "centos"
    extra_arguments = ["--vault-password-file=${var.vault_file}"]
  }

  provisioner "shell" {
    inline = ["echo DONE!"]
  }

  post-processor "manifest" {
    output = "manifest.json"
  }
}
