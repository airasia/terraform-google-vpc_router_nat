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