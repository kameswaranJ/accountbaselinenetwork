variable deploy_global_resources {
  type = bool
}

variable "fqName" {
  type = string
}

variable "is_prod" {
  type = bool
}

variable "cidr" {
  type = string
}

variable availability_zones {
  type = list(string)
}

variable fw_eps_name {
  type = string
}

variable domain_name {
  type = string
}

variable hosted_zone {
  type = string
}

variable tags {
  type = map(string)
}

variable endpoint_services {
  type = list(string)
}

variable vpc_count {
  type = number

  validation {
    condition     = var.vpc_count <= 8
    error_message = "You can create at most 4 large VPCs or 8 normal-sized VPCs."
  }
}

variable backend_subnet_count {
  type = number

  validation {
    condition     = var.backend_subnet_count <= 6
    error_message = "You can create at most 6 backend subnets per VPC."
  }
}

variable vpc_size {
  type = string

  validation {
    condition     = contains(["normal", "large"], var.vpc_size)
    error_message = "VPC size must be either normal or large."
  }
}

variable flow_logs_format {
  type = string
}

variable flow_logs_role_arn {
  type = string
}
