terraform {
  required_version = ">= 1.2.5"

  required_providers {
    # tflint-ignore: terraform_required_providers
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.53.0"
    }
    restapi = {
      source = "mastercard/restapi"
      version = "~> 1.18.0"
    }
  }
}
