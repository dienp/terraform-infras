terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  backend "s3" {
    // TF doesn't accept var or env vars in terraform block, use terragrunt?
    bucket = "c8d3f7f6-4a9e-4c05-9ec3-f0612f81bb19"
    region = "ap-southeast-1"
    key    = "terraform-backend/openvpn"
  }
}

variable "region" {
  default = "ap-southeast-1"
}

provider "aws" {
  profile = "default"
}

resource "aws_key_pair" "deployer_key_pair" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH From Anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "openvpn" {
  depends_on = [
    aws_security_group.allow_ssh,
    aws_key_pair.deployer_key_pair
  ]
  
  ami                    = "ami-05b891753d41ff88f"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer_key_pair.key_name
  security_groups = ["${aws_security_group.allow_ssh.name}"]
  tags = {
    Name = "OpenVPN"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
       "touch test.txt",
       "curl -fsSL https://get.docker.com -o get-docker.sh",
       "sudo sh get-docker.sh"
    ]
  }
}

output "instance_public_ip" {
  description = "Public IP address of the OpenVPN instance"
  value       = aws_instance.openvpn.public_ip
}


