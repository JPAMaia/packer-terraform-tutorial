variable "instance_type" {
  type        = string
  description = "AMI instance type"
  # default     = "t3.small"
}

variable "vault_file" {
  type        = string
  description = "Location of Ansible's vault file"
  default     = "/etc/ansible/.vault_pass"
}
