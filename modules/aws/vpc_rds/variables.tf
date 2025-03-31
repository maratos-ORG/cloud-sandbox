variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "location_name" {
  description = "Location name"
  type        = string
}

variable "env_name" {
  description = "Environment name"
  type        = map(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "vpc_id" {
  description = "VPC ID if using an existing VPC"
  type        = string
  default     = ""
}

variable "subnet_cidrs" {
  description = "List of specific CIDR blocks for subnets. If not provided, subnets will be created with /28 mask."
  type        = list(string)
  default     = []
}

variable "enable_public_access" {
  description = "Enable public access for the VPC"
  type        = bool
  default     = false
}

