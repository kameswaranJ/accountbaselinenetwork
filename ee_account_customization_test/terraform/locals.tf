data "aws_caller_identity" "current" {}

locals {
  
  # LUT of alternate regions for failover
  alt_regions = {
    "eu-west-3" : "eu-west-1",
    "eu-west-1" : "eu-west-3"
  }

  # Basic info derived from the workspace name
  app_info = {
    app_name: var.app_name,
    env_name: var.env_name,
    account_id: data.aws_caller_identity.current.account_id,
    region: var.region
  }

  # AFTExecution role in the target account
  app_role    =  "arn:aws:iam::${local.app_info["account_id"]}:role/AWSAFTExecution"

  # Deploy account
  deploy_role = "arn:aws:iam::805943475983:role/STLA-Terraform-LZ-Provisioning"

  # Shared network hub (non prod control tower)
  hub_role    = "arn:aws:iam::635729853710:role/STLA-Terraform-LZ-Provisioning"

  # same as hub_role for hackathon (unused) but should be updated to shared network
  shared_role = "arn:aws:iam::635729853710:role/STLA-Terraform-LZ-Provisioning"

  app_default_tags = {
    appid       = local.app_info["app_name"]
    environment = local.app_info["env_name"]
    stla_lz     = "true"
  }

  generic_default_tags = {
    stla_lz = "true"
  }
}
