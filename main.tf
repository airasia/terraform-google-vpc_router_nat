terraform {
  required_version = ">= 0.13.1" # see https://releases.hashicorp.com/terraform/
}

locals {
  cloud_router_name      = format("%s-%s", "hk-cloud-router", var.name_suffix) #hk-cloud-router-tfdev-19cr
  cloud_nat_name         = format("%s-%s", "hk-cloud-nat", var.name_suffix)    #hk-cloud-nat-tfdev-19cr
  name_static_nat_ips    = "hk-nat-ip"
  nat_ip_allocate_option = var.num_of_static_nat_ips > 0 ? "MANUAL_ONLY" : "AUTO_ONLY"
  nat_ips                = local.nat_ip_allocate_option == "MANUAL_ONLY" ? google_compute_address.static_nat_ips.*.self_link : []
}

resource "google_project_service" "networking_api" {
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_router" "cloud_router" {
  name    = local.cloud_router_name #hk-cloud-router-tfdev-19cr
  network = var.vpc_network_name
  region  = var.cloud_router_region
  timeouts {
    create = var.router_timeout
    update = var.router_timeout
    delete = var.router_timeout
  }
}

resource "google_compute_address" "static_nat_ips" {
  count  = var.num_of_static_nat_ips
  name   = "${local.name_static_nat_ips}-${count.index + 1}-${var.name_suffix}" #hk-nat-ip-1-tfdev-19cr
  region = var.cloud_router_region
}

resource "google_compute_router_nat" "cloud_nat" {
  name                               = local.cloud_nat_name #hk-cloud-nat-tfdev-19cr
  router                             = google_compute_router.cloud_router.name
  region                             = google_compute_router.cloud_router.region
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on                         = [google_project_service.networking_api]
  nat_ip_allocate_option             = local.nat_ip_allocate_option
  nat_ips                            = local.nat_ips
  log_config {
    enable = true
    filter = "ALL"
  }
  timeouts {
    create = var.nat_timeout
    update = var.nat_timeout
    delete = var.nat_timeout
  }
}