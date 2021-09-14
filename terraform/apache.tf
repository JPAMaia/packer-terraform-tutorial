terraform {
  # backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

resource "aws_key_pair" "key" {
  key_name   = "key_tutorial"
  public_key = file("key_tutorial.pub")

  tags = {
    Project = "tutorial"
  }
}

data "aws_ami" "apache" {
  most_recent = true
  owners = [
    "self"
  ]

  filter {
    name = "name"
    values = [
      "tutorial"
    ]
  }

  filter {
    name = "root-device-type"
    values = [
      "ebs"
    ]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"
    ]
  }
}

resource "aws_security_group" "apache" {
  name        = "tutorial_sec_group"
  description = "Minimal security group"

  ingress {
    description      = "HTTP from Anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  ingress {
    description      = "SSH from Anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Ping from Anywhere"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  egress = [
    {
      description      = "Allow all traffic to Anywhere"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name    = "Tutorial-Sec-Group"
    Project = "tutorial"
  }
}

resource "aws_instance" "apache" {
  ami           = data.aws_ami.apache.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.key.key_name

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.apache.id]

  root_block_device {
    volume_size           = "10"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name    = var.name
    Project = "tutorial"
  }
}

resource "null_resource" "remote_shell" {
  triggers = {
    public_ip = aws_instance.apache.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo CONNECTED!",
      "sudo cp /home/centos/index.html /var/www/html/index.html"
    ]
    connection {
      host        = aws_instance.apache.public_ip
      type        = "ssh"
      user        = "centos"
      private_key = file("key_tutorial")
    }
  }
}
