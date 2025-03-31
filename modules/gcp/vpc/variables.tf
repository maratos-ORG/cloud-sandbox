variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = ""
}

variable "subnet_cidrs" {
  description = "CIDRs List"
  type        = list(string)
  default     = []
}

variable "subnet_names" {
  type    = list(string)
  default = []
}
