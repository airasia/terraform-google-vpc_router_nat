output "cloud_router" {
  description = "A reference (self_link) to the Cloud Router."
  value       = google_compute_router.cloud_router.self_link
}

output "cloud_nat_id" {
  description = "A full resource identifier of the Cloud NAT."
  value       = google_compute_router_nat.cloud_nat.id
}

output "nat_ips" {
  description = "External IP addresses created (and assigned to private subnet resources) by Cloud NAT if value of \"var.num_of_static_nat_ips\" is greater than \"0\".."
  value       = google_compute_address.static_nat_ips.*.address
}

