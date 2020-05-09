variable "api_key" {
  default = ""
}

variable "region" {
  default     = "us-east"
  description = "Region to test."
}

variable "zone" {
  default     = "1"
  description = "Zones in each region to test."
}


provider "ibm" {
  ibmcloud_api_key = var.api_key
  generation       = 2
  region           = var.region
}
