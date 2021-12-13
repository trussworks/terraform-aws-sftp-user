variable "user_name" {
  description = "The name of the user"
  type        = string
}

variable "role_name" {
  description = "The name of the IAM role for the SFTP user. Either `role_name` or `role_arn` must be provided, not both."
  type        = string
}

variable "role_arn" {
  description = "The ARN of a custom IAM role for the SFTP user."
  type        = string
  default     = ""
}

variable "additional_role_statements" {
  type        = map(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))
  description = "List of additional statements that will be added to the role assigned to the SFTP user."
  default     = {}
}

variable "home_directory_bucket" {
  description = "The S3 Bucket to use as the home directory"
  type = object({
    arn = string
    id  = string
  })
}

variable "home_directory_key_prefix" {
  description = "The home directory key prefix"
  type        = string
  default     = ""
}

variable "sftp_server_id" {
  description = "Server ID of the AWS Transfer Server (aka SFTP Server)"
  type        = string
}

variable "ssh_public_keys" {
  description = "Public SSH key for the user.  If list is empty, then no SSH Keys are setup to authenticate as the user."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "allowed_actions" {
  description = "A list of allowed actions for objects in the backend bucket."
  type        = list(string)
  default = [
    "s3:GetObject",
    "s3:GetObjectACL",
    "s3:GetObjectVersion",
    "s3:PutObject",
    "s3:PutObjectACL",
    "s3:DeleteObject",
    "s3:DeleteObjectVersion"
  ]
}
