<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed\_actions | A list of allowed actions for objects in the backend bucket. | list(string) | `[ "s3:GetObject", "s3:GetObjectACL", "s3:GetObjectVersion", "s3:PutObject", "s3:PutObjectACL", "s3:DeleteObject", "s3:DeleteObjectVersion" ]` | no |
| home\_directory\_bucket | The S3 Bucket to use as the home directory | object | n/a | yes |
| home\_directory\_key\_prefix | The home directory key prefix | string | `""` | no |
| role\_name | The name of the IAM role for the SFTP user | string | n/a | yes |
| sftp\_server\_id | Server ID of the AWS Transfer Server (aka SFTP Server) | string | n/a | yes |
| ssh\_public\_keys | Public SSH key for the user.  If none specified, then | list(string) | `[]` | no |
| tags | A mapping of tags to assign to all resources | map(string) | `{}` | no |
| user\_name | The name of the user | string | n/a | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
