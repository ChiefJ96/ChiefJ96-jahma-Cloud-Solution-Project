// modules/instance_web/variables.tf
variable "ami" {
  description = "AMI ID for the web tier instances"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 8
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

variable "subnet_ids" {
  description = "List of subnet IDs where instances will be launched"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to instances"
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "Base64 encoded user data script to run on instance startup"
  type        = string
  default     = ""
}

variable "iam_instance_profile" {
  description = "IAM instance profile name for EC2 instances"
  type        = string
  default     = null
}