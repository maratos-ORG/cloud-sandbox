provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket         = "maratos-state-aws-dba-sandbox"
    key            = "terraform-state/env/staging/marat/maratos_cluster1/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = false
    dynamodb_table = "terraform-locks-marat_bogatyrev"
  }
}

# terraform {
#   backend "local" {
#     path = "./terraform.tfstate"
#   }
# }