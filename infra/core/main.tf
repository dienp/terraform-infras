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
    key    = "terraform-backend/core"
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

resource "aws_key_pair" "my_ssh_key_pair" {
  key_name   = var.aws_key_pair.my_ssh_key.name
  public_key = file(var.aws_key_pair.my_ssh_key.path)
}

resource "aws_security_group" "allow_ssh" {
  name        = var.aws_security_group.allow_ssh.name
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
    Name = var.aws_security_group.allow_ssh.name
  }
}


