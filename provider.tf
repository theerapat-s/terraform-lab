# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  region                   = "ap-southeast-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = var.aws_profile

  default_tags {
    tags = var.default_tags
  }
}