
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "allowed_principals" {
  description = "List of AWS principals allowed to access the bucket"
  type        = list(string)
  default     = ["*"]
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}