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

module "create_elastic_cluster" {
  source = "./elasticsearch-cluster"

  app_name                      = "${var.app_name}-es-cluster"
  instance_type                 = "${var.instance_type}"
  ebs_device_volume_size        = "${var.ebs_device_volume_size}"
  docker_image_tag              = "${var.docker_image_tag}"
  availability_zones            = "${var.availability_zones}"
  short_environment_identifier  = "${var.short_environment_identifier}"
  bastion_client_sg_id          = "${var.bastion_client_sg_id}"
  environment_identifier        = "${var.environment_identifier}"
  region                        = "${var.region}"
  terraform_remote_state_vpc    = "${data.terraform_remote_state.vpc}"
  route53_sub_domain            = "${var.route53_sub_domain}"
  tags                          = "${var.tags}"
  amazon_ami_id                 = "${data.aws_ami.amazon_ami.id}"
}