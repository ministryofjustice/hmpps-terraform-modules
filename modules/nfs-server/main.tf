####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################

#-------------------------------------------------------------
### Getting the latest amazon ami
#-------------------------------------------------------------
data "aws_ami" "amazon_ami" {
  most_recent = true
  owners      = ["895523100917"]

  filter {
    name   = "name"
    values = ["HMPPS Base CentOS master *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

#-------------------------------------------------------------
### Getting the current vpc
#-------------------------------------------------------------
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

#-------------------------------------------------------------
### Declare our local variables
#-------------------------------------------------------------
locals {
  app_name = var.app_name
  bucket_list = [
    "arn:aws:s3:::tf-eu-west-2-hmpps-eng-${var.bastion_inventory}-config-s3bucket",
    "arn:aws:s3:::tf-eu-west-2-hmpps-eng-${var.bastion_inventory}-config-s3bucket/*"
  ]

  device_list         = ["/dev/xvdc", "/dev/xvdd", "/dev/xvde"]
  logical_volume_name = "${local.app_name}_data"
  mount_point         = "/data"
  volume_group_name   = "${local.app_name}.vg"
}

