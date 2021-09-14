variable "instance_type" {
  type        = string
  description = "AMI instance type"
  # default     = "t3.small"
}

variable "name" {
  type        = string
  description = "Instance's name"
  default     = "Tutorial"
}