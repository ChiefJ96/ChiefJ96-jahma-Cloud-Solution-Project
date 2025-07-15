
variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "tags" {
  description = "Tags to add to all security groups"
  type        = map(string)
  default     = {}
}