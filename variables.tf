# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ----------------------------------------------------------------------------------------------------------------------

variable "name_suffix" {
  description = "An arbitrary suffix that will be added to the end of the resource name(s). For example: an environment name, a business-case name, a numeric id, etc."
  type        = string
  validation {
    condition     = length(var.name_suffix) <= 14
    error_message = "A max of 14 character(s) are allowed."
  }
}

variable "vpc_network" {
  description = "A VPC network (self-link) that will be hosting this Cloud Router / Cloud NAT."
  type        = string
}

variable "region" {
  description = "Region where the Cloud Router / Cloud NAT should reside."
  type        = string
}

# ----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ----------------------------------------------------------------------------------------------------------------------

variable "name_router" {
  description = "Portion of name to be generated for the Cloud Router."
  type        = string
  default     = "cloud-router"
}

variable "name_nat" {
  description = "Portion of name to be generated for the Cloud NAT."
  type        = string
  default     = "cloud-nat"
}

variable "name_static_nat_ips" {
  description = "Portion of name to be generated for the static/manual NAT IP addresses if value of \"var.num_of_static_nat_ips\" is greater than \"0\"."
  type        = string
  default     = "nat-manual-ip"
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
