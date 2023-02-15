variable cidr {
  type    = string
  default = null
}

variable ipam_pool_id {
  type    = string
  default = null
}

variable name {
  type = string
}

variable availability_zones {
  type = list(string)
}

variable subnet_count {
  type = number
}

variable netmask_length {
  type = number
}

variable netmask_bits_margin {
  type    = number
  default = 0
}
