resource "ibm_is_vpc" "testharness_vpc" {
  name = "test-harness-${var.region}-${var.zone}"
  #name = "test-harness-us-south-1" 
}

resource "ibm_is_subnet" "f5_management" {
  name = "f5-management"
  vpc  = ibm_is_vpc.testharness_vpc.id
  zone = "${var.region}-${var.zone}"
  total_ipv4_address_count = "256"
  #ipv4_cidr_block = "10.240.0.0/24"
  #ipv4_cidr_block = var.address_prefixes["${var.region}-${var.zone}-management"]
}

resource "ibm_is_subnet" "f5_cluster" {
  name = "f5-cluster"
  vpc  = ibm_is_vpc.testharness_vpc.id
  zone = "${var.region}-${var.zone}"
  #ipv4_cidr_block = var.address_prefixes["${var.region}-${var.zone}-cluster"]
  total_ipv4_address_count = "256"
}

resource "ibm_is_subnet" "f5_internal" {
  name = "f5-internal"
  vpc  = ibm_is_vpc.testharness_vpc.id
  zone = "${var.region}-${var.zone}"
  #ipv4_cidr_block = var.address_prefixes["${var.region}-${var.zone}-internal"]
  total_ipv4_address_count = "256"
}

resource "ibm_is_subnet" "f5_external" {
  name = "f5-external"
  vpc  = ibm_is_vpc.testharness_vpc.id
  zone = "${var.region}-${var.zone}"
  #ipv4_cidr_block = var.address_prefixes["${var.region}-${var.zone}-external"]
  total_ipv4_address_count = "256"
}

output "testharness_vpc_id" {
  value = ibm_is_vpc.testharness_vpc.id
}

output "f5_management_id" {
  value = ibm_is_subnet.f5_management.id
}

output "f5_management_cidr" {
  value = ibm_is_subnet.f5_management.ipv4_cidr_block
}

output "f5_cluster_id" {
  value = ibm_is_subnet.f5_cluster.id
}

output "f5_cluster_cidr" {
  value = ibm_is_subnet.f5_cluster.ipv4_cidr_block
}

output "f5_internal_id" {
  value = ibm_is_subnet.f5_internal.id
}

output "f5_internal_cidr" {
  value = ibm_is_subnet.f5_internal.ipv4_cidr_block
}

output "f5_external_id" {
  value = ibm_is_subnet.f5_external.id
}

output "f5_external_cidr" {
  value = ibm_is_subnet.f5_external.ipv4_cidr_block
}

output "region_zone" {
  value = "${var.region}-${var.zone}"
}
