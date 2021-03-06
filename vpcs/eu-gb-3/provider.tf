variable "api_key" {
  default = ""
}

variable "ssh_public_key" {
  default = ""
}

variable "ssh_private_key" {
  default = ""
}

variable "region" {
  default     = "eu-gb"
  description = "Region to test."
}

variable "zone" {
  default     = "3"
  description = "Zones in each region to test."
}


provider "ibm" {
  ibmcloud_api_key = var.api_key
  generation = 2
  region     = var.region
}
