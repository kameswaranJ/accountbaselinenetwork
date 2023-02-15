module "onprem-ext" {
  source    = "./onprem-ext"
  count     = (local.account_type == "onprem-ext") ? 1 : 0
  providers = {
    aws.app : aws.app
    aws.hub : aws.hub
    aws.hub_alt : aws.hub_alt
    aws.hub_core : aws.hub_core
    aws.shared : aws.shared
    aws.shared_core : aws.shared_core
  }

  deploy_global_resources   = local.deploy_global_resources
  fqName                    = local.fqName
  is_prod                   = local.is_prod
  domain_name               = local.domain_name
  hosted_zone               = local.hosted_zone
  vpc_count                 = local.vpc_count
  frontend_netmask_length   = local.frontend_netmask_length
  frontend_netmask_margin   = local.frontend_netmask_margin
  backend_netmask_length    = local.backend_netmask_length
  backend_netmask_margin    = local.backend_netmask_margin
  backend_subnet_count      = local.backend_subnet_count
  subnet_resource_share     = local.effective_subnet_resource_share
  dns_forwarding_vpc_id     = nonsensitive(local.ssm_deploy_vars["dns_forwarding_vpc_id_${data.aws_region.current.id}"])
  dns_forwarding_vpc_id_alt = nonsensitive(local.ssm_deploy_vars["dns_forwarding_vpc_id_${data.aws_region.alt.id}"])
  dns_forward_share         = nonsensitive(local.ssm_deploy_vars["dns_ram_share"])
  availability_zones        = local.effective_azs
  backend_cidr              = local.dedicated_backend_cidr
  # TODO: remove fallback when tgw_id and tgw_share_name parameters are consistent between regions
  tgw_id                    = nonsensitive(try(local.is_prod ? local.ssm_deploy_vars["tgw_id_prod"] : local.ssm_deploy_vars["tgw_id_nonprod"], local.ssm_deploy_vars["tgw_id"]))
  tgw_share_name            = nonsensitive(try(local.is_prod ? local.ssm_deploy_vars["tgw_share_name_prod"] : local.ssm_deploy_vars["tgw_share_name_nonprod"], local.ssm_deploy_vars["tgw_share_name_prod"]))
  vpc_type                  = local.vpc_type
  legacy_subnet_allocation  = contains(local.flags, "LEGACY_SUBNET_ALLOCATION")
  app_default_tags          = var.app_default_tags # TODO use another way
  shared_role               = var.shared_role
  flow_logs_format          = local.flow_logs_format
  flow_logs_role_arn        = local.deploy_global_resources ? module.global[0].flow_logs_role_arn : data.aws_iam_role.vpc_flow_logs[0].arn
}

module "standalone" {
  source    = "./standalone"
  count     = (local.account_type == "standalone") ? 1 : 0
  providers = {
    aws.app : aws.app
    aws.hub : aws.hub
  }

  deploy_global_resources = local.deploy_global_resources
  fqName                  = local.fqName
  is_prod                 = local.is_prod
  availability_zones      = local.effective_azs
  cidr                    = local.cidr
  fw_eps_name             = nonsensitive(local.ssm_deploy_vars["fw_eps_name"])
  endpoint_services       = [for eps in (nonsensitive(local.is_prod ? split(",", trimspace(local.ssm_deploy_vars["shared_services_prod"])) : setunion(split(",", trimspace(local.ssm_deploy_vars["shared_services_non_prod"])), split(",", trimspace(local.ssm_deploy_vars["shared_services_prod"]))))) : eps if eps != ""]
  domain_name             = local.domain_name
  hosted_zone             = local.hosted_zone
  vpc_count               = local.vpc_count
  vpc_size                = local.vpc_size
  backend_subnet_count    = local.backend_subnet_count
  tags                    = var.app_default_tags # TODO use another way
  flow_logs_format        = local.flow_logs_format
  flow_logs_role_arn      = local.deploy_global_resources ? module.global[0].flow_logs_role_arn : data.aws_iam_role.vpc_flow_logs[0].arn
}

