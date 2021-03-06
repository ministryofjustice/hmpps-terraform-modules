####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################

locals {
  policy_file                   = "ec2_policy.json"
  role_policy_file              = "policies/bastion_policy.json"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "vpc/terraform.tfstate"
    region = "${var.region}"
  }
}

data "aws_route53_zone" "hosted_zone" {
  name = "${var.route53_sub_domain}.${var.route53_domain_private}"
}
