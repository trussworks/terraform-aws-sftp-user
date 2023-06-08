Creates a user for an AWS Transfer for SFTP endpoint.

Creates the following resources:

* AWS Transfer user
* IAM policy for the user to access S3.
* SSH Keys attached to the Transfer user.

## Usage

```hcl
module "sftp_user_alice" {
  source                = "trussworks/sftp-user/aws"
  version               = "~> 1.0.0"

  sftp_server_id            = aws_transfer_server.my_app_sftp.id
  ssh_public_keys           = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 example@example.com"]
  user_name                 = "alice"
  role_name                 = "alice-sftp-role"
  home_directory_bucket     = "myapp_sftp_bucket"
  home_directory_key_prefix = "alice/"
  allowed_actions = [
    "s3:GetObject",
    "s3:GetObjectACL",
    "s3:PutObject",
    "s3:PutObjectACL",
  ]
  tags = {
    Application = "my_app"
    Environment = "prod"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.70 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.70 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_transfer_ssh_key.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_ssh_key) | resource |
| [aws_transfer_user.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_user) | resource |
| [aws_iam_policy_document.assume_role_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.role_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_actions"></a> [allowed\_actions](#input\_allowed\_actions) | A list of allowed actions for objects in the backend bucket. | `list(string)` | <pre>[<br>  "s3:GetObject",<br>  "s3:GetObjectACL",<br>  "s3:GetObjectVersion",<br>  "s3:PutObject",<br>  "s3:PutObjectACL",<br>  "s3:DeleteObject",<br>  "s3:DeleteObjectVersion"<br>]</pre> | no |
| <a name="input_home_directory_bucket"></a> [home\_directory\_bucket](#input\_home\_directory\_bucket) | The S3 Bucket to use as the home directory | <pre>object({<br>    arn = string<br>    id  = string<br>  })</pre> | n/a | yes |
| <a name="input_home_directory_key_prefix"></a> [home\_directory\_key\_prefix](#input\_home\_directory\_key\_prefix) | The home directory key prefix | `string` | `""` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | The name of the IAM role for the SFTP user. Either `role_name` or `role_arn` must be provided, not both. | `string` | `""` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | The name of the IAM role for the SFTP user. Either `role_name` or `role_arn` must be provided, not both. | `string` | `""` | no |
| <a name="input_sftp_server_id"></a> [sftp\_server\_id](#input\_sftp\_server\_id) | Server ID of the AWS Transfer Server (aka SFTP Server) | `string` | n/a | yes |
| <a name="input_ssh_public_keys"></a> [ssh\_public\_keys](#input\_ssh\_public\_keys) | Public SSH key for the user.  If list is empty, then no SSH Keys are setup to authenticate as the user. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources | `map(string)` | `{}` | no |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | The name of the user | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
