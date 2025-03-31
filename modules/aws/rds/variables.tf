variable "is_multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = true
}

variable "storage_size" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 0
}

variable "storage_type" {
  description = "A storage type"
  type        = string
  default     = "gp2"
}

variable "max_storage_size" {
  description = "Apper allocated storage limit in gigabytes"
  type        = number
  default     = null
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "t3.small"
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
  default     = "postgres"
}

variable "password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
  default     = "password"
}

variable "db_name" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = null
}

variable "name" {
  description = "The DB identifier"
  type        = string
  default     = ""
}

variable "from_rds_snapshot_id" {
  description = "Set snaphot name"
  type        = string
  default     = null
}

variable "sg_name" {
  type        = string
  default     = ""
  description = "Optional Security Group name. Value of var.name if undefined"
}

variable "sg_descr" {
  type        = string
  default     = null
  description = "Optional Security Group description"
}

variable "allow_sg_ids" {
  description = "SG ids allowed to access RDS instance"
  type        = list(string)
  default     = []
}

variable "allow_cidrs" {
  description = "CIDRs allowed to access RDS instance"
  type        = list(string)
  default     = []
}

variable "allow_egress_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of allowed egress cidrs. Default allow all"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window. Defaults to true."
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 5
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "RDS instance protection from delete"
  type        = bool
  default     = false
}

variable "iam_database_authentication_enabled" {
  description = "Allow IAM RDS authentication"
  type        = bool
  default     = true
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = null
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "15.8"
}

variable "skip_final_snapshot" {
  description = "(Optional) Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier."
  type        = bool
  default     = false
}

variable "parameters" {
  description = "RDS Parameter group settings"
  type        = list(map(string))
  default = [
    {
      name         = "rds.force_ssl"
      value        = "1"
      apply_method = "pending-reboot"
    },
    {
      name         = "rds.logical_replication"
      value        = "1"
      apply_method = "pending-reboot"
    }
  ]
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = ""
}
variable "subnet_ids" {
  description = "Instance subnet ids"
  type        = list(string)
}

variable "subnet_group_name" {
  type    = string
  default = null
}

variable "subnet_group_description" {
  type    = string
  default = null
}

variable "copy_tags_to_snapshot" {
  type    = bool
  default = false
}

variable "subnet_group_create" {
  type    = bool
  default = true
}

variable "apply_immediately" {
  type        = bool
  default     = false
  description = "Apply all changes immediately"
}

variable "ca_cert_identifier" {
  type        = string
  default     = "rds-ca-rsa4096-g1"
  description = "The identifier of the CA certificate for the DB instance"
}

variable "performance_insights_enabled" {
  type        = bool
  default     = false
  description = "Whether Performance Insights are enabled. Free when performance_insights_retention_period set to 7 days"
}

variable "performance_insights_retention_period" {
  type        = number
  default     = 0
  description = "Amount of time in days to retain Performance Insights data. Valid values are 0 (off), 7, 731 (2 years) or a multiple of 31"
}

variable "db_replica" {
  type = map(any)
  default = {
    is_set                     = false # On/Off flag
    cross_region               = false # Create own separate resources as param_group and subnet_group
    source_db                  = null  # Specify db to replicate from
    kms_key_arn                = null  # Use kms replica key of rds master in replica region
  }
}

variable "custom_kms_key" {
  type        = bool
  default     = false
  description = "Used for vault CRR"
}

variable "storage_encrypted" {
  description = "Whether the RDS instance should have encrypted storage"
  type        = bool
  default     = false
}

variable "enable_public_access" {
  description = "Whether the RDS instance should be publicly accessible"
  type        = bool
  default     = false
}
