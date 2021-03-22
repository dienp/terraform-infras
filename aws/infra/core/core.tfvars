aws_region  = "ap-southeast-1"
aws_profile = "default"

aws_instance = {
  default_username = "ubuntu",
  ami              = "ami-05b891753d41ff88f"
}

aws_key_pair = {
  my_ssh_key = {
    name = "my_ssh_key_pair",
    path = "~/.ssh/id_rsa.pub",
    private_key_path = "~/.ssh/id_rsa"
  }
}

aws_security_group = {
  allow_ssh = {
    name = "allow_ssh",
  }
}