# Deploy account in the target region (local parameters and resources)
provider "aws" {
  region = local.app_info["region"]
  alias  = "deploy"

  assume_role {
    role_arn = local.deploy_role
  }

  default_tags {
    tags = local.generic_default_tags
  }
}

# Deploy account in the core region (central parameters and resources)
provider "aws" {
  alias = "deploy_core"

  assume_role {
    role_arn = local.deploy_role
  }

  default_tags {
    tags = local.generic_default_tags
  }
}

# Network HUB account in the target region
provider "aws" {
  region = local.app_info["region"]
  alias  = "hub"

  assume_role {
    role_arn = local.hub_role
  }

  default_tags {
    tags = local.generic_default_tags
  }
}

# Network HUB account in the alternate region (for failover purposes like DNS forwarding)
provider "aws" {
  region = local.alt_regions[local.app_info["region"]]
  alias  = "hub_alt"

  assume_role {
    role_arn = local.hub_role
  }

  default_tags {
    tags = local.generic_default_tags
  }
}

# Network HUB account in the alternate region (for failover purposes like DNS forwarding)
provider "aws" {
  alias = "hub_core"

  assume_role {
    role_arn = local.hub_role
  }

  default_tags {
    tags = local.generic_default_tags
  }
}

# Shared networks account in the target region
provider "aws" {
  region = local.app_info["region"]
  alias  = "shared"

  assume_role {
    role_arn = local.shared_role
  }

  default_tags {
    tags = local.generic_default_tags
  }
}

# Shared networks account in the core region (for central config like IPAM)
provider "aws" {
  alias = "shared_core"

  assume_role {
    role_arn = local.shared_role
  }

  default_tags {
    tags = local.generic_default_tags
  }
}

# App account in the target region
provider "aws" {
  region = local.app_info["region"]
  alias  = "app"

  assume_role {
    role_arn = local.app_role
  }

  default_tags {
    tags = local.app_default_tags
  }
}

provider "restapi" {
  alias = "palo_alto"

  # intranet: "https://preprod.api.inetpsa.com/dev/private/applications/toolbox-eoop/awspan/v1"
  uri                  = "https://dummy"
  write_returns_object = true
  headers              = {
  }
}
