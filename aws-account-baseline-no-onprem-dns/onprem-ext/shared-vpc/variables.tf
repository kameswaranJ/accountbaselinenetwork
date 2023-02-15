variable name {
  type = string
}

variable shared_role {
  type = string
}

variable subnet_resource_share {
  type = string
}

variable backend_subnet_count {
  type = number
}

variable backend_netmask_length {
  type    = number
}

variable app_default_tags {
  type    = map(string)
}

variable legacy_subnet_allocation {
  type = bool
}
