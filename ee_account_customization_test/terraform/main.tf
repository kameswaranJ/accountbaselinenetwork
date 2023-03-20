
module "baseline" {
  source = "git::https://github.psa-cloud.com/T0082FN/fo-aws-account-baseline.git?ref=aft"
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
  version_to_deploy       = "0.0.0"
  allow_downgrade         = true
  app_default_tags        = local.app_default_tags
  flags                   = var.flags
  app_role                = local.app_role
  shared_role             = local.shared_role
  account_type            = var.account_type
  vpc_count               = var.vpc_count
  backend_subnet_count    = var.backend_subnet_count
  hosted_zone             = var.hosted_zone
  domain_name             = var.domain_name
  flow_logs_format        = var.flow_logs_format
  deploy_global_resources = var.deploy_global_resources
  vpc_size                = var.vpc_size
  cidr                    = var.cidr
  az_count                = var.az_count
  fw_attachment_enable    = var.fw_attachment_enable
  az_exclusion            = var.az_exclusion
  vpc_type                = var.vpc_type
  subnet_share_pattern    = var.subnet_share_pattern
  subnet_share_alt        = var.subnet_share_alt
  frontend_netmask_length = var.frontend_netmask_length
  frontend_netmask_margin = var.frontend_netmask_margin
  backend_netmask_length  = var.backend_netmask_length
  backend_netmask_margin  = var.backend_netmask_margin
}


output "target_account_id" {
  value       = local.app_info["account_id"]
  description = "Target Account ID"
}
