# ---------------------------------------------
# Terraform parameter, state backend
# ---------------------------------------------

terraform {
  required_version = "~> 1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47"
      ## check for the latest version https://registry.terraform.io/providers/hashicorp/aws/latest/docs
    }
  }
  backend "local" {
    path = "~/Downloads/terraform.tfstate"
  }
}