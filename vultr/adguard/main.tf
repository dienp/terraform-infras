terraform {
  required_providers {
    vultr = {
      source = "vultr/vultr"
      version = "2.1.3"
    }
  }
}

# Configure the Vultr Provider
provider "vultr" {
  api_key = "CTFX6OEIW6DHCOULWKPYWMWRICRYIE66J3KQ"
  rate_limit = 700
  retry_limit = 3
}

# Create a web instance
resource "vultr_instance" "web" {
    
}