terraform {
  # Will be filled in by terragrunt
  backend "s3" {}

  required_providers {
    aws = {
      version = "= 5.15.0"
    }
  }
}

#
# SFTP
#

data "aws_iam_policy_document" "assume_role_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "main" {
  count = var.role_arn == "" ? 1 : 0

  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_doc.json
}

data "aws_iam_policy_document" "role_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [
      var.home_directory_bucket.arn
    ]
  }
  statement {
    effect  = "Allow"
    actions = var.allowed_actions
    resources = [
      format("%s/%s*", var.home_directory_bucket.arn, var.home_directory_key_prefix)
    ]
  }
}

resource "aws_iam_role_policy" "main" {
  count = var.role_arn == "" ? 1 : 0

  name   = format("%s-policy", aws_iam_role.main[0].name)
  role   = aws_iam_role.main[0].name
  policy = data.aws_iam_policy_document.role_policy_doc.json
}

resource "aws_transfer_user" "main" {
  server_id           = var.sftp_server_id
  user_name           = var.user_name
  role                = var.role_arn == "" ? aws_iam_role.main[0].arn : var.role_arn
  home_directory      = format("/%s/%s", var.home_directory_bucket.id, var.home_directory_key_prefix)
  policy = <<POLICY
{
"Version": "2012-10-17",
"Statement": [
  {
    "Sid": "AllowListingOfUserFolder",
    "Action": [
      "s3:ListBucket"
    ],
    "Effect": "Allow",
    "Resource": [
      "arn:aws:s3:::$${transfer:HomeBucket}"
    ],
    "Condition": {
      "StringLike": {
        "s3:prefix": [
          "$${transfer:HomeFolder}/*",
          "$${transfer:HomeFolder}"
        ]
      }
    }
  },
  {
    "Sid": "HomeDirObjectAccess",
    "Effect": "Allow",
    "Action": [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:GetObjectVersion"
    ],
    "Resource": "arn:aws:s3:::$${transfer:HomeDirectory}*"
  }
]
}
POLICY
  tags = merge(
    var.tags,
    {
      "Automation" = "Terraform"
    },
  )
}

resource "aws_transfer_ssh_key" "main" {
  count = length(var.ssh_public_keys)

  server_id = var.sftp_server_id
  user_name = aws_transfer_user.main.user_name
  body      = var.ssh_public_keys[count.index]
}
