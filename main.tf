locals {
  create_iam_role = var.role_arn == ""
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
  count = local.create_iam_role ? 1 : 0

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
  count = local.create_iam_role ? 1 : 0

  name   = format("%s-policy", aws_iam_role.main[0].name)
  role   = aws_iam_role.main[0].name
  policy = data.aws_iam_policy_document.role_policy_doc.json
}

resource "aws_transfer_user" "main" {
  server_id      = var.sftp_server_id
  user_name      = var.user_name
  role           = local.create_iam_role ? aws_iam_role.main[0].arn : var.role_arn
  home_directory = format("/%s/%s", var.home_directory_bucket.id, var.home_directory_key_prefix)

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
