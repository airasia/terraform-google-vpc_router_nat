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

variable "nat_min_ports_per_vm" {
  description = "Minimum number of ports reserved by the Cloud NAT for each VM. The number of ports that a Cloud NAT reserves for each VM limits the number of concurrent connections that the VM can make to a specific destination (https://cloud.google.com/nat/docs/ports-and-addresses#ports-and-connections). Each NAT IP supports upto 64,512 ports (65,536 minus 1,024 - https://cloud.google.com/nat/docs/ports-and-addresses#ports). If var.num_of_static_nat_ips is 1 and var.nat_min_ports_per_vm is 64, then the total number of VMs that can be serviced by that Cloud NAT is (1 * 64512 / 64) = 1008 VMs. https://cloud.google.com/nat/docs/ports-and-addresses#port-reservation-examples. As the total number of serviceable VMs increases, the total number of concurrent connections spawnable by a VM decreases. 64 is the default value provided by Google."
  type        = number
  default     = 64
}

variable "nat_enable_endpoint_independent_mapping" {
  type        = bool
  description = "Specifies if endpoint independent mapping is enabled. See https://cloud.google.com/nat/docs/overview#specs-rfcs"
  default     = false
}
