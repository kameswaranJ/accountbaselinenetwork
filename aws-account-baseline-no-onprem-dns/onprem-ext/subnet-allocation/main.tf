locals {
  total_subnet_count = length(var.availability_zones) * var.subnet_count
  # Amount of netmask bits necessary to fit all subnets: ceil(log2(total_subnet_count))
  bit_shift          = ceil(log(local.total_subnet_count, 2)) + var.netmask_bits_margin
}

terraform {
  required_providers {
    aws = {
      configuration_aliases = [aws.shared]
    }
  }
}

resource "aws_vpc_ipam_pool_cidr_allocation" "full" {
  provider = aws.shared
  count    = var.ipam_pool_id != null ? 1 : 0

  ipam_pool_id   = var.ipam_pool_id
  netmask_length = var.netmask_length - local.bit_shift
  description    = "IP allocation for vpc-${var.name}"
}

locals {
  effective_cidr = var.ipam_pool_id != null ? aws_vpc_ipam_pool_cidr_allocation.full[0].cidr : var.cidr
  subnets        = {
  for i in setproduct(var.availability_zones, range(0, var.subnet_count, 1)) : format("%s_%s", i[1], i[0]) => {
    az : i[0]
    idx : i[1]
    cidr : cidrsubnet(local.effective_cidr, local.bit_shift, i[1]*length(var.availability_zones) + index(var.availability_zones, i[0]))
  }
  }
}

moved {
  from = aws_vpc_ipam_pool_cidr_allocation.full
  to   = aws_vpc_ipam_pool_cidr_allocation.full[0]
}
