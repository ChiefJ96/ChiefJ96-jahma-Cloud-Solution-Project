
variable "name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "my-vpc"
}

variable "environment" {
  description = "Environment name (e.g., Development, Production)"
  type        = string
  default     = "Development"
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnets" {
  description = "Map of subnet configurations with keys as subnet names"
  type = map(object({
    type              = string          # "public" or "private"
    availability_zone = string
    cidr_block        = string
  }))
  default = {
    "dev-public-1a" = {
      type              = "public"
      availability_zone = "us-west-1a"
      cidr_block        = "10.0.0.0/24"
    }
    "dev-private-1a" = {
      type              = "private"
      availability_zone = "us-west-1a"
      cidr_block        = "10.0.16.0/24"
    }
    "dev-db-1a" = {
      type              = "private"
      availability_zone = "us-west-1a"
      cidr_block        = "10.0.32.0/24"
    }
    "dev-public-1b" = {
      type              = "public"
      availability_zone = "us-west-1b"
      cidr_block        = "10.0.48.0/24"
    }
    "dev-private-1b" = {
      type              = "private"
      availability_zone = "us-west-1b"
      cidr_block        = "10.0.64.0/24"
    }
    "dev-db-1b" = {
      type              = "private"
      availability_zone = "us-west-1b"
      cidr_block        = "10.0.80.0/24"
    }
  }
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}