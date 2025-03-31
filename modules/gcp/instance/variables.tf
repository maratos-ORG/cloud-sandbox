variable "name" {
  description = "Name of instance"
  type        = string
}

variable "system_disk_size" {
  description = "Disk size"
  type        = number
  default     = 20
}

variable "instance_type" {
  # https://cloud.google.com/compute/docs/machine-types
  description = "Instance type"
  type        = string
  default     = "e2-medium"
}

variable "image_id" {
  description = "System image"
  type        = string
  default     = "ubuntu-2004-lts"
}

variable "tags" {
  description = "map of tags assigned to resources"
  type        = map(string)
  default     = {}
}

variable "additional_user_data" {
  description = "Additional user data - added to the end of the default one hardcoded in the module"
  type        = string
  default     = ""
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "subnet_ids" {
  type        = list(string)
  description = "VPC Subnet id"
  default     = []
}

variable "number_of_instances" {
  description = "Instances count"
  type        = number
  default     = 1
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "security_rules" {
  description = "A list of security rules"
  type        = list(map(string))
  default = [
    {
      proto       = "all"
      type        = "ingress"
      port_range  = "0/0"
      cidr_ip     = "0.0.0.0/0"
      policy      = "accept"
      description = "Accept all inbound traffic"
    }
  ]
}
variable "hostname_use_public_ip" {
  default     = false
  description = "If this variable is set to true AND host has a public EIP the hostname in JC will contain this public EIP address instead of a private address for more convenient connecting via SSH"
}

variable "associate_eip" {
  type    = bool
  default = false
}

variable "volumes" {
  default = []
}

variable "use_num_suffix" {
  default = true
}

variable "provision_project_ssh_keys" {
  description = "Enable provisioning of project-wide SSH keys"
  type        = bool
  default     = false 
}