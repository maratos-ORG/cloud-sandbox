###----------CHANGE_SECTION----------
### Please change project_name and locals
variable "project_name" {
  description = "Project name to be used in resource naming"
  type        = string
  default     = "maratos"
}

locals {
  subnet_names_gcp  = ["${var.project_name}-stg"]
  location_name_gcp = "stg-${var.project_name}-01-gcp"
  vpc_name_gcp      = "vpc-${var.project_name}-stg"
  vpc_cidr_gcp      = ["10.100.0.0/20"] 
}

# ------------------------------
variable "availability_zones_gcp" {
  type    = list(string)
  default = ["europe-west1-c"]
}

variable "regions" {
  type = map(string)
  default = {
    gcp = "europe-west1"
  }
}

variable "tags_gcp" {
  type = map(string)
  default = {
    managed_by  = "terraform"
    customer    = "maratos"
    environment = "sraging"
    project     = "maratos"
    team        = "dba"
  }
}

