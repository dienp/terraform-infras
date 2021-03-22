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
    key    = "terraform-backend/adguard"
  }
}

provider "aws" {
  profile = "default"
}

resource "aws_security_group" "adguard" {
  name        = "adguard"
  description = "Allow AdGuard traffic"

  ingress {
    description = "Adguard Port 53/tcp"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Adguard Port 53/udp"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Adguard Port 80/tcp"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Adguard Port 3000/tcp"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Adguard Port 443/tcp"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Adguard Port 853/tcp"
    from_port   = 853
    to_port     = 853
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
    Name = "adguard"
  }
}

resource "aws_instance" "adguard" {

  ami             = var.aws_instance.ami
  instance_type   = "t2.micro"
  key_name        = var.aws_key_pair.my_ssh_key.name
  security_groups = [var.aws_security_group.allow_ssh.name, aws_security_group.adguard.name]

  tags = {
    Name = "AdGuard"
  }

  connection {
    type        = "ssh"
    user        = var.aws_instance.default_username
    private_key = file(var.aws_key_pair.my_ssh_key.private_key_path)
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh get-docker.sh",
      "sudo usermod -aG docker ${var.aws_instance.default_username}",
      "git clone https://github.com/ptdien/mercury-jp.git",
      "cd mercury-jp/bin",
      "chmod +x init-adguard.sh",
      "sudo sh ./init-adguard.sh"
    ]
  }
}

output "instance_public_ip" {
  description = "Public IP address of the instance"
  value       = aws_instance.adguard.public_ip
}


