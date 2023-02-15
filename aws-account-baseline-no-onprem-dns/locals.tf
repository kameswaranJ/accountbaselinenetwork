locals {
  # Basic info derived from the workspace name
  app_info = var.app_info
  is_prod  = local.app_info["env_name"] == "prod"
  is_core  = data.aws_region.current.id == data.aws_region.core.id
  prefix   = local.is_prod ? "" : "np-"
  fqName   = "${local.prefix}${local.app_info["app_name"]}-${local.app_info["env_name"]}"

  # VPCLink is not available in the following AZs so we exclude them by default
  default_az_exclusion = "eu-west-3b,us-east-1c,us-west-1b,ap-east-1a,ap-northeast-1c,ca-central-1c"

  # Info coalesced from: explicit variable -> SSM var -> default value
  account_type            = nonsensitive(coalesce(var.account_type == "<default>" ? null : var.account_type, lookup(local.ssm_app_vars, "account_type", "standalone")))
  hosted_zone             = nonsensitive(coalesce(var.hosted_zone == "<default>" ? null : var.hosted_zone, lookup(local.ssm_app_vars, "hosted_zone", local.account_type == "standalone" ? local.ssm_deploy_vars["default_public_hosted_zone"] : local.ssm_deploy_vars["default_private_hosted_zone"])))
  domain_name             = nonsensitive(coalesce(var.domain_name == "<default>" ? null : var.domain_name, lookup(local.ssm_app_vars, "domain_name", local.is_prod ? local.app_info["app_name"] : "${local.app_info["app_name"]}-${local.app_info["env_name"]}")))
  flow_logs_format        = nonsensitive(coalesce(var.flow_logs_format == "<default>" ? null : var.flow_logs_format, lookup(local.ssm_app_vars, "flow_logs_format", "$${account-id} $${action} $${az-id} $${bytes} $${dstaddr} $${dstport} $${end} $${interface-id} $${instance-id} $${flow-direction} $${packets} $${protocol} $${start} $${subnet-id} $${vpc-id} $${version} $${tcp-flags} $${srcaddr} $${srcport} $${pkt-dstaddr} $${pkt-srcaddr} $${region} $${traffic-path}")))
  deploy_global_resources = nonsensitive(coalesce(var.deploy_global_resources == "<default>" ? null : var.deploy_global_resources, tobool(lookup(local.ssm_app_vars, "deploy_global_resources", "true"))))
  vpc_confidentiality     = nonsensitive(coalesce(var.vpc_confidentiality == "<default>" ? null : var.vpc_confidentiality, lookup(local.ssm_app_vars, "vpc_confidentiality", "standard")))
  vpc_type                = nonsensitive(coalesce(var.vpc_type == "<default>" ? null : var.vpc_type, lookup(local.ssm_app_vars, "vpc_type", "shared")))
  vpc_count               = tonumber(nonsensitive(coalesce(var.vpc_count == "<default>" ? null : var.vpc_count, lookup(local.ssm_app_vars, "vpc_count", "1"))))
  frontend_netmask_length = tonumber(nonsensitive(coalesce(var.frontend_netmask_length == "<default>" ? null : var.frontend_netmask_length, lookup(local.ssm_app_vars, "frontend_netmask_length", "28"))))
  frontend_netmask_margin = tonumber(nonsensitive(coalesce(var.frontend_netmask_margin == "<default>" ? null : var.frontend_netmask_margin, lookup(local.ssm_app_vars, "frontend_netmask_margin", "0"))))
  backend_netmask_length  = tonumber(nonsensitive(coalesce(var.backend_netmask_length == "<default>" ? null : var.backend_netmask_length, lookup(local.ssm_app_vars, "backend_netmask_length", "26"))))
  backend_netmask_margin  = tonumber(nonsensitive(coalesce(var.backend_netmask_margin == "<default>" ? null : var.backend_netmask_margin, lookup(local.ssm_app_vars, "backend_netmask_margin", "0"))))
  backend_subnet_count    = tonumber(nonsensitive(coalesce(var.backend_subnet_count == "<default>" ? null : var.backend_subnet_count, lookup(local.ssm_app_vars, "backend_subnet_count", "2"))))
  dedicated_backend_cidr  = nonsensitive(coalesce(var.dedicated_backend_cidr == "<default>" ? null : var.dedicated_backend_cidr, lookup(local.ssm_app_vars, "dedicated_backend_cidr", "100.126.0.0/16")))
  vpc_size                = nonsensitive(coalesce(var.vpc_size == "<default>" ? null : var.vpc_size, lookup(local.ssm_app_vars, "vpc_size", "normal")))
  cidr                    = nonsensitive(coalesce(var.cidr == "<default>" ? null : var.cidr, lookup(local.ssm_app_vars, "cidr", "192.168.0.0/16")))
  az_count                = tonumber(nonsensitive(coalesce(var.az_count == "<default>" ? null : var.az_count, lookup(local.ssm_app_vars, "az_count", "2"))))
  az_exclusion_raw        = nonsensitive(coalesce(var.az_exclusion == "<default>" ? null : var.az_exclusion, lookup(local.ssm_app_vars, "az_exclusion", local.default_az_exclusion)))
  az_exclusion            = split(",", local.az_exclusion_raw == "<none>" ? "" : local.az_exclusion_raw)
  subnet_share_pattern    = nonsensitive(coalesce(var.subnet_share_pattern == "<default>" ? null : var.subnet_share_pattern, lookup(local.ssm_app_vars, "subnet_share_pattern", local.ssm_deploy_vars["default_subnet_share_pattern"])))
  subnet_share_alt        = nonsensitive(coalesce(var.subnet_share_alt == "<default>" ? null : var.subnet_share_alt, lookup(local.ssm_app_vars, "subnet_share_alt", "auto")))
  flags_raw               = nonsensitive(coalesce(var.flags == "<default>" ? null : var.flags, lookup(local.ssm_app_vars, "flags", "<none>")))
  flags                   = [for f in split(",", local.flags_raw == "<none>" ? "" : local.flags_raw) : trimspace(f)]

  # Take into account AZ exclusion if it's still possible to reach the required AZ count (otherwise consider all *supported* AZs)
  supported_azs = sort([for az_id in split(",", nonsensitive(local.ssm_deploy_vars["supported_availability_zones"])) : data.aws_availability_zones.all.names[index(data.aws_availability_zones.all.zone_ids, az_id)] if contains(data.aws_availability_zones.all.zone_ids, az_id)])
  filtered_azs  = [for az in local.supported_azs : az if !contains(local.az_exclusion, az)]
  effective_azs = slice(local.az_count <= length(local.filtered_azs) ? local.filtered_azs : local.supported_azs, 0, local.az_count)

  effective_subnet_share_alt      = local.subnet_share_alt == "auto" ? false : tobool(local.subnet_share_alt)
  effective_subnet_resource_share = replace(replace(replace(replace(local.subnet_share_pattern, "%env_prefix%", local.prefix), "%alt_suffix%", local.effective_subnet_share_alt ? "-alt" : ""), "%az_count%", local.az_count), "%confidentiality%", local.vpc_confidentiality == "standard" ? "" : "-${local.vpc_confidentiality}")
}
