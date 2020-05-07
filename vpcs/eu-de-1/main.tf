resource "ibm_is_vpc" "testharness_vpc" {
  name = "test-harness-${var.region}-${var.zone}"
}

resource "ibm_is_subnet" "f5_management" {
  name                     = "test-harness-${var.region}-${var.zone}-f5-management"
  vpc                      = ibm_is_vpc.testharness_vpc.id
  zone                     = "${var.region}-${var.zone}"
  total_ipv4_address_count = "256"
}

resource "ibm_is_subnet" "f5_cluster" {
  name                     = "test-harness-${var.region}-${var.zone}-f5-cluster"
  vpc                      = ibm_is_vpc.testharness_vpc.id
  zone                     = "${var.region}-${var.zone}"
  total_ipv4_address_count = "256"
}

resource "ibm_is_subnet" "f5_internal" {
  name                     = "test-harness-${var.region}-${var.zone}-f5-internal"
  vpc                      = ibm_is_vpc.testharness_vpc.id
  zone                     = "${var.region}-${var.zone}"
  total_ipv4_address_count = "256"
}

resource "ibm_is_subnet" "f5_external" {
  name                     = "test-harness-${var.region}-${var.zone}-f5-external"
  vpc                      = ibm_is_vpc.testharness_vpc.id
  zone                     = "${var.region}-${var.zone}"
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
