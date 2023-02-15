terraform {
  required_providers {
    aws = {
      configuration_aliases = [aws.app, aws.hub]
    }
  }
}

data "aws_caller_identity" "app" {
  provider = aws.app
}

# VPCs
module "vpc" {
  source     = "./vpc"
  count      = var.vpc_count
  # Cannot proceed if principal association is not complete
  depends_on = [aws_vpc_endpoint_service_allowed_principal.firewall]
  providers  = {
    aws.app : aws.app
    aws.hub : aws.hub
  }

  fq_name              = var.fqName
  name                 = "${var.fqName}-${count.index}"
  cidr                 = cidrsubnet(var.cidr, var.vpc_size == "large" ? 2 : 3, count.index)
  availability_zones   = var.availability_zones
  fw_eps_name          = var.fw_eps_name
  endpoint_services    = var.endpoint_services
  vpc_size             = var.vpc_size
  backend_subnet_count = var.backend_subnet_count
  tags                 = var.tags
  flow_logs_format     = var.flow_logs_format
  flow_logs_role_arn   = var.flow_logs_role_arn
}
