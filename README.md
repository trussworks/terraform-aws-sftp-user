<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| home\_directory\_bucket\_arn | The ARN of the S3 Bucket to use as the home directory | string | n/a | yes |
| home\_directory\_bucket\_id | The ID of the S3 Bucket to use as the home directory | string | n/a | yes |
| role\_name | The name of the IAM role for the SFTP user | string | n/a | yes |
| sftp\_server\_id | Server ID of the AWS Transfer Server (aka SFTP Server) | string | n/a | yes |
| ssh\_public\_keys | Public SSH key for the user.  If none specified, then | list(string) | `[]` | no |
| user\_name | The name of the user | string | n/a | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
