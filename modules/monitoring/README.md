###Module to create a monitoring server and ElasticSearch Cluster

```hcl-terraform
terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 1.16"
}

#-------------------------------------------------------------
### Getting aws_caller_identity
#-------------------------------------------------------------
data "aws_caller_identity" "current" {}

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
### Getting the bastion vpc
#-------------------------------------------------------------
data "terraform_remote_state" "bastion_remote_vpc" {
  backend = "s3"

  config {
    bucket   = "${var.bastion_remote_state_bucket_name}"
    key      = "bastion-vpc/terraform.tfstate"
    region   = "${var.region}"
    role_arn = "${var.bastion_role_arn}"
  }
}

#-------------------------------------------------------------
### Getting the sub project security groups
#-------------------------------------------------------------
data "terraform_remote_state" "vpc_security_groups" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "security-groups/terraform.tfstate"
    region = "${var.region}"
  }
}

locals {
  availability_zones      = [
    "${data.terraform_remote_state.vpc.vpc_private-subnet-az1-availability_zone}",
    "${data.terraform_remote_state.vpc.vpc_private-subnet-az2-availability_zone}",
    "${data.terraform_remote_state.vpc.vpc_private-subnet-az3-availability_zone}",
  ]
  private_subnet_ids      = [
    "${data.terraform_remote_state.vpc.vpc_private-subnet-az1}",
    "${data.terraform_remote_state.vpc.vpc_private-subnet-az2}",
    "${data.terraform_remote_state.vpc.vpc_private-subnet-az3}"
  ]

  public_subnet_ids       = [
    "${data.terraform_remote_state.vpc.vpc_public-subnet-az1}",
    "${data.terraform_remote_state.vpc.vpc_public-subnet-az2}",
    "${data.terraform_remote_state.vpc.vpc_public-subnet-az3}"
  ]

  bastion_origin_sgs      = [
    "${data.terraform_remote_state.vpc_security_groups.sg_ssh_bastion_in_id}"
  ]

  instance_type           = "t2.large"
  ebs_device_volume_size  = "2048"
  docker_image_tag        = "latest"
  route53_sub_domain      = "${var.environment_type}.${var.project_name}"
  account_id              = "${data.aws_caller_identity.current.account_id}"
}

module "create_elastic_cluster" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=refactorMonitoringIntoModule//modules/monitoring/elasticsearch-cluster"

  app_name                      = "es-clust"
  instance_type                 = "${local.instance_type}"
  ebs_device_volume_size        = "${local.ebs_device_volume_size}"
  docker_image_tag              = "${local.docker_image_tag}"
  availability_zones            = "${local.availability_zones}"
  short_environment_identifier  = "${var.short_environment_identifier}"
  bastion_origin_cidr           = "${data.terraform_remote_state.bastion_remote_vpc.bastion_vpc_cidr}"
  environment_identifier        = "${var.environment_identifier}"
  region                        = "${var.region}"
  route53_sub_domain            = "${local.route53_sub_domain}"
  amazon_ami_id                 = "${data.aws_ami.amazon_ami.id}"
  bastion_origin_cidr           = "${data.terraform_remote_state.bastion_remote_vpc.bastion_vpc_cidr}"
  bastion_origin_sgs            = "${local.bastion_origin_sgs}"

  private_zone_name             = "${data.terraform_remote_state.vpc.private_zone_name}"
  private_zone_id               = "${data.terraform_remote_state.vpc.private_zone_id}"
  account_id                    = "${local.account_id}"
  tags                          = "${data.terraform_remote_state.vpc.tags}"
  ssh_deployer_key              = "${data.terraform_remote_state.vpc.ssh_deployer_key}"
  subnet_ids                    = "${local.private_subnet_ids}"
  vpc_id                        = "${data.terraform_remote_state.vpc.vpc_id}"
  vpc_cidr                      = "${data.terraform_remote_state.vpc.vpc_cidr_block}"
  s3-config-bucket              = "${var.remote_state_bucket_name}"
}

module "create_monitoring_instance" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=refactorMonitoringIntoModule//modules/monitoring/monitoring-server"

  app_name                            = "mon-srv"
  amazon_ami_id                       = "${data.aws_ami.amazon_ami.id}"
  whitelist_monitoring_ips            = "${var.whitelist_monitoring_ips}"
  instance_type                       = "${local.instance_type}"
  ebs_device_volume_size              = "${local.ebs_device_volume_size}"
  docker_image_tag                    = "${local.docker_image_tag}"
  availability_zones                  = "${local.availability_zones}"
  short_environment_identifier        = "${var.short_environment_identifier}"
  environment_identifier              = "${var.environment_identifier}"
  region                              = "${var.region}"
  route53_sub_domain                  = "${local.route53_sub_domain}"
  route53_domain_private              = "${var.route53_domain_private}"
  route53_hosted_zone_id              = "${var.route53_hosted_zone_id}"
  public_ssl_arn                      = "${var.public_ssl_arn}"
  bastion_origin_cidr                 = "${data.terraform_remote_state.bastion_remote_vpc.bastion_vpc_cidr}"
  bastion_origin_sgs                  = "${local.bastion_origin_sgs}"

  private_zone_name                   = "${data.terraform_remote_state.vpc.private_zone_name}"
  private_zone_id                     = "${data.terraform_remote_state.vpc.private_zone_id}"
  account_id                          = "${local.account_id}"
  tags                                = "${data.terraform_remote_state.vpc.tags}"
  ssh_deployer_key                    = "${data.terraform_remote_state.vpc.ssh_deployer_key}"
  subnet_ids                          = "${local.private_subnet_ids}"
  public_subnet_ids                   = "${local.public_subnet_ids}"
  vpc_id                              = "${data.terraform_remote_state.vpc.vpc_id}"
  vpc_cidr                            = "${data.terraform_remote_state.vpc.vpc_cidr_block}"
  s3-config-bucket                    = "${var.remote_state_bucket_name}"
  elasticsearch_cluster_name          = "${module.create_elastic_cluster.elasticsearch_cluster_name}"
  elasticsearch_cluster_sg_client_id  = "${module.create_elastic_cluster.elasticsearch_cluster_sg_client_id}"
}


```

@todo lookup the arn and subdomains from the vpc creation bit