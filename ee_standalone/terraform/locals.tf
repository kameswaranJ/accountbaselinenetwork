data "aws_caller_identity" "current" {}


locals {
  all_config = yamldecode(file("${path.module}/config/${var.stla_region}/config.yaml"))
  # config     = lookup(lookup(lookup(local.all_config, "regions", {}), var.region, {}), var.env_name, {})

  # IAM roles
  shared_role = var.env_name == "prod" ? local.all_config["terraform"]["roles"]["shared"]["prod"] : local.all_config["terraform"]["roles"]["shared"]["nonprod"]
  deploy_role = local.all_config["terraform"]["roles"]["deploy"]
  hub_role    = local.all_config["terraform"]["roles"]["hub"]
  app_role    =  "arn:aws:iam::${local.app_info["account_id"]}:role/STLA-Terraform-LZ-Provisioning"

  # LUT of alternate regions for failover
  alt_regions = local.all_config["alt_regions"]

  # Deploy variables
  # TODO move them to an external module (duplicated in ssm_lz_parameters.tf in baseline module)
  lz_deploy_var_path    = "/lz/tfvars"
  ssm_deploy_core_vars  = zipmap([for k in data.aws_ssm_parameters_by_path.deploy_core_vars.names : substr(k, length(local.lz_deploy_var_path) + 1, -1)], data.aws_ssm_parameters_by_path.deploy_core_vars.values)
  ssm_deploy_local_vars = zipmap([for k in data.aws_ssm_parameters_by_path.deploy_vars.names : substr(k, length(local.lz_deploy_var_path) + 1, -1)], data.aws_ssm_parameters_by_path.deploy_vars.values)
  ssm_deploy_vars       = merge(local.ssm_deploy_core_vars, local.ssm_deploy_local_vars)

  # Basic info derived from the workspace name
  # workspace_info = regex("(?P<app_name>[a-z0-9-]+)_(?P<env_name>[a-z0-9-]+)_(?P<account_id>[0-9]+)_(?P<region>[a-z0-9-]+)", terraform.workspace)
  # is_prod        = var.env_name == "prod"

  app_info = {
    app_name: var.app_name,
    env_name: var.env_name,
    account_id: data.aws_caller_identity.current.account_id,
    region: var.region
  }

  app_default_tags = {
    appid       = var.app_name
    environment = var.env_name
    stla_lz     = "true"
  }

  generic_default_tags = {
    stla_lz = "true"
  }
}
