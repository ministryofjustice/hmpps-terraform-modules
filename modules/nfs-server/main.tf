terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 1.16"
}

####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################

#-------------------------------------------------------------
### Getting the latest amazon ami
#-------------------------------------------------------------
data "aws_ami" "amazon_ami" {
  most_recent = true

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
    name = "root-device-type"
    values = ["ebs"]
  }
}

#-------------------------------------------------------------
### Getting the current vpc
#-------------------------------------------------------------
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "vpc/terraform.tfstate"
    region = "${var.region}"
  }
}

#-------------------------------------------------------------
### Getting the bastion
#-------------------------------------------------------------
data "terraform_remote_state" "bastion" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "bastion/terraform.tfstate"
    region = "${var.region}"
  }
}

#-------------------------------------------------------------
### Getting monitoring
#-------------------------------------------------------------
data "terraform_remote_state" "monitoring" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "shared-monitoring/terraform.tfstate"
    region = "${var.region}"
  }
}

#-------------------------------------------------------------
### Declare our local variables
#-------------------------------------------------------------
locals {
  app_name            = "${var.app_name}"
  bucket_list         = "${concat(
    list("arn:aws:s3:::tf-eu-west-2-hmpps-eng-${var.bastion_inventory}-config-s3bucket"),
    list("arn:aws:s3:::tf-eu-west-2-hmpps-eng-${var.bastion_inventory}-config-s3bucket/*")
  )}"

  device_list         = ["/dev/xvdc", "/dev/xvdd", "/dev/xvde"]
  logical_volume_name = "${local.app_name}_data"
  mount_point         =  "/data"
  volume_group_name   = "${local.app_name}.vg"
}



