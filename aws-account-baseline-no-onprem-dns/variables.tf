variable app_info {
  type = object({
    app_name : string
    env_name : string
    region : string
  })
}

variable stla_region {
  type = string
}

variable shared_role {
  type = string
}

variable app_role {
  type = string
}

# Version variables
variable allow_downgrade {
  type    = bool
  default = false
}

# Common variables
variable app_default_tags {
  type = map(string)
}

variable flags {
  type    = string
  default = null
  validation {
    condition     = can(regex("^<default>|[^,(?! )]*$", coalesce(var.flags, "<default>")))
    error_message = "flags can only be omitted, '<default>' or a list of separated flag names"
  }
}

variable account_type {
  type    = string
  default = null
  validation {
    condition     = contains(["<default>", "standalone", "onprem-ext"], coalesce(var.account_type, "<default>"))
    error_message = "account_type can only be omitted, '<default>', 'standalone' or 'onprem-ext'"
  }
}

variable vpc_count {
  type    = string
  default = null
  validation {
    condition     = can(regex("^<default>|[1-8]$", coalesce(var.vpc_count, "<default>")))
    error_message = "vpc_count can only be omitted, '<default>' or '1' to '8'"
  }
}

variable backend_subnet_count {
  type    = string
  default = null
  validation {
    condition     = can(regex("^<default>|[1-6]$", coalesce(var.backend_subnet_count, "<default>")))
    error_message = "backend_subnet_count can only be omitted, '<default>' or '1' to '6'"
  }
}

variable hosted_zone {
  type    = string
  default = null
}

variable domain_name {
  type    = string
  default = null
}

variable flow_logs_format {
  type    = string
  default = null
}

variable deploy_global_resources {
  type    = bool
  default = null
}

variable vpc_confidentiality {
  type    = string
  default = null
  validation {
    condition     = contains([
      "<default>", "standard", "sensitive", "confidential"
    ], coalesce(var.vpc_confidentiality, "<default>"))
    error_message = "vpc_criticality can only be omitted, '<default>', 'standard', 'sensitive' or 'confidential'"
  }
  description = "Degree of data confidentiality for the VPC"
}

# Standalone variables
variable vpc_size {
  type    = string
  default = null
  validation {
    condition     = contains(["<default>", "normal", "large"], coalesce(var.vpc_size, "<default>"))
    error_message = "vpc_size can only be omitted, '<default>', 'normal' or 'large'"
  }
}

variable cidr {
  type    = string
  default = null
  validation {
    condition     = can(regex("^<default>|([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", coalesce(var.cidr, "<default>")))
    error_message = "cidr can only be omitted, '<default>' or a valid CIDR"
  }
}

variable az_count {
  type    = string
  default = null
  validation {
    condition     = can(regex("^<default>|[1-4]$", coalesce(var.az_count, "<default>")))
    error_message = "az_count can only be omitted, '<default>' or '1' to '4'"
  }
}

variable az_exclusion {
  type    = string
  default = null
  validation {
    condition     = can(regex("^<default>|<none>|[a-z0-9-]+(,[a-z0-9-]+)*$", coalesce(var.az_exclusion, "<default>")))
    error_message = "az_exclusion can only be omitted, '<default>', '<none>' or a comma separated list of AZ"
  }
}

# On-prem extension variables
variable vpc_type {
  type    = string
  default = null
  validation {
    condition     = contains(["<default>", "shared", "dedicated"], coalesce(var.vpc_type, "<default>"))
    error_message = "vpc_type can only be omitted, '<default>', 'shared' or 'dedicated'"
  }
}

variable subnet_share_pattern {
  type    = string
  default = null
}

variable subnet_share_alt {
  type    = string
  default = null
  validation {
    condition     = contains(["<default>", "auto", "false", "true"], coalesce(var.subnet_share_alt, "<default>"))
    error_message = "subnet_share_alt can only be omitted, '<default>', 'auto', 'false' or 'true'"
  }
}

variable dedicated_backend_cidr {
  type    = string
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
}

variable frontend_netmask_margin {
  type    = number
  default = null

  validation {
    condition     = var.frontend_netmask_margin == "<default>" || can(tonumber(var.frontend_netmask_margin))
    error_message = "Frontend netmask margin can be <default> or a number"
  }
}

variable backend_netmask_length {
  type    = number
  default = null

  validation {
    condition     = var.backend_netmask_length == "<default>" || can(tonumber(var.backend_netmask_length))
    error_message = "Frontend subnet can be <default> or a number"
  }
}

variable backend_netmask_margin {
  type    = number
  default = null

  validation {
    condition     = var.backend_netmask_margin == "<default>" || can(tonumber(var.backend_netmask_margin))
    error_message = "Backend netmask margin can be <default> or a number"
  }
}
