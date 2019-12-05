
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


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed\_actions | A list of allowed actions for objects in the backend bucket. | list(string) | `[ "s3:GetObject", "s3:GetObjectACL", "s3:GetObjectVersion", "s3:PutObject", "s3:PutObjectACL", "s3:DeleteObject", "s3:DeleteObjectVersion" ]` | no |
| home\_directory\_bucket | The S3 Bucket to use as the home directory | object | n/a | yes |
| home\_directory\_key\_prefix | The home directory key prefix | string | `""` | no |
| role\_name | The name of the IAM role for the SFTP user | string | n/a | yes |
| sftp\_server\_id | Server ID of the AWS Transfer Server (aka SFTP Server) | string | n/a | yes |
| ssh\_public\_keys | Public SSH key for the user.  If list is empty, then no SSH Keys are setup to authenticate as the user. | list(string) | `[]` | no |
| tags | A mapping of tags to assign to all resources | map(string) | `{}` | no |
| user\_name | The name of the user | string | n/a | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
