data "aws_vpc_ipam_pool" "frontend" {
  provider = aws.shared_core

  filter {
    name   = "tag:subnet_type"
    values = ["frontend"]
  }

  filter {
    name   = "locale"
    values = [data.aws_region.current.id]
  }
}

module frontend_allocation {
  source    = "../subnet-allocation"
  providers = {
    aws.shared = aws.shared
  }

  name                = var.name
  ipam_pool_id        = data.aws_vpc_ipam_pool.frontend.id
  availability_zones  = var.availability_zones
  subnet_count        = 1
  netmask_length      = var.frontend_netmask_length
  netmask_bits_margin = var.frontend_netmask_margin
}

resource "aws_vpc" "main" {
  provider = aws.app

  cidr_block           = module.frontend_allocation.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-${var.name}"
  }
}

resource "aws_ec2_tag" "main_route_table" {
  provider = aws.app

  resource_id = aws_vpc.main.main_route_table_id
  key         = "Name"
  value       = "rt-${var.name}-main"
}

resource "aws_subnet" "frontend" {
  provider = aws.app
  for_each = module.frontend_allocation.subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]

  tags = {
    Name = "sn-${var.name}-frontend-${each.value["idx"]}-${each.value["az"]}"
  }
}

module backend_allocation {
  source    = "../subnet-allocation"
  providers = {
    aws.shared = aws.shared
  }

  name                = var.name
  cidr                = var.backend_cidr
  availability_zones  = var.availability_zones
  subnet_count        = var.backend_subnet_count
  netmask_length      = var.backend_netmask_length
  netmask_bits_margin = var.backend_netmask_margin
}

resource "aws_vpc_ipv4_cidr_block_association" "vpc_secondary_cidr" {
  provider = aws.app

  vpc_id     = aws_vpc.main.id
  cidr_block = module.backend_allocation.cidr
}

# /24 for each AZ
resource "aws_subnet" "backend" {
  provider = aws.app
  for_each = module.backend_allocation.subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]

  tags = {
    Name = "sn-${var.name}-backend-${each.value["idx"]}-${each.value["az"]}"
  }
}
