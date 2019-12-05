/**
 * Creates a user for an AWS Transfer for SFTP endpoint.
 *
 * Creates the following resources:
 *
 * * AWS Transfer user
 * * IAM policy for the user to access S3.
 * * SSH Keys attached to the Transfer user.
 *
 * ## Usage
 * ```hcl
 * module "sftp_user_alice" {
 *   source                = "trussworks/sftp-user/aws"
 *   version               = "~> 1.0.0"
 *
 *   sftp_server_id            = aws_transfer_server.my_app_sftp.id
 *   ssh_public_keys           = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 example@example.com"]
 *   user_name                 = "alice"
 *   role_name                 = "alice-sftp-role"
 *   home_directory_bucket     = "myapp_sftp_bucket"
 *   home_directory_key_prefix = "alice/"
 *   allowed_actions = [
 *     "s3:GetObject",
 *     "s3:GetObjectACL",
 *     "s3:PutObject",
 *     "s3:PutObjectACL",
 *   ]
 *   tags = {
 *     Application = "my_app"
 *     Environment = "prod"
 *   }
 * }
 * ```
 */

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
  name   = format("%s-policy", aws_iam_role.main.name)
  role   = aws_iam_role.main.name
  policy = data.aws_iam_policy_document.role_policy_doc.json
}

resource "aws_transfer_user" "main" {
  server_id      = var.sftp_server_id
  user_name      = var.user_name
  role           = aws_iam_role.main.arn
  home_directory = format("/%s/%s", var.home_directory_bucket.id, var.home_directory_key_prefix)

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
