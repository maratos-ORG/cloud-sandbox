terraform {
  backend "gcs" {
    bucket = "14c12ce0ade03cef-terraform-remote-backend"
    prefix = "staging/maratos_cluster1/terraform.tfstate"  # Change this per environment
  }
}