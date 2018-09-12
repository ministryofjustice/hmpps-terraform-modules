terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 1.16"
}

locals {
  policy_file                   = "ec2_policy.json"
  role_policy_file              = "policies/ec2_role_policy.json"
  ebs_device_mount_point        = "/dev/xvdb"
  elasticsearch_root_directory  = "/srv"
  docker_registry_url           = "mojdigitalstudio"
}

##################################
# Elasticsearch-1
##################################

data "template_file" "create_elasticsearch_1_user_data" {
  template = "${file("${path.module}/user_data/es_node_user_data.sh")}"

  vars {
    es_home               = "${local.elasticsearch_root_directory}"
    ebs_device            = "${local.ebs_device_mount_point}"
    app_name              = "${var.app_name}"
    env_identifier        = "${var.environment_identifier}"
    short_env_identifier  = "${var.short_environment_identifier}"
    route53_sub_domain    = "${var.route53_sub_domain}"
    private_domain        = "${var.private_zone_name}"
    account_id            = "${var.account_id}"
    internal_domain       = "${var.private_zone_name}"
    version               = "${var.docker_image_tag}"
    aws_cluster           = "${var.short_environment_identifier}-${var.app_name}"
    registry_url          = "${local.docker_registry_url}"
    instance_identifier   = "1"
  }
}

module "create_elasticsearch_instance_1" {
  # Instance
  source                      = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=refactorMonitoringIntoModule//modules//monitoring/elasticsearch-instance"
  app_name                    = "${var.environment_identifier}-${var.app_name}-es-node"
  environment_identifier      = "${var.environment_identifier}"
  ami_id                      = "${var.amazon_ami_id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_ids[0]}"
  instance_profile            = "${module.create_elasticsearch_iam_instance_profile.iam_instance_name}"
  user_data                   = "${data.template_file.create_elasticsearch_1_user_data.rendered}"
  instance_tags               = "${merge(
                                    var.tags,
                                    map("Name", "${var.environment_identifier}-es-node"),
                                    map("HMPPS_ROLE", "${var.app_name}"),
                                    map("HMPPS_STACKNAME", "${var.environment_identifier}"),
                                    map("HMPPS_STACK", "${var.short_environment_identifier}"),
                                    map("HMPPS_FQDN", "elasticsearch-1.${var.private_zone_name}")
                                    )}"
  ssh_deployer_key            = "${var.ssh_deployer_key}"
  security_groups             = [
    "sg-01e37db318a75d51a",
    "${aws_security_group.elasticsearch_client_sg.id}",
  ]
  # Volume
  volume_tags                 = "${var.tags}"
  volume_availability_zone    = "${var.availability_zones[0]}"
  volume_size                 = "${var.ebs_device_volume_size}"

  #Route53
  instance_id                 = 1
  zone_id                     = "${var.private_zone_id}"
  zone_name                   = "${var.private_zone_name}"
}

##################################
# Elasticsearch-2
##################################

data "template_file" "create_elasticsearch_2_user_data" {
   template = "${file("${path.module}/user_data/es_node_user_data.sh")}"

  vars {
    es_home               = "${local.elasticsearch_root_directory}"
    ebs_device            = "${local.ebs_device_mount_point}"
    app_name              = "${var.app_name}"
    env_identifier        = "${var.environment_identifier}"
    short_env_identifier  = "${var.short_environment_identifier}"
    route53_sub_domain    = "${var.route53_sub_domain}"
    private_domain        = "${var.private_zone_name}"
    account_id            = "${var.account_id}"
    internal_domain       = "${var.private_zone_name}"
    version               = "${var.docker_image_tag}"
    aws_cluster           = "${var.short_environment_identifier}-${var.app_name}"
    registry_url          = "${local.docker_registry_url}"
    instance_identifier   = "2"
  }
}

module "create_elasticsearch_instance_2" {
  # Instance
  source                      = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=refactorMonitoringIntoModule//modules//monitoring/elasticsearch-instance"
  app_name                    = "${var.environment_identifier}-${var.app_name}-es-node"
  environment_identifier      = "${var.environment_identifier}"
  ami_id                      = "${var.amazon_ami_id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_ids[1]}"
  instance_profile            = "${module.create_elasticsearch_iam_instance_profile.iam_instance_name}"
  user_data                   = "${data.template_file.create_elasticsearch_2_user_data.rendered}"
  instance_tags               = "${merge(
                                    var.tags,
                                    map("Name", "${var.environment_identifier}-es-node"),
                                    map("HMPPS_ROLE", "${var.app_name}"),
                                    map("HMPPS_STACKNAME", "${var.environment_identifier}"),
                                    map("HMPPS_STACK", "${var.short_environment_identifier}"),
                                    map("HMPPS_FQDN", "elasticsearch-2.${var.private_zone_name}")
                                    )}"
  ssh_deployer_key            = "${var.ssh_deployer_key}"
  security_groups             = [
    "sg-01e37db318a75d51a",
    "${aws_security_group.elasticsearch_client_sg.id}",
  ]
  # Volume
  volume_tags                 = "${var.tags}"
  volume_availability_zone    = "${var.availability_zones[1]}"
  volume_size                 = "${var.ebs_device_volume_size}"

  #Route53
  instance_id                 = 2
  zone_id                     = "${var.private_zone_id}"
  zone_name                   = "${var.private_zone_name}"
}

##################################
# Elasticsearch-3
##################################

data "template_file" "create_elasticsearch_3_user_data" {
   template = "${file("${path.module}/user_data/es_node_user_data.sh")}"

  vars {
    es_home               = "${local.elasticsearch_root_directory}"
    ebs_device            = "${local.ebs_device_mount_point}"
    app_name              = "${var.app_name}"
    env_identifier        = "${var.environment_identifier}"
    short_env_identifier  = "${var.short_environment_identifier}"
    route53_sub_domain    = "${var.route53_sub_domain}"
    private_domain        = "${var.private_zone_name}"
    account_id            = "${var.account_id}"
    internal_domain       = "${var.private_zone_name}"
    version               = "${var.docker_image_tag}"
    aws_cluster           = "${var.short_environment_identifier}-${var.app_name}"
    registry_url          = "${local.docker_registry_url}"
    instance_identifier   = "3"
  }
}

module "create_elasticsearch_instance_3" {
  # Instance
  source                      = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=refactorMonitoringIntoModule//modules//monitoring/elasticsearch-instance"
  app_name                    = "${var.environment_identifier}-${var.app_name}-es-node"
  environment_identifier      = "${var.environment_identifier}"
  ami_id                      = "${var.amazon_ami_id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_ids[2]}"
  instance_profile            = "${module.create_elasticsearch_iam_instance_profile.iam_instance_name}"
  user_data                   = "${data.template_file.create_elasticsearch_3_user_data.rendered}"
  instance_tags               = "${merge(
                                    var.tags,
                                    map("Name", "${var.environment_identifier}-es-node"),
                                    map("HMPPS_ROLE", "${var.app_name}"),
                                    map("HMPPS_STACKNAME", "${var.environment_identifier}"),
                                    map("HMPPS_STACK", "${var.short_environment_identifier}"),
                                    map("HMPPS_FQDN", "elasticsearch-3.${var.private_zone_name}")
                                    )}"
  ssh_deployer_key            = "${var.ssh_deployer_key}"
  security_groups             = [
    "sg-01e37db318a75d51a",
    "${aws_security_group.elasticsearch_client_sg.id}",
  ]
  # Volume
  volume_tags                 = "${var.tags}"
  volume_availability_zone    = "${var.availability_zones[2]}"
  volume_size                 = "${var.ebs_device_volume_size}"

  #Route53
  instance_id                 = 3
  zone_id                     = "${var.private_zone_id}"
  zone_name                   = "${var.private_zone_name}"
}
