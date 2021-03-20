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
  ami           = "ami-05b891753d41ff88f"
  instance_type = "t2.micro"

  tags = {
    Name = "OpenVPN"
  }

  connection {
    type        = "ssh"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
       "curl -fsSL https://get.docker.com -o get-docker.sh",
       "sudo sh get-docker.sh"
    ]
  }
}

output "instance_public_ip" {
  description = "Public IP address of the OpenVPN instance"
  value       = aws_instance.openvpn.public_ip
}


