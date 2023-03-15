variable app_name {
  type = string
  description = "App Name"
  default = "aft-app-090723"
}

variable env_name {
  type = string
  description = "Env Name"
  default = "dev"
}

variable region {
  type = string
  description = "Region Name"
  default = "eu-west-3"
}

variable stla_region {
  type = string
  description = "config name for stla region"
  default = "np-eu-xp"
}

# Version variables

variable allow_downgrade {
  type    = bool
  description = "allow_downgrade"
  default = false
}

# variable allow_untagged {
#   type    = bool
#   default = false
# }

# Common variables



variable flags {
  type    = string
  default = null
  validation {
    condition     = can(regex("^<default>|[^,(?! )]*$", coalesce(var.flags, "<default>")))
    error_message = "flags can only be omitted, '<default>' or a list of separated flag names"
  }
  description = "Different Flags to be used"
}


variable account_type {
  type    = string
  default = "standalone"
  # validation {
  #   condition     = contains(["<default>", "standalone", "onprem-ext"], coalesce(var.account_type, "<default>"))
  #   error_message = "account_type can only be omitted, '<default>', 'standalone' or 'onprem-ext'"
  # }
  description = "Account type - standalone or on-prem-ext"
}


variable vpc_count {
  type    = string
  default = null
  validation {
    condition     = can(regex("^<default>|[1-8]$", coalesce(var.vpc_count, "<default>")))
    error_message = "vpc_count can only be omitted, '<default>' or '1' to '8'"
  }
  description = "Number of VPCs"
}


variable backend_subnet_count {
  type    = string
  default = null
  validation {
    condition     = can(regex("^<default>|[1-6]$", coalesce(var.backend_subnet_count, "<default>")))
    error_message = "backend_subnet_count can only be omitted, '<default>' or '1' to '6'"
  }
  description = "Number of backend Subnets"
}


variable hosted_zone {
  type        = string
  default     = null
  description = "DNS Hosted Zone Name"
}


variable domain_name {
  type        = string
  default     = null
  description = "DNS Name"
}


variable flow_logs_format {
  type        = string
  default     = null
  description = "VPC Flow Logs Format"
}


variable deploy_global_resources {
  type        = bool
  default     = null
  description = "Deploy Global Resources"
}

variable vpc_confidentiality {
  type    = string
  default = null
  validation {
    condition = contains([
      "<default>", "standard", "sensitive", "confidential"
    ], coalesce(var.vpc_confidentiality, "<default>"))
    error_message = "vpc_criticality can only be omitted, '<default>', 'standard', 'sensitive' or 'confidential'"
  }
  description = "Degree of data confidentiality for the VPC"
}

# Standalone variables

# variable vpc_size {
#   type    = string
#   default = null
#   validation {
#     condition     = contains(["<default>", "normal", "large"], coalesce(var.vpc_size, "<default>"))
#     error_message = "vpc_size can only be omitted, '<default>', 'normal' or 'large'"
#   }
#   description = "VPC Size"
# }


# variable cidr {
#   type    = string
#   default = null
#   validation {
#     condition     = can(regex("^<default>|([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", coalesce(var.cidr, "<default>")))
#     error_message = "cidr can only be omitted, '<default>' or a valid CIDR"
#   }
#   description = "VPC CIDR"
# }


variable az_count {
  type    = string
  default = null
  validation {
    condition     = can(regex("^<default>|[1-4]$", coalesce(var.az_count, "<default>")))
    error_message = "az_count can only be omitted, '<default>' or '1' to '4'"
  }
  description = "Availability Zone Count"
}


# variable fw_attachment_enable {
#   type        = bool
#   default     = true
#   description = "Whether Firewall Attachement will be enabled"
# }


variable az_exclusion {
  type    = string
  default = null
  validation {
    condition     = can(regex("^<default>|<none>|[a-z0-9-]+(,[a-z0-9-]+)*$", coalesce(var.az_exclusion, "<default>")))
    error_message = "az_exclusion can only be omitted, '<default>', '<none>' or a comma separated list of AZ"
  }
  description = "AZ Exclusion List"
}

# On-prem extension variables

variable vpc_type {
  type    = string
  default = "dedicated"
  validation {
    condition     = contains(["<default>", "shared", "dedicated"], coalesce(var.vpc_type, "<default>"))
    error_message = "vpc_type can only be omitted, '<default>', 'shared' or 'dedicated'"
  }
  description = "VPC Type whether shared or dedicated"
}

variable subnet_share_pattern {
  type        = string
  default     = null
  description = "Subnet Share Pattern"
}

variable subnet_share_alt {
  type    = string
  default = null
  validation {
    condition     = contains(["<default>", "auto", "false", "true"], coalesce(var.subnet_share_alt, "<default>"))
    error_message = "subnet_share_alt can only be omitted, '<default>', 'auto', 'false' or 'true'"
  }
  description = "Subnet Share Alt"
}

variable dedicated_backend_cidr {
  type    = string
  description = "dedicated backend cidr"
  default = null
  validation {
    condition     = can(regex("^<default>|([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", coalesce(var.dedicated_backend_cidr, "<default>")))
    error_message = "dedicated_backend_cidr can only be omitted, '<default>' or a valid CIDR"
  }
}

variable frontend_netmask_length {
  type    = number
  default = null

  validation {
    condition     = var.frontend_netmask_length == "<default>" || can(tonumber(var.frontend_netmask_length))
    error_message = "Frontend subnet can be <default> or a number"
  }
  description = "Frontend Mask Length"
}


variable frontend_netmask_margin {
  type    = number
  default = null

  validation {
    condition     = var.frontend_netmask_margin == "<default>" || can(tonumber(var.frontend_netmask_margin))
    error_message = "Frontend netmask margin can be <default> or a number"
  }
  description = "Frontend Netmask Margin"
}


variable backend_netmask_length {
  type    = number
  default = null

  validation {
    condition     = var.backend_netmask_length == "<default>" || can(tonumber(var.backend_netmask_length))
    error_message = "Frontend subnet can be <default> or a number"
  }
  description = "Backend Mask Length"
}


variable backend_netmask_margin {
  type    = number
  default = null

  validation {
    condition     = var.backend_netmask_margin == "<default>" || can(tonumber(var.backend_netmask_margin))
    error_message = "Backend netmask margin can be <default> or a number"
  }
  description = "Backend Netmask Margin"
}
