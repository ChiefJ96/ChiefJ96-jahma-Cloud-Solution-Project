
variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "security_groups" {
  description = "List of security group IDs to attach to ALB"
  type        = list(string)
}

variable "subnets" {
  description = "List of subnet IDs for ALB"
  type        = list(string)
}

variable "target_group_port" {
  description = "Port for ALB target group"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol for ALB target group"
  type        = string
  default     = "HTTP"
}

variable "vpc_id" {
  description = "VPC ID where ALB and target group will be created"
  type        = string
}

variable "health_check_path" {
  description = "Path for ALB health check"
  type        = string
  default     = "/"
}

variable "health_check_matcher" {
  description = "Matcher for health check response"
  type        = string
  default     = "200-399"
}

variable "listener_port" {
  description = "Listener port on ALB"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Listener protocol on ALB"
  type        = string
  default     = "HTTP"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}