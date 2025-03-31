provider "google" {
  project = "dba-test-430310"
  region  = var.regions.gcp
}

terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.80.0"
    }
  }
}
