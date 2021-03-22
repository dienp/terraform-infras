
variable "aws_instance" {
  type = object({
    default_username = string,
    ami              = string
  })
}

variable "aws_key_pair" {
  type = object({
    my_ssh_key = object({
      name = string,
      path = string,
    })
  })
}

variable "aws_security_group" {
  type = object({
    allow_ssh = object({
      name = string,
    })
  })
}

variable "aws_profile" {
  type = string
}

variable "aws_region" {

  type = string
}
