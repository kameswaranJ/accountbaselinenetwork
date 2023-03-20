resource "aws_iam_role" "aws_team_test_role" {
  name = "AWS-Team-Test"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "sso_inline_policy_test" {
  name   = "AwsSSOInlinePolicyTest"
  role   = aws_iam_role.aws_team_test_role.id
  policy = file("policy-aws-team-test.json")
}

data "aws_iam_policy" "iam_full_access" {
  arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

data "aws_iam_policy" "power_user_access" {
  arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role_policy_attachment" "iamfullaccess_role_policy_attach" {
  role       = aws_iam_role.aws_team_test_role.id
  policy_arn = data.aws_iam_policy.iam_full_access.arn
}

resource "aws_iam_role_policy_attachment" "poweruseraccess_role_policy_attach" {
  role       = aws_iam_role.aws_team_test_role.id
  policy_arn = data.aws_iam_policy.power_user_access.arn
}

resource "aws_iam_role" "role_publish_flowlogs_cloudwatch" {
  name = "PublishFlowLogsRole"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : "sts:AssumeRole"
        Sid : "",
        Effect : "Allow",
        Principal : {
          Service : "vpc-flow-logs.amazonaws.com",
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "policy_publish_flowlogs_cloudwatch" {
  name = "PublishVPCFlowLogsToCloudWatch"
  role = aws_iam_role.role_publish_flowlogs_cloudwatch.id
  #tfsec:ignore:aws-iam-no-policy-wildcards
  policy = file("policy-publish-flow-logs-cloudwatch.json")
}



data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# tflint-ignore: terraform_required_providers
data "template_file" "iam_policy_loggroup_kms_access" {
  # tflint-ignore: terraform_required_providers
  template = file("policy-loggroup-kms-access.tpl")
  vars = {
    region         = data.aws_region.current.name
    account_id     = data.aws_caller_identity.current.account_id
    log_group_name = var.log_group_name
  }
}

resource "aws_iam_role" "role_loggroup_access_kms" {
  name = "LogGroupKMSAccessRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "logs.${data.aws_region.current.name}.amazonaws.com",
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : "sts:AssumeRole",
      },
    ]
  })
}

resource "aws_iam_role_policy" "policy_loggroup_access_kms" {
  name = "LogGroupKMSAccessPolicy"
  role = aws_iam_role.role_loggroup_access_kms.id
  #tfsec:ignore:aws-iam-no-policy-wildcards
  policy = data.template_file.iam_policy_loggroup_kms_access.rendered
}
