# © 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
#

variable "vpc_cidr" {
  description = "CIDR of the VPC"
  type        = string
  validation {
    condition     = can(regex("^(([0-9]{1,3}\\.){3})(([0-9]{1,3}))(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.vpc_cidr))
    error_message = "Variable var: vpc_id is not valid."
  }
  default = "10.55.88.0/24"
}

variable "subnet1_cidr" {
  description = "CIDR of the Subnet 1"
  type        = string
  validation {
    condition     = can(regex("^(([0-9]{1,3}\\.){3})(([0-9]{1,3}))(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.subnet1_cidr))
    error_message = "Variable var: subnet1_cidr is not valid."
  }
  default = "10.55.88.0/26"
}

variable "subnet2_cidr" {
  description = "CIDR of the Subnet 2"
  type        = string
  validation {
    condition     = can(regex("^(([0-9]{1,3}\\.){3})(([0-9]{1,3}))(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.subnet2_cidr))
    error_message = "Variable var: subnet2_cidr is not valid."
  }
  default = "10.55.88.64/26"
}

variable "log_group_name" {
  description = "CloudWatch Log Group name"
  type        = string
  default     = "VPCFlowLogs"
}
