variable deploy_global_resources {
  type = bool
}

variable shared_role {
  type = string
}

variable fqName {
  type = string
}

variable "is_prod" {
  type = bool
}

variable domain_name {
  type = string
}

variable vpc_type {
  type = string

  validation {
    condition     = contains(["shared", "dedicated"], var.vpc_type)
    error_message = "Variable vpc_type can only be 'shared' or 'dedicated'."
  }
}

variable vpc_count {
  type = number

  validation {
    condition     = var.vpc_count <= 4
    error_message = "You can create at most 4 VPCs."
  }
}

variable backend_subnet_count {
  type = number

  validation {
    condition     = var.backend_subnet_count <= 6
    error_message = "You can create at most 6 backend subnets."
  }
}

variable frontend_netmask_length {
  type = number

  validation {
    condition     = var.frontend_netmask_length <= 28
    error_message = "Frontend subnet cannot be smaller than /28"
  }
}

variable backend_netmask_length {
  type = number

  validation {
    condition     = var.backend_netmask_length <= 28
    error_message = "Backend subnet cannot be smaller than /28"
  }
}

variable flow_logs_format {
  type = string
}

variable dns_forward_share {
  type = string
}

variable dns_forwarding_vpc_id {
  type = string
}

variable dns_forwarding_vpc_id_alt {
  type = string
}

variable hosted_zone {
  type = string
}

variable app_default_tags {
  type = map(string)
}

variable frontend_netmask_margin {
  type = number
}

variable backend_netmask_margin {
  type = number
}

# Shared VPC only

variable subnet_resource_share {
  type = string
}

variable legacy_subnet_allocation {
  type = bool
}

# Dedicated VPC only

variable availability_zones {
  type = list(string)
}

variable tgw_share_name {
  type = string
}

variable tgw_id {
  type = string
}

variable flow_logs_role_arn {
  type = string
}

variable backend_cidr {
  type = string
}
