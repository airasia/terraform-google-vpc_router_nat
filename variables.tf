variable "name_suffix" {
  description = "An arbitrary suffix that will be added to the end of the resource name(s). For example: an environment name, a business-case name, a numeric id, etc."
  type        = string
  validation {
    condition     = length(var.name_suffix) <= 14
    error_message = "A max of 14 character(s) are allowed."
  }
}

variable "vpc_network_name" {
  description = "VPC Network Name"
  type        = string
}

variable "cloud_router_region" {
  description = "Region where the router reside. Cloud Router is a regional resource."
  type        = string
}

variable "num_of_static_nat_ips" {
  description = "The number of static/manual external IPs that should be reserved by Cloud NAT. Useful when private instances need to communicate with the internet using specific external IPs that maybe whitelisted by 3rd party services."
  type        = number
  default     = 1
}

variable "nat_subnet" {
  description = "How NAT should be configured per Subnetwork. Possible values are ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, and LIST_OF_SUBNETWORKS"
  type        = string
}

variable "subnet_id" {
  description = "Subnetwork ID to NAT"
  type        = string
}

variable "source_ip_ranges_to_nat" {
  description = "List of options for which source IPs in the subnetwork should have NAT enabled. Supported values include: ALL_IP_RANGES, LIST_OF_SECONDARY_IP_RANGES, PRIMARY_IP_RANGE."
  type        = list(string)
}

variable "router_timeout" {
  description = "how long a Cloud Router operation is allowed to take before being considered a failure."
  type        = string
  default     = "5m"
}

variable "nat_timeout" {
  description = "how long a Cloud NAT operation is allowed to take before being considered a failure."
  type        = string
  default     = "10m"
}