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

##################################
# Elasticsearch-1
##################################

data "template_file" "create_elasticsearch_1_user_data" {
  template = "${file("user_data/es_node_user_data.sh")}"

  vars {
    es_home               = "${var.elasticsearch_root_directory}"
    ebs_device            = "${var.ebs_device_mount_point}"
    app_name              = "${var.app_name}"
    env_identifier        = "${var.environment_identifier}"
    short_env_identifier  = "${var.short_environment_identifier}"
    route53_sub_domain    = "${var.route53_sub_domain}"
    private_domain        = "${data.terraform_remote_state.vpc.private_zone_name}"
    account_id            = "${data.terraform_remote_state.vpc.account_id}"
    internal_domain       = "${data.terraform_remote_state.vpc.private_zone_name}"
    version               = "${var.docker_image_tag}"
    aws_cluster           = "${var.short_environment_identifier}-${var.app_name}"
    registry_url          = "${var.docker_registry_url}"
    instance_identifier   = "1"
  }
}

module "create_elasticsearch_instance_1" {
  # Instance
  source                      = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//elasticsearch-instance"
  app_name                    = "${var.environment_identifier}-${var.app_name}-es-node"
  environment_identifier      = "${var.environment_identifier}"
  ami_id                      = "${data.aws_ami.amazon_ami.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${data.terraform_remote_state.vpc.private-subnet-az1}"
  instance_profile            = "${module.create_elasticsearch_iam_instance_profile.iam_instance_name}"
  user_data                   = "${data.template_file.create_elasticsearch_1_user_data.rendered}"
  instance_tags               = "${merge(
                                    var.tags,
                                    map("Name", "${var.environment_identifier}-es-node"),
                                    map("HMPPS_ROLE", "${var.app_name}"),
                                    map("HMPPS_STACKNAME", "${var.environment_identifier}"),
                                    map("HMPPS_STACK", "${var.short_environment_identifier}"),
                                    map("HMPPS_FQDN", "elasticsearch-1.${data.terraform_remote_state.vpc.private_zone_name}")
                                    )}"
  ssh_deployer_key            = "${data.terraform_remote_state.vpc.ssh_deployer_key}"
  security_groups             = [
    "${var.bastion_client_sg_id}",
    "${data.terraform_remote_state.vpc.vpc_sg_outbound_id}",
    "${aws_security_group.elasticsearch_client_sg.id}",
  ]
  # Volume
  volume_tags                 = "${var.tags}"
  volume_availability_zone    = "${var.availability_zones["az1"]}"
  volume_size                 = "${var.ebs_device_volume_size}"

  #Route53
  instance_id                 = 1
  zone_id                     = "${data.terraform_remote_state.vpc.private_zone_id}"
  zone_name                   = "${data.terraform_remote_state.vpc.private_zone_name}"
}

##################################
# Elasticsearch-2
##################################

data "template_file" "create_elasticsearch_2_user_data" {
   template = "${file("user_data/es_node_user_data.sh")}"

  vars {
    es_home               = "${var.elasticsearch_root_directory}"
    ebs_device            = "${var.ebs_device_mount_point}"
    app_name              = "${var.app_name}"
    env_identifier        = "${var.environment_identifier}"
    short_env_identifier  = "${var.short_environment_identifier}"
    route53_sub_domain    = "${var.route53_sub_domain}"
    private_domain        = "${data.terraform_remote_state.vpc.private_zone_name}"
    account_id            = "${data.terraform_remote_state.vpc.account_id}"
    internal_domain       = "${data.terraform_remote_state.vpc.private_zone_name}"
    version               = "${var.docker_image_tag}"
    aws_cluster           = "${var.short_environment_identifier}-${var.app_name}"
    registry_url          = "${var.docker_registry_url}"
    instance_identifier   = "2"
  }
}

module "create_elasticsearch_instance_2" {
  # Instance
  source                      = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//elasticsearch-instance"
  app_name                    = "${var.environment_identifier}-${var.app_name}-es-node"
  environment_identifier      = "${var.environment_identifier}"
  ami_id                      = "${data.aws_ami.amazon_ami.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${data.terraform_remote_state.vpc.private-subnet-az2}"
  instance_profile            = "${module.create_elasticsearch_iam_instance_profile.iam_instance_name}"
  user_data                   = "${data.template_file.create_elasticsearch_2_user_data.rendered}"
  instance_tags               = "${merge(
                                    var.tags,
                                    map("Name", "${var.environment_identifier}-es-node"),
                                    map("HMPPS_ROLE", "${var.app_name}"),
                                    map("HMPPS_STACKNAME", "${var.environment_identifier}"),
                                    map("HMPPS_STACK", "${var.short_environment_identifier}"),
                                    map("HMPPS_FQDN", "elasticsearch-2${data.terraform_remote_state.vpc.private_zone_name}")
                                    )}"
  ssh_deployer_key            = "${data.terraform_remote_state.vpc.ssh_deployer_key}"
  security_groups             = [
    "${var.bastion_client_sg_id}",
    "${data.terraform_remote_state.vpc.vpc_sg_outbound_id}",
    "${aws_security_group.elasticsearch_client_sg.id}",
  ]
  # Volume
  volume_tags                 = "${var.tags}"
  volume_availability_zone    = "${var.availability_zones["az2"]}"
  volume_size                 = "${var.ebs_device_volume_size}"

  #Route53
  instance_id                 = 2
  zone_id                     = "${data.terraform_remote_state.vpc.private_zone_id}"
  zone_name                   = "${data.terraform_remote_state.vpc.private_zone_name}"
}

##################################
# Elasticsearch-3
##################################

data "template_file" "create_elasticsearch_3_user_data" {
   template = "${file("user_data/es_node_user_data.sh")}"

  vars {
    es_home               = "${var.elasticsearch_root_directory}"
    ebs_device            = "${var.ebs_device_mount_point}"
    app_name              = "${var.app_name}"
    env_identifier        = "${var.environment_identifier}"
    short_env_identifier  = "${var.short_environment_identifier}"
    route53_sub_domain    = "${var.route53_sub_domain}"
    private_domain        = "${data.terraform_remote_state.vpc.private_zone_name}"
    account_id            = "${data.terraform_remote_state.vpc.account_id}"
    internal_domain       = "${data.terraform_remote_state.vpc.private_zone_name}"
    version               = "${var.docker_image_tag}"
    aws_cluster           = "${var.short_environment_identifier}-${var.app_name}"
    registry_url          = "${var.docker_registry_url}"
    instance_identifier   = "3"
  }
}

module "create_elasticsearch_instance_3" {
  # Instance
  source                      = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//elasticsearch-instance"
  app_name                    = "${var.environment_identifier}-${var.app_name}-es-node"
  environment_identifier      = "${var.environment_identifier}"
  ami_id                      = "${data.aws_ami.amazon_ami.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${data.terraform_remote_state.vpc.private-subnet-az3}"
  instance_profile            = "${module.create_elasticsearch_iam_instance_profile.iam_instance_name}"
  user_data                   = "${data.template_file.create_elasticsearch_3_user_data.rendered}"
  instance_tags               = "${merge(
                                    var.tags,
                                    map("Name", "${var.environment_identifier}-es-node"),
                                    map("HMPPS_ROLE", "${var.app_name}"),
                                    map("HMPPS_STACKNAME", "${var.environment_identifier}"),
                                    map("HMPPS_STACK", "${var.short_environment_identifier}"),
                                    map("HMPPS_FQDN", "elasticsearch-3.${data.terraform_remote_state.vpc.private_zone_name}")
                                    )}"
  ssh_deployer_key            = "${data.terraform_remote_state.vpc.ssh_deployer_key}"
  security_groups             = [
    "${var.bastion_client_sg_id}",
    "${data.terraform_remote_state.vpc.vpc_sg_outbound_id}",
    "${aws_security_group.elasticsearch_client_sg.id}",
  ]
  # Volume
  volume_tags                 = "${var.tags}"
  volume_availability_zone    = "${var.availability_zones["az3"]}"
  volume_size                 = "${var.ebs_device_volume_size}"

  #Route53
  instance_id                 = 3
  zone_id                     = "${data.terraform_remote_state.vpc.private_zone_id}"
  zone_name                   = "${data.terraform_remote_state.vpc.private_zone_name}"
}
