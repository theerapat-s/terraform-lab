# ---------------------------------------------
# AWS Profiles
# ---------------------------------------------

aws_profile = "terraform-lab" //AWS Profile name of target account

# ---------------------------------------------
# Project Information
# ---------------------------------------------

owner = "mao"

default_tags = {
  "Project" = "terraform-lab"
  "Owner"   = "mao"
}

# ---------------------------------------------
# VPC
# ---------------------------------------------

vpc_id = "vpc-021bfe6c01daf3900"
pri_subnet_id_a = "subnet-07ee70ebc10b98768"
pri_subnet_id_b = "subnet-04b7513992f9cf5b3"
pub_subnet_id_a = "subnet-0f94d52fcbefa7f0b"
pub_subnet_id_b = "subnet-0a80c4fe68aab6e8b"


ec2_instance_type = "t3a.nano"