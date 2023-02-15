terraform {
  required_providers {
    aws = {
      configuration_aliases = [
        aws.app,
        aws.hub,
        aws.hub_alt,
        aws.hub_core,
        aws.shared,
        aws.shared_core,
        aws.deploy,
        aws.deploy_core,
      ]
    }
    restapi = {
      source                = "mastercard/restapi"
      configuration_aliases = [
        restapi.palo_alto
      ]
    }
  }
}

data "aws_region" "current" {
  provider = aws.app
}

data "aws_region" "core" {
  provider = aws.deploy_core
}

data "aws_region" "alt" {
  provider = aws.hub_alt
}

data "aws_caller_identity" "app" {
  provider = aws.app
}

data "aws_caller_identity" "shared" {
  provider = aws.shared
}

data "aws_availability_zones" "all" {
  provider = aws.app
  state    = "available"

  lifecycle {
    # Before doing anything meaningful we check the workspace is properly named
    precondition {
      condition     = length(local.app_info["app_name"]) > 0 && length(local.app_info["env_name"]) > 0
      error_message = "Application identity cannot be determined"
    }
    precondition {
      condition     = contains(["standalone", "onprem-ext"], local.account_type)
      error_message = "Variable account_type must be either 'standalone' or 'onprem-ext'"
    }
  }

  filter {
    name   = "group-name"
    values = [data.aws_region.current.id]
  }
}

data "aws_iam_role" "vpc_flow_logs" {
  provider = aws.app
  count    = local.deploy_global_resources ? 0 : 1

  name = "role-${local.fqName}-vpc-flow-logs"
}

locals {
  version_raw              = trimspace(file("${path.module}/VERSION"))
  version_to_deploy        = regex("^v(?P<x>\\d+)\\.?(?P<y>\\d+)\\.?(?P<z>\\d+)(?P<count>-[0-9]+)?(?P<hash>-[a-z0-9]+)?$", local.version_raw)
  version_already_deployed = regex("^v(?P<x>\\d+)\\.?(?P<y>\\d+)\\.?(?P<z>\\d+)(?P<count>-[0-9]+)?(?P<hash>-[a-z0-9]+)?$", nonsensitive(lookup(local.ssm_app_vars, "version", "v0.0.0")))
}

resource null_resource version_check {
  lifecycle {
    precondition {
      condition     = var.allow_downgrade || (tonumber(local.version_to_deploy["x"]) > tonumber(local.version_already_deployed["x"])) || (tonumber(local.version_to_deploy["x"]) == tonumber(local.version_already_deployed["x"]) && tonumber(local.version_to_deploy["y"]) > tonumber(local.version_already_deployed["y"])) || (tonumber(local.version_to_deploy["x"]) == tonumber(local.version_already_deployed["x"]) && tonumber(local.version_to_deploy["y"]) == tonumber(local.version_already_deployed["y"]) && tonumber(local.version_to_deploy["z"]) >= tonumber(local.version_already_deployed["z"]))
      error_message = "Version downgrade is blocked. You can force it with -var 'allow_downgrade=true'"
    }
  }
}

module "global" {
  source    = "./global"
  count     = local.deploy_global_resources ? 1 : 0
  providers = {
    aws.app : aws.app
    aws.deploy : aws.deploy
  }

  account_id     = data.aws_caller_identity.app.account_id
  fq_name        = local.fqName
  secret_regions = [for region in split(",", nonsensitive(local.ssm_deploy_vars["operating_regions"])) : region if region != data.aws_region.current.id]
}
