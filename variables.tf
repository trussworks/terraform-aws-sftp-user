variable "user_name" {
  description = "The name of the user"
  type        = string
}

variable "role_name" {
  description = "The name of the IAM role for the SFTP user"
  type        = string
}

variable "home_directory_bucket_arn" {
  description = "The ARN of the S3 Bucket to use as the home directory"
  type        = string
}

variable "home_directory_bucket_id" {
  description = "The ID of the S3 Bucket to use as the home directory"
  type        = string
}

variable "sftp_server_id" {
  description = "Server ID of the AWS Transfer Server (aka SFTP Server)"
  type        = string
}

variable "ssh_public_keys" {
  description = "Public SSH key for the user.  If none specified, then"
  type        = list(string)
  default     = []
}
