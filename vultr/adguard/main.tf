terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "2.1.3"
    }
  }
  backend "remote" {

    hostname     = "app.terraform.io"
    organization = "dienp"
    workspaces {
      name = "terraform-infras"
    }

  }
}

variable "vultr_api_key" {
  type = string
}

# Configure the Vultr Provider
provider "vultr" {
  api_key     = var.vultr_api_key
  rate_limit  = 700
  retry_limit = 3
}

resource "vultr_user" "admin" {
  name        = "admin"
  email       = "user@vultr.com"
  password    = "myP@ssw0rd"
  api_enabled = true
  acl = [
    "manage_users",
    "subscriptions",
    "provisioning",
    "billing",
    "support",
    "abuse",
    "dns",
    "upgrade",
  ]
}
