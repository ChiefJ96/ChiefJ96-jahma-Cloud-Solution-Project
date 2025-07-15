// modules/instance_app/variables.tf
variable "ami" {
  description = "AMI ID for the app tier instances"
  type        = string
  default     = "ami-0c02fb55956c7d316"  # Amazon Linux 2 latest (update as needed)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 16
}

variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Tags to apply to the instances"
  type        = map(string)
  default     = {}
}

variable "key_name" {
  description = "SSH key pair name for access"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "KMS Key ID for EBS encryption"
  type        = string
  default     = null
}