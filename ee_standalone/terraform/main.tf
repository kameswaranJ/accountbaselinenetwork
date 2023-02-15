data "aws_ssm_parameters_by_path" "deploy_vars" {
  provider = aws.deploy
  path     = local.lz_deploy_var_path
}

data "aws_ssm_parameters_by_path" "deploy_core_vars" {
  provider = aws.deploy_core
  path     = local.lz_deploy_var_path
}

module "baseline" {
  source    = "../../aws-account-baseline-no-onprem-dns"
  #source    = "../baseline"
  providers = {
    aws.app : aws.app
    aws.hub : aws.hub
    aws.hub_alt : aws.hub_alt
    aws.hub_core : aws.hub_core
    aws.shared : aws.shared
    aws.shared_core : aws.shared_core
    aws.deploy : aws.deploy
    aws.deploy_core : aws.deploy_core
    restapi.palo_alto : restapi.palo_alto
  }

  app_info                = local.app_info
  stla_region             = var.stla_region
  shared_role             = local.shared_role
  app_role                = local.app_role
  app_default_tags        = local.app_default_tags
  allow_downgrade         = var.allow_downgrade
  # allow_untagged          = var.allow_untagged
  flags                   = var.flags
  account_type            = var.account_type
  vpc_count               = var.vpc_count
  dedicated_backend_cidr  = var.dedicated_backend_cidr
  backend_subnet_count    = var.backend_subnet_count
  hosted_zone             = var.hosted_zone
  domain_name             = var.domain_name
  flow_logs_format        = var.flow_logs_format
  deploy_global_resources = var.deploy_global_resources
  vpc_size                = var.vpc_size
  cidr                    = var.cidr
  az_count                = var.az_count
  az_exclusion            = var.az_exclusion
  vpc_type                = var.vpc_type
  vpc_confidentiality     = var.vpc_confidentiality
  subnet_share_pattern    = var.subnet_share_pattern
  subnet_share_alt        = var.subnet_share_alt
  frontend_netmask_length = var.frontend_netmask_length
  frontend_netmask_margin = var.frontend_netmask_margin
  backend_netmask_length  = var.backend_netmask_length
  backend_netmask_margin  = var.backend_netmask_margin
}
