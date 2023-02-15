resource "aws_vpc" "standalone" {
  provider = aws.app

  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-${var.name}"
  }
}

# Frontend subnets are always /24
resource "aws_subnet" "public" {
  provider = aws.app
  for_each = toset(var.availability_zones)

  vpc_id            = aws_vpc.standalone.id
  cidr_block        = cidrsubnet(aws_vpc.standalone.cidr_block, var.vpc_size == "large" ? 6 : 5, 0 + index(var.availability_zones, each.value))
  availability_zone = each.value

  tags = {
    Name        = "sn-${var.name}-public-${each.value}"
    subnet_type = "frontend"
  }
}

# Backend subnets are /24 on normal VPCs, /23 on large VPCs
locals {
  backend_subnets = {
  for i in setproduct(var.availability_zones, range(0, var.backend_subnet_count, 1)) : format("%s_%s", i[1], i[0]) => {
    az : i[0]
    idx : i[1]
    cidr : cidrsubnet(aws_vpc.standalone.cidr_block, 5, 10 + (i[1] * length(var.availability_zones) + index(var.availability_zones, i[0])))
  }
  }
}

resource "aws_subnet" "private" {
  provider = aws.app
  for_each = local.backend_subnets

  vpc_id            = aws_vpc.standalone.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]

  tags = {
    Name         = "sn-${var.name}-private-${each.value["idx"]}-${each.value["az"]}"
    subnet_type  = "backend"
    subnet_index = each.value["idx"]
  }
}

resource "aws_subnet" "firewall" {
  provider = aws.app
  for_each = toset(var.availability_zones)

  vpc_id            = aws_vpc.standalone.id
  cidr_block        = cidrsubnet(aws_vpc.standalone.cidr_block, var.vpc_size == "large" ? 6 : 5, (var.vpc_size == "large" ? 63 : 31) - index(var.availability_zones, each.value))
  availability_zone = each.value

  tags = {
    Name        = "sn-${var.name}-firewall-${each.value}"
    subnet_type = "lz-reserved"
  }
}

resource "aws_internet_gateway" "igw" {
  provider = aws.app
  vpc_id   = aws_vpc.standalone.id

  tags = {
    Name = "igw-${var.name}"
  }
}
