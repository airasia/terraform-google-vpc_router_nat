terraform {
  required_version = ">= 0.13.1" # see https://releases.hashicorp.com/terraform/
}

locals {
  cloud_router_name      = format("%s-%s", var.name_router, var.name_suffix)
  cloud_nat_name         = format("%s-%s", var.name_nat, var.name_suffix)
  nat_ip_allocate_option = var.num_of_static_nat_ips > 0 ? "MANUAL_ONLY" : "AUTO_ONLY"
  nat_ips                = local.nat_ip_allocate_option == "MANUAL_ONLY" ? google_compute_address.static_nat_ips.*.self_link : []
}

resource "google_compute_router" "cloud_router" {
  name    = local.cloud_router_name
  network = var.vpc_network
  region  = var.region
  timeouts {
    create = var.router_timeout
    update = var.router_timeout
    delete = var.router_timeout
  }
}

resource "google_compute_address" "static_nat_ips" {
  count  = var.num_of_static_nat_ips
  name   = "${var.name_static_nat_ips}-${count.index + 1}-${var.name_suffix}"
  region = google_compute_router.cloud_router.region
}

resource "google_compute_router_nat" "cloud_nat" {
  name                               = local.cloud_nat_name
  router                             = google_compute_router.cloud_router.name
  region                             = google_compute_router.cloud_router.region
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = local.nat_ip_allocate_option
  nat_ips                            = local.nat_ips
  min_ports_per_vm                   = var.nat_min_ports_per_vm
  log_config {
    # If the NAT gateway runs out of NAT IP addresses, Cloud NAT drops packets.
    # Dropped packets are logged when error logging is turned on for Cloud NAT logging.
    # See https://cloud.google.com/nat/docs/ports-and-addresses#addresses
    enable = true
    filter = "ERRORS_ONLY"
  }
  timeouts {
    create = var.nat_timeout
    update = var.nat_timeout
    delete = var.nat_timeout
  }
}
