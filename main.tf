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
    resources = [var.home_directory_bucket_arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectACL",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:PutObjectACL",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion"
    ]
    resources = [format("%s/*", var.home_directory_bucket_arn)]
  }
}

resource "aws_iam_role_policy" "main" {
  name   = format("%s-policy", aws_iam_role.main.name)
  role   = aws_iam_role.main.name
  policy = data.aws_iam_policy_document.role_policy_doc.json
}

resource "aws_transfer_user" "main" {
  server_id      = var.sftp_server_id
  user_name      = var.user_name
  role           = aws_iam_role.main.arn
  home_directory = format("/%s/", var.home_directory_bucket_id)

  tags = merge(
    var.tags,
    {
      "Automation" = "Terraform"
    },
  )
}

resource "aws_transfer_ssh_key" "main" {
  count     = length(var.ssh_public_keys)
  server_id = var.sftp_server_id
  user_name = aws_transfer_user.main.user_name
  body      = var.ssh_public_keys[count.index]
}
