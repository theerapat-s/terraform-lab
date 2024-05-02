# ---------------------------------------------
# Global variable
# ---------------------------------------------

variable "aws_profile" {
  type        = string
  description = "AWS Profile name"
}

variable "default_tags" {
    type = map(string)
    description = "Default Resouces taging"
}

variable "owner" {
  type = string
  description = "Name of resources owner"
}

variable "vpc_id" {}

variable "pri_subnet_id_a" {}

variable "pri_subnet_id_b" {}

variable "pub_subnet_id_a" {}

variable "pub_subnet_id_b" {}

# ---------------------------------------------
# EC2
# ---------------------------------------------

variable "ec2_instance_type" {}

data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}