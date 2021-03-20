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
    key = "terraform-backend/openvpn"
  }
}

variable "region" {
  default = "ap-southeast-1"
}

provider "aws" {
  profile = "default"
}

resource "aws_instance" "openvpn" {
  ami           = "ami-01016ec4119ab389a"
  instance_type = "t2.micro"

  tags = {
    Name = "OpenVPN"
  }

  provisioner "remote-exec" {
    inline = [
      "echo HIIIIIIIII"
    ]
  }
}

output "instance_public_ip" {
  description = "Public IP address of the OpenVPN instance"
  value       = aws_instance.openvpn.public_ip
}


