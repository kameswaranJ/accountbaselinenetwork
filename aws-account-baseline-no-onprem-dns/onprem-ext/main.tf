terraform {
  required_providers {
    aws = {
      configuration_aliases = [aws.app, aws.hub, aws.hub_alt, aws.hub_core, aws.shared, aws.shared_core]
    }
  }
}

data "aws_caller_identity" "app" {
  provider = aws.app
}

data "aws_region" "alt" {
  provider = aws.hub_alt
}

module "dedicated_vpc" {
  source    = "./dedicated-vpc"
  count     = var.vpc_type == "dedicated" ? var.vpc_count : 0
  providers = {
    aws.app : aws.app
    aws.hub : aws.hub
    aws.shared : aws.shared
    aws.shared_core : aws.shared_core
  }

  availability_zones      = var.availability_zones
  fqName                  = var.fqName
  name                    = "${var.fqName}-${count.index}"
  frontend_netmask_length = var.frontend_netmask_length
  frontend_netmask_margin = var.frontend_netmask_margin
  backend_netmask_length  = var.backend_netmask_length
  backend_netmask_margin  = var.backend_netmask_margin
  backend_subnet_count    = var.backend_subnet_count
  backend_cidr            = var.backend_cidr
  tgw_id                  = var.tgw_id
  tgw_share_name          = var.tgw_share_name
  dns_share_name          = var.dns_forward_share
  flow_logs_format        = var.flow_logs_format
  flow_logs_role_arn      = var.flow_logs_role_arn
}

module "shared_vpc" {
  source    = "./shared-vpc"
  count     = var.vpc_type == "shared" ? 1 : 0
  providers = {
    aws.app : aws.app
    aws.hub : aws.hub
    aws.shared : aws.shared
    aws.shared_core : aws.shared_core
  }

  name                     = "${var.fqName}-${count.index}"
  subnet_resource_share    = var.subnet_resource_share
  backend_netmask_length   = var.backend_netmask_length
  backend_subnet_count     = var.backend_subnet_count
  legacy_subnet_allocation = var.legacy_subnet_allocation
  app_default_tags         = var.app_default_tags
  shared_role              = var.shared_role
}

locals {
  all_vpcs = (var.vpc_type == "shared" ? module.shared_vpc : module.dedicated_vpc)
}
